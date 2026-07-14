import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oraculo_ia/src/features/professional/domain/professional_models.dart';

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository.instance;
});

final professionalStateProvider = NotifierProvider<ProfessionalStateNotifier, ProfessionalState>(
  ProfessionalStateNotifier.new,
);

class ProfessionalState {
  final Set<String> copiedPromptIds;
  final Set<String> completedCaseIds;
  final Set<String> completedChallengeIds;
  final Map<String, int> simulatorScores;

  const ProfessionalState({
    this.copiedPromptIds = const {},
    this.completedCaseIds = const {},
    this.completedChallengeIds = const {},
    this.simulatorScores = const {},
  });

  ProfessionalState copyWith({
    Set<String>? copiedPromptIds,
    Set<String>? completedCaseIds,
    Set<String>? completedChallengeIds,
    Map<String, int>? simulatorScores,
  }) {
    return ProfessionalState(
      copiedPromptIds: copiedPromptIds ?? this.copiedPromptIds,
      completedCaseIds: completedCaseIds ?? this.completedCaseIds,
      completedChallengeIds: completedChallengeIds ?? this.completedChallengeIds,
      simulatorScores: simulatorScores ?? this.simulatorScores,
    );
  }
}

class ProfessionalStateNotifier extends Notifier<ProfessionalState> {
  ProfessionalRepository get _repo => ref.read(professionalRepositoryProvider);

  @override
  ProfessionalState build() {
    return ProfessionalState(
      copiedPromptIds: _repo.copiedPromptIds,
      completedCaseIds: _repo.completedCaseIds,
      completedChallengeIds: _repo.completedChallengeIds,
      simulatorScores: _repo.simulatorScores,
    );
  }

  Future<void> copyPrompt(String id) async {
    await _repo.recordPromptCopy(id);
    state = state.copyWith(copiedPromptIds: {...state.copiedPromptIds, id});
  }

  Future<void> completeCase(String id) async {
    await _repo.recordCaseCompletion(id);
    state = state.copyWith(completedCaseIds: {...state.completedCaseIds, id});
  }

  Future<void> completeChallenge(String id) async {
    await _repo.recordChallengeCompletion(id);
    state = state.copyWith(completedChallengeIds: {...state.completedChallengeIds, id});
  }

  Future<void> recordSimulatorScore(String id, int score) async {
    await _repo.recordSimulatorScore(id, score);
    final nextScores = Map<String, int>.from(state.simulatorScores);
    nextScores[id] = score;
    state = state.copyWith(simulatorScores: nextScores);
  }
}

class ProfessionalRepository {
  ProfessionalRepository._();
  static final instance = ProfessionalRepository._();

  bool _initialized = false;
  late final SharedPreferences _prefs;

  final _cases = <ProfessionalCase>[];
  final _prompts = <ProfessionalPrompt>[];
  final _templates = <ProfessionalTemplate>[];
  final _simulators = <ProfessionalSimulator>[];
  final _challenges = <ProfessionalChallenge>[];
  final _guides = <ResourceGuide>[];
  final _checklists = <ResourceChecklist>[];
  final _procedures = <ResourceProcedure>[];

  final Set<String> _copiedPromptIds = {};
  final Set<String> _completedCaseIds = {};
  final Set<String> _completedChallengeIds = {};
  final Map<String, int> _simulatorScores = {};

  bool get isInitialized => _initialized;
  List<ProfessionalCase> get cases => List.unmodifiable(_cases);
  List<ProfessionalPrompt> get prompts => List.unmodifiable(_prompts);
  List<ProfessionalTemplate> get templates => List.unmodifiable(_templates);
  List<ProfessionalSimulator> get simulators => List.unmodifiable(_simulators);
  List<ProfessionalChallenge> get challenges => List.unmodifiable(_challenges);
  List<ResourceGuide> get guides => List.unmodifiable(_guides);
  List<ResourceChecklist> get checklists => List.unmodifiable(_checklists);
  List<ResourceProcedure> get procedures => List.unmodifiable(_procedures);

  Set<String> get copiedPromptIds => Set.unmodifiable(_copiedPromptIds);
  Set<String> get completedCaseIds => Set.unmodifiable(_completedCaseIds);
  Set<String> get completedChallengeIds => Set.unmodifiable(_completedChallengeIds);
  Map<String, int> get simulatorScores => Map.unmodifiable(_simulatorScores);

