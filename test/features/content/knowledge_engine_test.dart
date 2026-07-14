import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KnowledgeEngine Tests', () {
    final engine = KnowledgeEngine.instance;

    setUpAll(() async {
      await engine.initialize();
    });

    test('Engine is initialized and manifest is parsed correctly', () {
      expect(engine.isInitialized, isTrue);
      expect(engine.articles, isNotEmpty);
      expect(engine.terms, isNotEmpty);
    });

    test('Lazy loading fetches full lesson blocks and caches it', () async {
      final lessonId = 'lesson-models-001';

      // Cargar lección completa
      final lesson = await engine.getLesson(lessonId);
      expect(lesson.id, lessonId);
      expect(lesson.blocks, isNotEmpty);

      // Comprobar que la segunda llamada utiliza el caché (es instantánea)
      final cachedLesson = await engine.getLesson(lessonId);
      expect(identical(lesson, cachedLesson), isTrue);
    });

    test('Semantic validation: dictionary links resolve successfully', () {
      final terms = engine.terms;
      for (final term in terms) {
        for (final relatedId in term.related) {
          final relatedTerm = engine.getTerm(relatedId);
          expect(relatedTerm.id, relatedId);
        }
      }
    });

    test('Fast search indexes articles correctly', () {
      final results = engine.searchArticles('evaluar');
      expect(results.any((a) => a.id == 'evaluacion'), isTrue);

      final emptyResults = engine.searchArticles('termino-inexistente-12345');
      expect(emptyResults, isEmpty);
    });

    test('Verifies career paths, projects and prompt exercises load correctly', () {
      expect(engine.careerPaths, hasLength(8));
      expect(engine.projects, hasLength(15));
      expect(engine.promptExercises, hasLength(20));

      final firstPath = engine.careerPaths.first;
      expect(firstPath.id, 'advanced'); // prioridad 1
    });

    test('Verifies thought library and model catalog load correctly', () {
      expect(engine.thoughtLibrary.ideas, isNotEmpty);
      expect(engine.thoughtLibrary.topics, isNotEmpty);
      expect(engine.thoughtLibrary.authors, isNotEmpty);

      expect(engine.modelCatalog, isNotEmpty);
      final model = engine.modelCatalog.firstWhere((m) => m.id == 'gemini');
      expect(model.verified, isTrue);
    });

    test('Verifies modules, competencies and skills taxonomies load correctly', () {
      expect(engine.tracks, hasLength(2));
      expect(engine.competencies, hasLength(4));
      expect(engine.skills, hasLength(6));

      final firstTrack = engine.tracks.first;
      expect(firstTrack.id, 'track-foundations');
      expect(firstTrack.competencyIds, contains('comp-criterio'));
    });
  });
}
