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
      expect(ke.academyCourses, hasLength(10));
      
      final titles = ke.academyCourses.map((c) => c.title).toList();
      expect(titles, contains('Fundamentos de IA'));
      expect(titles, contains('Prompt Engineering Avanzado'));
      expect(titles, contains('Sistemas de Agentes de IA'));
      expect(titles, contains('Automatización con Workflows'));
      expect(titles, contains('IA en el Sector Bancario'));
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

      // 3. Buscar en laboratorios
      final matchedLabs = ke.promptExercises
          .where((ex) => ex.title.toLowerCase().contains('fórmula') || ex.why.toLowerCase().contains('fórmula'))
          .toList();
      expect(matchedLabs, isNotEmpty);
    });
  });
}
