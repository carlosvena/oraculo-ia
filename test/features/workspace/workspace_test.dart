import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await WorkspaceRepository.instance.initialize();
    await WorkspaceRepository.instance.clearAll();
  });

  group('WorkspaceRepository tests', () {
    test('Notes CRUD operations', () async {
      final repo = WorkspaceRepository.instance;
      expect(repo.notes.isEmpty, true);

      final note = WorkspaceNote(
        id: 'n1',
        title: 'Clase de Agentes',
        body: 'Explicación del flujo ReAct.',
        tags: ['agentes'],
        updatedAt: DateTime.now(),
      );

      await repo.saveNote(note);
      expect(repo.notes.length, 1);
      expect(repo.notes.first.title, 'Clase de Agentes');

      // Modificar
      final modified = note.copyWith(body: 'Modificado.');
      await repo.saveNote(modified);
      expect(repo.notes.length, 1);
      expect(repo.notes.first.body, 'Modificado.');

      // Borrar
      await repo.deleteNote('n1');
      expect(repo.notes.isEmpty, true);
    });

    test('Prompts vault versioning and duplicating', () async {
      final repo = WorkspaceRepository.instance;

      final prompt = WorkspacePrompt(
        id: 'p1',
        title: 'Analista Excel',
        promptText: 'Analiza la siguiente tabla...',
        tags: ['excel'],
        version: 1,
        relatedConcepts: [],
        updatedAt: DateTime.now(),
      );

      await repo.savePrompt(prompt);
      expect(repo.prompts.length, 1);
      expect(repo.prompts.first.version, 1);

      // Duplicar
      final copy = WorkspacePrompt(
        id: 'p2',
        title: '${prompt.title} (Copia)',
        promptText: prompt.promptText,
        tags: prompt.tags,
        version: 1,
        isFavorite: prompt.isFavorite,
        relatedConcepts: prompt.relatedConcepts,
        updatedAt: DateTime.now(),
      );
      await repo.savePrompt(copy);
      expect(repo.prompts.length, 2);
      expect(repo.prompts.any((p) => p.title == 'Analista Excel (Copia)'), true);
      expect(repo.prompts.firstWhere((p) => p.title == 'Analista Excel (Copia)').version, 1);

      // Modificar (versioning)
      final edited = prompt.copyWith(version: prompt.version + 1);
      await repo.savePrompt(edited);
      expect(repo.prompts.firstWhere((p) => p.id == 'p1').version, 2);
    });

    test('Experiments saving and favorites toggling', () async {
      final repo = WorkspaceRepository.instance;

      final exp = WorkspaceExperiment(
        id: 'e1',
        objective: 'Test Gemini',
        hypothesis: 'Mejor con zero-shot',
        promptText: 'Hola Gemini...',
        result: 'Exitoso',
        learning: 'Zero-shot es suficiente',
        nextSteps: 'Probar con few-shot',
        createdAt: DateTime.now(),
      );

      await repo.saveExperiment(exp);
      expect(repo.experiments.length, 1);

      // Favoritos
      expect(repo.favoriteItemIds.contains('leccion_001'), false);
      await repo.recordFavoriteAdd('leccion_001');
      expect(repo.favoriteItemIds.contains('leccion_001'), true);
      await repo.recordFavoriteRemove('leccion_001');
      expect(repo.favoriteItemIds.contains('leccion_001'), false);
    });

    test('Backups and integrity verification (hash sha256)', () async {
      final repo = WorkspaceRepository.instance;

      await repo.saveNote(WorkspaceNote(
        id: 'n1',
        title: 'Nota de Respaldo',
        body: 'Secreto.',
        tags: [],
        updatedAt: DateTime.now(),
      ));

      final backupStr = repo.generateBackupPayload();
      expect(backupStr.contains('checksum'), true);
      expect(backupStr.contains('payload'), true);

      // Limpiar datos
      await repo.clearAll();
      expect(repo.notes.isEmpty, true);

      // Importar backup válido
      final success = await repo.importBackup(backupStr);
      expect(success, true);
      expect(repo.notes.length, 1);
      expect(repo.notes.first.title, 'Nota de Respaldo');

      // Importar corrupto (cambiar una letra del payload)
      final corrupt = backupStr.replaceFirst('Secreto.', 'Secreto!');
      final fail = await repo.importBackup(corrupt);
      expect(fail, false);
    });
  });
}
