import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Epic 9 Content Validation Tests', () {
    final ke = KnowledgeEngine.instance;

    setUpAll(() async {
      await ke.initialize();
    });

    test('Loads 30 complete detailed JSON lessons', () async {
      expect(ke.academyMissions, hasLength(greaterThanOrEqualTo(30)));
      
      // Validar las primeras 30 misiones individualmente en caché y archivos
      final ids = ke.lessonsMetadata.map((l) => l.id).toList();
      expect(ids.length, greaterThanOrEqualTo(30));
      for (final lessonId in ids.take(30)) {
        final lesson = await ke.getLesson(lessonId);
        expect(lesson.id, lessonId);
        expect(lesson.title, isNotEmpty);
        expect(lesson.estimatedMinutes, isPositive);
        // Validar mínimos de 10 bloques y 8 preguntas exigidos
        expect(lesson.blocks.length, greaterThanOrEqualTo(10));
        
        final quizBlock = lesson.blocks.firstWhere((b) => b.title == 'Autoevaluación');
        expect(quizBlock.questions.length, greaterThanOrEqualTo(8));
      }
    });

    test('Organizes missions into exactly 8 official courses', () {
      expect(ke.academyCourses, hasLength(8));
      
      final firstCourse = ke.academyCourses.first;
      expect(firstCourse.id, 'course-fundamentos');
      expect(firstCourse.title, 'Fundamentos de IA');
      expect(firstCourse.missionIds, contains('ac-001'));

      final lastCourse = ke.academyCourses.last;
      expect(lastCourse.id, 'course-banca');
      expect(lastCourse.title, 'IA aplicada al trabajo bancario');
      expect(lastCourse.missionIds, contains('ac-030'));
    });

    test('Loads a dictionary of at least 150 terms with relations', () {
      expect(ke.terms, hasLength(greaterThanOrEqualTo(150)));
      
      // Comprobar enlaces de diccionario sin duplicaciones ni referencias rotas
      final termIds = ke.terms.map((t) => t.id).toSet();
      expect(termIds.length, ke.terms.length); // Cero duplicados en IDs

      for (final term in ke.terms) {
        expect(term.term, isNotEmpty);
        expect(term.definition, isNotEmpty);
        expect(term.explanation, isNotEmpty);
        expect(term.analogy, isNotEmpty);
        expect(term.example, isNotEmpty);
        expect(term.mistake, isNotEmpty);
        
        // Verificar integridad referencial de relacionados
        for (final rel in term.related) {
          expect(termIds.contains(rel), isTrue);
        }
      }
    });

    test('Loads manual master of at least 30 chapters with integrity', () {
      expect(ke.articles, hasLength(greaterThanOrEqualTo(30)));
      
      final articleIds = ke.articles.map((a) => a.id).toSet();
      expect(articleIds.length, ke.articles.length); // Cero duplicados

      for (final art in ke.articles) {
        expect(art.title, isNotEmpty);
        expect(art.body, isNotEmpty);
        
        // Verificar que ningún enlace interno apunte a un artículo inexistente
        for (final link in art.links) {
          expect(articleIds.contains(link), isTrue);
        }
      }
    });

    test('Loads 50 laboratories in required categories', () {
      expect(ke.aiLaboratories, hasLength(greaterThanOrEqualTo(50)));
      
      final labIds = ke.aiLaboratories.map((l) => l.id).toSet();
      expect(labIds.length, ke.aiLaboratories.length);

      for (final lab in ke.aiLaboratories) {
        expect(lab.title, isNotEmpty);
        expect(lab.category, isNotEmpty);
        expect(lab.objective, isNotEmpty);
        expect(lab.steps, isNotEmpty);
        expect(lab.expectedResult, isNotEmpty);
        expect(lab.commonErrors, isNotEmpty);
      }
    });

    test('Loads exactly 15 engineering projects', () {
      expect(ke.projects, hasLength(15));
      
      final projectIds = ke.projects.map((p) => p.id).toSet();
      expect(projectIds.length, ke.projects.length);

      for (final proj in ke.projects) {
        expect(proj.title, isNotEmpty);
        expect(proj.objective, isNotEmpty);
        expect(proj.knowledge, isNotEmpty);
        expect(proj.steps, isNotEmpty);
        expect(proj.deliverables, isNotEmpty);
        expect(proj.success, isNotEmpty);
        expect(proj.risks, isNotEmpty);
        expect(proj.evaluation, isNotEmpty);
      }
    });
  });
}