  Future<void> initialize() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    // 1. Cargar bases de datos JSON
    await _loadCases();
    await _loadPrompts();
    await _loadTemplates();
    await _loadSimulators();
    await _loadChallenges();
    await _loadResources();

    // 2. Cargar progreso de SharedPreferences
    _loadUserProgress();

    _initialized = true;
  }

  Future<void> _loadCases() async {
    final str = await rootBundle.loadString('knowledge/professional_cases_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final list = data['cases'] as List;
    _cases.clear();
    _cases.addAll(list.map((x) => ProfessionalCase.fromJson(x as Map<String, dynamic>)));
  }

  Future<void> _loadPrompts() async {
    final str = await rootBundle.loadString('knowledge/professional_prompts_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final list = data['prompts'] as List;
    _prompts.clear();
    _prompts.addAll(list.map((x) => ProfessionalPrompt.fromJson(x as Map<String, dynamic>)));
  }

  Future<void> _loadTemplates() async {
    final str = await rootBundle.loadString('knowledge/professional_templates_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final list = data['templates'] as List;
    _templates.clear();
    _templates.addAll(list.map((x) => ProfessionalTemplate.fromJson(x as Map<String, dynamic>)));
  }

  Future<void> _loadSimulators() async {
    final str = await rootBundle.loadString('knowledge/professional_simulators_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final list = data['simulators'] as List;
    _simulators.clear();
    _simulators.addAll(list.map((x) => ProfessionalSimulator.fromJson(x as Map<String, dynamic>)));
  }

  Future<void> _loadChallenges() async {
    final str = await rootBundle.loadString('knowledge/professional_challenges_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final list = data['challenges'] as List;
    _challenges.clear();
    _challenges.addAll(list.map((x) => ProfessionalChallenge.fromJson(x as Map<String, dynamic>)));
  }

  Future<void> _loadResources() async {
    final str = await rootBundle.loadString('knowledge/professional_resources_v1.json');
    final data = json.decode(str) as Map<String, dynamic>;
    
    final guidesList = data['guides'] as List;
    _guides.clear();
    _guides.addAll(guidesList.map((x) => ResourceGuide.fromJson(x as Map<String, dynamic>)));

    final checklistsList = data['checklists'] as List;
    _checklists.clear();
    _checklists.addAll(checklistsList.map((x) => ResourceChecklist.fromJson(x as Map<String, dynamic>)));

    final procsList = data['procedures'] as List;
    _procedures.clear();
    _procedures.addAll(procsList.map((x) => ResourceProcedure.fromJson(x as Map<String, dynamic>)));
  }

  void _loadUserProgress() {
    _copiedPromptIds.addAll(_prefs.getStringList('prof_copied_prompts') ?? []);
    _completedCaseIds.addAll(_prefs.getStringList('prof_completed_cases') ?? []);
    _completedChallengeIds.addAll(_prefs.getStringList('prof_completed_challenges') ?? []);
    
    final simScoresStr = _prefs.getString('prof_sim_scores') ?? '{}';
    try {
      final decoded = json.decode(simScoresStr) as Map<String, dynamic>;
      decoded.forEach((key, val) {
        if (val is int) {
          _simulatorScores[key] = val;
        }
      });
    } catch (_) {}
  }

  Future<void> recordPromptCopy(String id) async {
    _copiedPromptIds.add(id);
    await _prefs.setStringList('prof_copied_prompts', _copiedPromptIds.toList());
  }

  Future<void> recordCaseCompletion(String id) async {
    _completedCaseIds.add(id);
    await _prefs.setStringList('prof_completed_cases', _completedCaseIds.toList());
  }

  Future<void> recordChallengeCompletion(String id) async {
    _completedChallengeIds.add(id);
    await _prefs.setStringList('prof_completed_challenges', _completedChallengeIds.toList());
  }

  Future<void> recordSimulatorScore(String id, int score) async {
    _simulatorScores[id] = score;
    await _prefs.setString('prof_sim_scores', json.encode(_simulatorScores));
  }

  Future<void> clearAllProgress() async {
    _copiedPromptIds.clear();
    _completedCaseIds.clear();
    _completedChallengeIds.clear();
    _simulatorScores.clear();
    await _prefs.remove('prof_copied_prompts');
    await _prefs.remove('prof_completed_cases');
    await _prefs.remove('prof_completed_challenges');
    await _prefs.remove('prof_sim_scores');
  }
}
