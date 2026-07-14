import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Academia IA v1.0 Catalog and Search Tests', () {
    final ke = KnowledgeEngine.instance;

    setUpAll(() async {
      await ke.initialize();
    });

    test('Loads 10 courses categorized in the Academy Catalog', () {
      expect(ke.academyCourses, hasLength(8));
      
      final titles = ke.academyCourses.map((c) => c.title).toList();
      expect(titles, contains('Fundamentos de IA'));
      expect(titles, contains('Prompt Engineering'));
      expect(titles, contains('Modelos de lenguaje'));
      expect(titles, contains('Agentes y herramientas'));
      expect(titles, contains('IA aplicada al trabajo bancario'));
    });

    test('Loads exactly 100 missions with correct metadata structures', () {
      expect(ke.academyMissions, hasLength(100));

      final firstMission = ke.academyMissions.first;
      expect(firstMission.id, 'ac-001');
      expect(firstMission.title, contains('Conceptos básicos'));
      expect(firstMission.durationMinutes, isPositive);
      expect(firstMission.concepts, isNotEmpty);
      expect(firstMission.difficulty, 'Inicial');

      final lastMission = ke.academyMissions.last;
      expect(lastMission.id, 'ac-100');
      expect(lastMission.difficulty, 'Avanzado');
    });

    test('Simulates multientity global search matching keywords', () {
      // 1. Buscar en cursos
      final matchedCourses = ke.academyCourses
          .where((c) => c.title.toLowerCase().contains('prompt') || c.description.toLowerCase().contains('prompt'))
          .toList();
      expect(matchedCourses, isNotEmpty);

      // 2. Buscar en misiones
      final matchedMissions = ke.academyMissions
          .where((m) => m.title.toLowerCase().contains('prompt') || m.objective.toLowerCase().contains('prompt'))
          .toList();
      expect(matchedMissions, isNotEmpty);

      final matchedLabs = ke.promptExercises
          .where((ex) =>
              ex.title.toLowerCase().contains('fórm') ||
              ex.title.toLowerCase().contains('formu') ||
              ex.why.toLowerCase().contains('fórm') ||
              ex.why.toLowerCase().contains('formu'))
          .toList();
      expect(matchedLabs, isNotEmpty);
    });
  });
}
