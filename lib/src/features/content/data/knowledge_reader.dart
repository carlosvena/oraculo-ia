import 'dart:convert';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

final class KnowledgeReader {
  const KnowledgeReader();
  Future<KnowledgeContent> load() async {
    final engine = KnowledgeEngine.instance;
    await engine.initialize();
    final lessons = await engine.getAllLessons();
    return KnowledgeContent(
      lessons: lessons,
      articles: engine.articles,
      terms: engine.terms,
    );
  }

  List<Lesson> parseAdvanced(String source) {
    try {
      final root = jsonDecode(source);
      if (root is! Map<String, dynamic> || root['schemaVersion'] != 1) {
        throw const EditorialContentException(
          'Versión de misiones avanzadas incompatible.',
        );
      }
      return _list(root, 'missions').map((mission) {
        final sections = mission['sections'];
        final quiz = mission['quiz'];
        if (sections is! List || sections.length < 10) {
          throw EditorialContentException(
            '${_text(mission, 'id')} debe tener al menos 10 bloques.',
          );
        }
        if (quiz is! List || quiz.length < 8) {
          throw EditorialContentException(
            '${_text(mission, 'id')} debe tener al menos 8 preguntas.',
          );
        }
        final blocks = <LessonBlock>[];
        for (final (index, raw) in sections.indexed) {
          final values = (raw as List).cast<String>();
          if (values.length != 3) {
            throw const EditorialContentException(
              'Cada sección avanzada requiere tipo, título y contenido.',
            );
          }
          final type = LessonBlockType.values.firstWhere(
            (item) => item.name == values[0],
            orElse: () => throw EditorialContentException(
              'Tipo avanzado desconocido: ${values[0]}.',
            ),
          );
          blocks.add(
            LessonBlock(
              type: type,
              title: values[1],
              content: values[2],
              sequence: index + 1,
              questions: type == LessonBlockType.challenge
                  ? const <LessonQuestion>[
                      LessonQuestion(
                        question: '¿Completaste esta actividad por escrito?',
                        options: <String>['Todavía no', 'Sí, la completé'],
                        correctAnswer: 1,
                        explanation:
                            'El aprendizaje activo exige producir una respuesta propia.',
                      ),
                    ]
                  : const <LessonQuestion>[],
            ),
          );
        }
        blocks.add(
          LessonBlock(
            type: LessonBlockType.quiz,
            title: 'Autoevaluación',
            content:
                'Respondé las ocho preguntas. Cada error incluye una explicación para volver a pensar.',
            sequence: blocks.length + 1,
            questions: quiz.map((raw) {
              final values = raw as List;
              final options = (values[1] as List).cast<String>();
              final correct = values[2] as int;
              return LessonQuestion(
                question: values[0] as String,
                options: options,
                correctAnswer: correct,
                explanation:
                    'La opción correcta es "${options[correct]}" porque aplica la definición y los controles desarrollados en esta misión.',
              );
            }).toList(),
          ),
        );
        return Lesson(
          id: _text(mission, 'id'),
          contentVersion: 1,
          title: 'MISIÓN ${_text(mission, 'number')} — ${_text(mission, 'title')}',
          objective: _text(mission, 'objective'),
          estimatedMinutes: mission['duration'] as int,
          concepts: _strings(mission, 'concepts'),
          blocks: blocks,
        );
      }).toList();
    } on EditorialContentException {
      rethrow;
    } on Object catch (error) {
      throw EditorialContentException('Misiones avanzadas inválidas: $error');
    }
  }

  KnowledgeContent parse(String source) {
    try {
      final root = jsonDecode(source);
      if (root is! Map<String, dynamic> || root['schemaVersion'] != 1) {
        throw const EditorialContentException(
          'schemaVersion ausente o incompatible.',
        );
      }
      final missions = _list(root, 'missions');
      final articles = _list(root, 'articles');
      final dictionary = _list(root, 'dictionary');
      final lessons = missions.map(_lesson).toList();
      final parsedArticles =
          articles
              .map(
                (item) => KnowledgeArticle(
                  id: _text(item, 'id'),
                  title: _text(item, 'title'),
                  body: _text(item, 'body'),
                  links: _strings(item, 'links'),
                ),
              )
              .toList();
      final terms =
          dictionary
              .map(
                (item) => DictionaryTerm(
                  id: _text(item, 'id'),
                  term: _text(item, 'term'),
                  definition: _text(item, 'definition'),
                  explanation: _text(item, 'explanation'),
                  analogy: _text(item, 'analogy'),
                  example: _text(item, 'example'),
                  mistake: _text(item, 'mistake'),
                  related: _strings(item, 'related'),
                ),
              )
              .toList();
      final ids = terms.map((e) => e.id).toSet();
      for (final term in terms) {
        for (final link in term.related) {
          if (!ids.contains(link)) {
            throw EditorialContentException(
              'El término ${term.id} enlaza a "$link", que no existe.',
            );
          }
        }
      }
      return KnowledgeContent(
        lessons: lessons,
        articles: parsedArticles,
        terms: terms,
      );
    } on EditorialContentException {
      rethrow;
    } on Object catch (error) {
      throw EditorialContentException('JSON inválido: $error');
    }
  }

  Lesson _lesson(Map<String, dynamic> item) {
    final blocks =
        _list(item, 'blocks').indexed.map((entry) {
          final (index, block) = entry;
          final typeName = _text(block, 'type');
          final type =
              LessonBlockType.values
                  .where((value) => value.name == typeName)
                  .firstOrNull;
          if (type == null) {
            throw EditorialContentException(
              'Tipo de bloque desconocido: $typeName.',
            );
          }
          final questions =
              (block['questions'] as List<dynamic>? ?? const []).map((raw) {
                final q = raw as Map<String, dynamic>;
                final options = _strings(q, 'options');
                final correct = q['correct'];
                if (correct is! int ||
                    correct < 0 ||
                    correct >= options.length) {
                  throw EditorialContentException(
                    'Respuesta correcta inválida en ${_text(q, 'question')}.',
                  );
                }
                return LessonQuestion(
                  question: _text(q, 'question'),
                  options: options,
                  correctAnswer: correct,
                  explanation: _text(q, 'explanation'),
                );
              }).toList();
          return LessonBlock(
            type: type,
            title: _text(block, 'title'),
            content: _text(block, 'content'),
            sequence: index + 1,
            items: _strings(block, 'items', optional: true),
            prompt: block['prompt'] as String?,
            questions: questions,
          );
        }).toList();
    if (blocks.isEmpty) {
      throw const EditorialContentException('Una misión no puede estar vacía.');
    }
    return Lesson(
      id: _text(item, 'id'),
      contentVersion: item['version'] as int,
      title: _text(item, 'title'),
      objective: _text(item, 'objective'),
      estimatedMinutes: item['duration'] as int? ?? 15,
      concepts: _strings(item, 'concepts', optional: true),
      blocks: blocks,
    );
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is! List || value.isEmpty) {
      throw EditorialContentException(
        'La colección "$key" falta o está vacía.',
      );
    }
    return value.cast<Map<String, dynamic>>();
  }

  String _text(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is! String || value.trim().isEmpty) {
      throw EditorialContentException('Campo "$key" requerido.');
    }
    return value;
  }

  List<String> _strings(
    Map<String, dynamic> map,
    String key, {
    bool optional = false,
  }) {
    final value = map[key];
    if (value == null && optional) return const [];
    if (value is! List) {
      throw EditorialContentException('Campo "$key" debe ser una lista.');
    }
    return value.cast<String>();
  }
}
