import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KnowledgeEngine Tests', () {
    final engine = KnowledgeEngine.instance;

    setUpAll(() async {
      // Inicializar el motor (usará el AssetBundle simulado en el contexto de pruebas)
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
  });
}
