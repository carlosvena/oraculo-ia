import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepository.instance;
});

final workspaceStateProvider = NotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
  WorkspaceStateNotifier.new,
);

class WorkspaceState {
  const WorkspaceState({
    this.notes = const [],
    this.prompts = const [],
    this.experiments = const [],
    this.documents = const [],
    this.favoriteItemIds = const {},
  });

  final List<WorkspaceNote> notes;
  final List<WorkspacePrompt> prompts;
  final List<WorkspaceExperiment> experiments;
  final List<WorkspaceDocument> documents;
  final Set<String> favoriteItemIds; // IDs de lecciones, glosario, manual, laboratorios, proyectos, etc.

  WorkspaceState copyWith({
    List<WorkspaceNote>? notes,
    List<WorkspacePrompt>? prompts,
    List<WorkspaceExperiment>? experiments,
    List<WorkspaceDocument>? documents,
    Set<String>? favoriteItemIds,
  }) {
    return WorkspaceState(
      notes: notes ?? this.notes,
      prompts: prompts ?? this.prompts,
      experiments: experiments ?? this.experiments,
      documents: documents ?? this.documents,
      favoriteItemIds: favoriteItemIds ?? this.favoriteItemIds,
    );
  }
}

class WorkspaceStateNotifier extends Notifier<WorkspaceState> {
  WorkspaceRepository get _repo => ref.read(workspaceRepositoryProvider);

  @override
  WorkspaceState build() {
    return WorkspaceState(
      notes: _repo.notes,
      prompts: _repo.prompts,
      experiments: _repo.experiments,
      documents: _repo.documents,
      favoriteItemIds: _repo.favoriteItemIds,
    );
  }

  // Notas
  Future<void> saveNote(WorkspaceNote note) async {
    await _repo.saveNote(note);
    final idx = state.notes.indexWhere((n) => n.id == note.id);
    final nextNotes = List<WorkspaceNote>.from(state.notes);
    if (idx >= 0) {
      nextNotes[idx] = note;
    } else {
      nextNotes.add(note);
    }
    state = state.copyWith(notes: nextNotes);
  }

  Future<void> deleteNote(String id) async {
    await _repo.deleteNote(id);
    state = state.copyWith(notes: state.notes.where((n) => n.id != id).toList());
  }

  // Prompts
  Future<void> savePrompt(WorkspacePrompt prompt) async {
    await _repo.savePrompt(prompt);
    final idx = state.prompts.indexWhere((p) => p.id == prompt.id);
    final nextPrompts = List<WorkspacePrompt>.from(state.prompts);
    if (idx >= 0) {
      nextPrompts[idx] = prompt;
    } else {
      nextPrompts.add(prompt);
    }
    state = state.copyWith(prompts: nextPrompts);
  }

  Future<void> deletePrompt(String id) async {
    await _repo.deletePrompt(id);
    state = state.copyWith(prompts: state.prompts.where((p) => p.id != id).toList());
  }

  // Experimentos
  Future<void> saveExperiment(WorkspaceExperiment exp) async {
    await _repo.saveExperiment(exp);
    state = state.copyWith(experiments: [...state.experiments, exp]);
  }

  // Documentos
  Future<void> saveDocument(WorkspaceDocument doc) async {
    await _repo.saveDocument(doc);
    state = state.copyWith(documents: [...state.documents, doc]);
  }

  // Favoritos
  Future<void> toggleFavorite(String itemId) async {
    final nextFavs = Set<String>.from(state.favoriteItemIds);
    if (nextFavs.contains(itemId)) {
      nextFavs.remove(itemId);
      await _repo.recordFavoriteRemove(itemId);
    } else {
      nextFavs.add(itemId);
      await _repo.recordFavoriteAdd(itemId);
    }
    state = state.copyWith(favoriteItemIds: nextFavs);
  }

  // Backup Import
  Future<bool> importBackupPayload(String jsonPayload) async {
    final success = await _repo.importBackup(jsonPayload);
    if (success) {
      state = WorkspaceState(
        notes: _repo.notes,
        prompts: _repo.prompts,
        experiments: _repo.experiments,
        documents: _repo.documents,
        favoriteItemIds: _repo.favoriteItemIds,
      );
    }
    return success;
  }
}

