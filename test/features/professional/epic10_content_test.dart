import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Epic 10 — Professional Edition Tests', () {
    late ProfessionalRepository repo;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await KnowledgeEngine.instance.initialize();
      
      repo = ProfessionalRepository.instance;
      await repo.initialize();
    });

    test('All professional databases load correctly offline', () {
      expect(repo.isInitialized, isTrue);
      
      // 1. Casos Reales
      expect(repo.cases, hasLength(16));
      final firstCase = repo.cases.first;
      expect(firstCase.id, 'case-001');
      expect(firstCase.category, 'bancos');
      expect(firstCase.title, isNotEmpty);
      expect(firstCase.promptExample, isNotEmpty);

      // 2. Biblioteca de Prompts (mínimo 300 prompts)
      expect(repo.prompts.length, greaterThanOrEqualTo(300));
      final firstPrompt = repo.prompts.first;
      expect(firstPrompt.id, 'prompt-prof-001');
      expect(firstPrompt.category, isNotEmpty);
      expect(firstPrompt.objective, isNotEmpty);
      expect(firstPrompt.example, isNotEmpty);

      // 3. Plantillas Reutilizables
      expect(repo.templates, hasLength(7));
      final firstTpl = repo.templates.first;
      expect(firstTpl.id, 'tpl-informe');
      expect(firstTpl.template, contains('# Informe Ejecutivo'));

      // 4. Simulador
      expect(repo.simulators, hasLength(5));
      final firstSim = repo.simulators.first;
      expect(firstSim.id, 'sim-001');
      expect(firstSim.correctModel, 'Claude');
      expect(firstSim.verificationItems, isNotEmpty);

      // 5. Desafíos (mínimo 200 desafíos)
      expect(repo.challenges.length, greaterThanOrEqualTo(200));
      final firstCh = repo.challenges.first;
      expect(firstCh.id, 'challenge-prof-001');
      expect(firstCh.difficulty, 'Inicial');

      // 6. Centro de Recursos
      expect(repo.guides, isNotEmpty);
      expect(repo.checklists, isNotEmpty);
      expect(repo.procedures, isNotEmpty);
    });

    test('State management and stats record correctly', () async {
      await repo.clearAllProgress();
      
      expect(repo.copiedPromptIds, isEmpty);
      expect(repo.completedCaseIds, isEmpty);
      expect(repo.completedChallengeIds, isEmpty);
      expect(repo.simulatorScores, isEmpty);

      // Registrar copias y resoluciones
      await repo.recordPromptCopy('prompt-prof-001');
      await repo.recordCaseCompletion('case-001');
      await repo.recordChallengeCompletion('challenge-prof-001');
      await repo.recordSimulatorScore('sim-001', 90);

      expect(repo.copiedPromptIds, contains('prompt-prof-001'));
      expect(repo.completedCaseIds, contains('case-001'));
      expect(repo.completedChallengeIds, contains('challenge-prof-001'));
      expect(repo.simulatorScores['sim-001'], 90);
    });
  });
}
