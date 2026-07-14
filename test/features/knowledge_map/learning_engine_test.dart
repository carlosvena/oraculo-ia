import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/learning_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LearningEngine v2 Tests', () {
    late LearningEngine engine;

    setUpAll(() async {
      await KnowledgeEngine.instance.initialize();
      engine = LearningEngine.instance;
      engine.initializeGraph();
    });

    test('Engine builds knowledge graph correctly from KnowledgeEngine', () {
      expect(engine.nodes, isNotEmpty);
      expect(engine.nodes.containsKey('concept-prompt'), isTrue);
      expect(engine.nodes.containsKey('mission-lesson-models-001'), isTrue);
      expect(engine.nodes.containsKey('project-prompt-library'), isTrue);
    });

    test('Validates unlocked states and missing prerequisites', () {
      // El nodo del término 'prompt' requiere el concepto 'concept-prompt'
      final nodeId = 'prompt';
      
      // Aseguramos que el prerrequisito no esté completo
      engine.setConceptMastery('prompt', ConceptMasteryLevel.unseen);

      final unlocked = engine.isUnlocked(nodeId);
      expect(unlocked, isFalse);

      final missing = engine.getMissingPrerequisites(nodeId);
      expect(missing, isNotEmpty);
      expect(missing.first, contains('Concepto'));
    });

    test('Tracks conceptual mastery progression', () {
      const concept = 'prompt';
      final cId = 'concept-prompt';
      
      expect(engine.conceptMastery[cId], ConceptMasteryLevel.unseen);

      engine.setConceptMastery(concept, ConceptMasteryLevel.read);
      expect(engine.conceptMastery[cId], ConceptMasteryLevel.read);

      engine.incrementConceptMastery(concept); // read -> understood
      expect(engine.conceptMastery[cId], ConceptMasteryLevel.understood);
    });

    test('Formulates cognitive transfer prompts based on mastery', () {
      const concept = 'prompt';
      final promptWithMastery = engine.getTransferPrompt(concept);
      expect(promptWithMastery, contains('ya comprendiste'));

      const unseenConcept = 'inexistente';
      final promptUnseen = engine.getTransferPrompt(unseenConcept);
      expect(promptUnseen, contains('Analicemos desde cero'));
    });

    test('Triggers smart detention and adjusts dynamic routes', () {
      expect(engine.isDetained, isFalse);

      // Simular 3 fallos consecutivos
      engine.recordQuizFailure();
      engine.recordQuizFailure();
      engine.recordQuizFailure();

      expect(engine.isDetained, isTrue);

      // La ruta dinámica recomendada debe contener únicamente repasos (capítulos/glosario)
      final route = engine.generateDynamicRoute(timeAvailableMinutes: 30, goal: 'Aprender');
      expect(route.every((n) => n.type == KnowledgeNodeType.chapter || n.type == KnowledgeNodeType.term), isTrue);

      // Resetear
      engine.recordQuizSuccess();
      expect(engine.isDetained, isFalse);
    });

    test('Verifies track project blocks', () {
      final blockActive = engine.isProjectBlockActive('track-automation');
      expect(blockActive, isTrue); // Proyectos iniciales aún no completados

      // Simular completado
      engine.completeProject('prompt-library');
      final blockResolved = engine.isProjectBlockActive('track-automation');
      expect(blockResolved, isFalse);
    });

    test('Generates dynamic routes based on available time constraints', () {
      final route = engine.generateDynamicRoute(timeAvailableMinutes: 20, goal: 'Aprender');
      final totalMin = route.map((n) => n.estimatedMinutes).fold<double>(0.0, (a, b) => a + b);
      expect(totalMin <= 20.0, isTrue);
    });
  });
}