class WorkspaceRepository {
  WorkspaceRepository._();
  static final instance = WorkspaceRepository._();

  late final SharedPreferences _prefs;
  bool _initialized = false;

  final List<WorkspaceNote> _notes = [];
  final List<WorkspacePrompt> _prompts = [];
  final List<WorkspaceExperiment> _experiments = [];
  final List<WorkspaceDocument> _documents = [];
  final Set<String> _favoriteItemIds = {};

  bool get isInitialized => _initialized;
  List<WorkspaceNote> get notes => List.unmodifiable(_notes);
  List<WorkspacePrompt> get prompts => List.unmodifiable(_prompts);
  List<WorkspaceExperiment> get experiments => List.unmodifiable(_experiments);
  List<WorkspaceDocument> get documents => List.unmodifiable(_documents);
  Set<String> get favoriteItemIds => Set.unmodifiable(_favoriteItemIds);

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _loadFromLocalStorage();
    _initialized = true;
  }

  void _loadFromLocalStorage() {
    try {
      // 1. Cargar Notas
      final rawNotes = _prefs.getString('ws_notes_v1');
      if (rawNotes != null) {
        final list = jsonDecode(rawNotes) as List<dynamic>;
        _notes.clear();
        _notes.addAll(list.map((item) => WorkspaceNote.fromJson(item as Map<String, dynamic>)));
      }

      // 2. Cargar Prompts
      final rawPrompts = _prefs.getString('ws_prompts_v1');
      if (rawPrompts != null) {
        final list = jsonDecode(rawPrompts) as List<dynamic>;
        _prompts.clear();
        _prompts.addAll(list.map((item) => WorkspacePrompt.fromJson(item as Map<String, dynamic>)));
      }

      // 3. Cargar Experimentos
      final rawExperiments = _prefs.getString('ws_experiments_v1');
      if (rawExperiments != null) {
        final list = jsonDecode(rawExperiments) as List<dynamic>;
        _experiments.clear();
        _experiments.addAll(list.map((item) => WorkspaceExperiment.fromJson(item as Map<String, dynamic>)));
      }

      // 4. Cargar Documentos
      final rawDocs = _prefs.getString('ws_documents_v1');
      if (rawDocs != null) {
        final list = jsonDecode(rawDocs) as List<dynamic>;
        _documents.clear();
        _documents.addAll(list.map((item) => WorkspaceDocument.fromJson(item as Map<String, dynamic>)));
      }

      // 5. Cargar Favoritos
      final rawFavs = _prefs.getString('ws_favorites_v1');
      if (rawFavs != null) {
        final list = jsonDecode(rawFavs) as List<dynamic>;
        _favoriteItemIds.clear();
        _favoriteItemIds.addAll(list.cast<String>());
      }
    } catch (_) {}
  }

  // Métodos de Persistencia

  Future<void> saveNote(WorkspaceNote note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx >= 0) {
      _notes[idx] = note;
    } else {
      _notes.add(note);
    }
    await _prefs.setString('ws_notes_v1', jsonEncode(_notes.map((n) => n.toJson()).toList()));
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _prefs.setString('ws_notes_v1', jsonEncode(_notes.map((n) => n.toJson()).toList()));
  }

  Future<void> savePrompt(WorkspacePrompt prompt) async {
    final idx = _prompts.indexWhere((p) => p.id == prompt.id);
    if (idx >= 0) {
      _prompts[idx] = prompt;
    } else {
      _prompts.add(prompt);
    }
    await _prefs.setString('ws_prompts_v1', jsonEncode(_prompts.map((p) => p.toJson()).toList()));
  }

  Future<void> deletePrompt(String id) async {
    _prompts.removeWhere((p) => p.id == id);
    await _prefs.setString('ws_prompts_v1', jsonEncode(_prompts.map((p) => p.toJson()).toList()));
  }

  Future<void> saveExperiment(WorkspaceExperiment exp) async {
    _experiments.add(exp);
    await _prefs.setString('ws_experiments_v1', jsonEncode(_experiments.map((e) => e.toJson()).toList()));
  }

  Future<void> saveDocument(WorkspaceDocument doc) async {
    _documents.add(doc);
    await _prefs.setString('ws_documents_v1', jsonEncode(_documents.map((d) => d.toJson()).toList()));
  }

  Future<void> recordFavoriteAdd(String itemId) async {
    _favoriteItemIds.add(itemId);
    await _prefs.setString('ws_favorites_v1', jsonEncode(_favoriteItemIds.toList()));
  }

  Future<void> recordFavoriteRemove(String itemId) async {
    _favoriteItemIds.remove(itemId);
    await _prefs.setString('ws_favorites_v1', jsonEncode(_favoriteItemIds.toList()));
  }

  // Backup and Integrity

  String generateBackupPayload() {
    final payload = {
      'notes': _notes.map((n) => n.toJson()).toList(),
      'prompts': _prompts.map((p) => p.toJson()).toList(),
      'experiments': _experiments.map((e) => e.toJson()).toList(),
      'documents': _documents.map((d) => d.toJson()).toList(),
      'favorites': _favoriteItemIds.toList(),
    };
    final serialized = jsonEncode(payload);
    final hash = sha256.convert(utf8.encode(serialized)).toString();
    
    // Devolvemos un envoltorio con hash de integridad
    final wrapper = {
      'checksum': hash,
      'payload': payload,
    };
    return jsonEncode(wrapper);
  }

  Future<bool> importBackup(String rawBackupJson) async {
    try {
      final decoded = jsonDecode(rawBackupJson) as Map<String, dynamic>;
      final checksum = decoded['checksum'] as String;
      final payload = decoded['payload'] as Map<String, dynamic>;

      // Verificar integridad del hash
      final calculatedHash = sha256.convert(utf8.encode(jsonEncode(payload))).toString();
      if (calculatedHash != checksum) {
        return false; // Backup corrupto
      }

      // Descomprimir datos
      final notesList = payload['notes'] as List<dynamic>;
      final promptsList = payload['prompts'] as List<dynamic>;
      final experimentsList = payload['experiments'] as List<dynamic>;
      final documentsList = payload['documents'] as List<dynamic>;
      final favoritesList = payload['favorites'] as List<dynamic>;

      _notes.clear();
      _notes.addAll(notesList.map((item) => WorkspaceNote.fromJson(item as Map<String, dynamic>)));

      _prompts.clear();
      _prompts.addAll(promptsList.map((item) => WorkspacePrompt.fromJson(item as Map<String, dynamic>)));

      _experiments.clear();
      _experiments.addAll(experimentsList.map((item) => WorkspaceExperiment.fromJson(item as Map<String, dynamic>)));

      _documents.clear();
      _documents.addAll(documentsList.map((item) => WorkspaceDocument.fromJson(item as Map<String, dynamic>)));

      _favoriteItemIds.clear();
      _favoriteItemIds.addAll(favoritesList.cast<String>());

      // Escribir todo a SharedPreferences
      await _prefs.setString('ws_notes_v1', jsonEncode(_notes.map((n) => n.toJson()).toList()));
      await _prefs.setString('ws_prompts_v1', jsonEncode(_prompts.map((p) => p.toJson()).toList()));
      await _prefs.setString('ws_experiments_v1', jsonEncode(_experiments.map((e) => e.toJson()).toList()));
      await _prefs.setString('ws_documents_v1', jsonEncode(_documents.map((d) => d.toJson()).toList()));
      await _prefs.setString('ws_favorites_v1', jsonEncode(_favoriteItemIds.toList()));

      return true;
    } catch (_) {
      return false; // Error de parseo
    }
  }

  Future<void> clearAll() async {
    _notes.clear();
    _prompts.clear();
    _experiments.clear();
    _documents.clear();
    _favoriteItemIds.clear();
    await _prefs.remove('ws_notes_v1');
    await _prefs.remove('ws_prompts_v1');
    await _prefs.remove('ws_experiments_v1');
    await _prefs.remove('ws_documents_v1');
    await _prefs.remove('ws_favorites_v1');
  }
}
