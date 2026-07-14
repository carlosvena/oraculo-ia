import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/ai_lab/data/ai_lab_repository.dart';
import 'package:oraculo_ia/src/features/ai_lab/domain/ai_lab_models.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ORÁCULO AI LAB v1.0 Tests', () {
    final ke = KnowledgeEngine.instance;
    final repo = AiLabRepository.instance;

    setUpAll(() async {
      await ke.initialize();
    });

    test('Loads 50 laboratories from assets offline', () {
      expect(ke.aiLaboratories, hasLength(50));

      final firstLab = ke.aiLaboratories.first;
      expect(firstLab.id, 'lab-001');
      expect(firstLab.title, contains('Formular una instrucción'));
      expect(firstLab.category, 'Prompt Engineering');
      expect(firstLab.difficulty, 'Inicial');
      expect(firstLab.steps, isNotEmpty);
      expect(firstLab.expectedResult, isNotEmpty);
      expect(firstLab.commonErrors, isNotEmpty);

      final lastLab = ke.aiLaboratories.last;
      expect(lastLab.id, 'lab-050');
      expect(lastLab.category, 'Productividad');
      expect(lastLab.difficulty, 'Intermedio');
    });

    test('Includes all 13 required categories in loaded laboratories', () {
      final categories = ke.aiLaboratories.map((l) => l.category).toSet();
      
      expect(categories, contains('Prompt Engineering'));
      expect(categories, contains('ChatGPT'));
      expect(categories, contains('Gemini'));
      expect(categories, contains('Claude'));
      expect(categories, contains('DeepSeek'));
      expect(categories, contains('LLM'));
      expect(categories, contains('Agentes'));
      expect(categories, contains('Automatización'));
      expect(categories, contains('Excel'));
      expect(categories, contains('Programación'));
      expect(categories, contains('Documentos'));
      expect(categories, contains('Investigación'));
      expect(categories, contains('Productividad'));
    });

    test('Offline rule-based prompt evaluator scorecard validation', () {
      // Prompt incompleto
      final poorEval = repo.evaluatePrompt("hola gpt");
      expect(poorEval.score, lessThan(50));
      expect(poorEval.suggestions, isNotEmpty);

      // Prompt estructurado y óptimo
      final richEval = repo.evaluatePrompt(
        "Actúa como un analista senior. Resumí el informe en una tabla markdown de 3 columnas de forma concisa. Evitá explicaciones largas."
      );
      expect(richEval.score, greaterThan(70));
      expect(richEval.clarityScore, isPositive);
      expect(richEval.contextScore, isPositive);
      expect(richEval.restrictionsScore, isPositive);
      expect(richEval.formatScore, isPositive);
      expect(richEval.objectiveScore, isPositive);
    });

    test('Exposes 10 reusable prompt templates', () {
      expect(repo.templates, hasLength(10));
      expect(repo.templates.first.id, 'tpl-resumir');
      expect(repo.templates.last.id, 'tpl-brainstorming');
    });

    test('Manages practice sessions history persistence', () {
      final initialHistoryCount = repo.history.length;

      final session = LabPracticeSession(
        id: 'test-session',
        labId: 'lab-001',
        labTitle: 'Lab 01',
        dateStr: '2026-07-13',
        durationMinutes: 15,
        originalPrompt: 'hola',
        improvedPrompt: 'hola mejorado',
        observations: 'obs',
        learnings: 'learning',
        score: 50,
      );

      repo.saveSession(session);

      expect(repo.history, hasLength(initialHistoryCount + 1));
      expect(repo.history.last.id, 'test-session');
    });
  });
}
