import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

void main() {
  test('advanced missions satisfy the professional content contract', () {
    final source = File('knowledge/advanced_missions_v1.json').readAsStringSync();
    final lessons = const KnowledgeReader().parseAdvanced(source);
    // No hardcodeamos un número exacto: la cantidad de misiones avanzadas
    // crece con el tiempo. Lo que sí exigimos es que nunca haya menos de
    // las 10 misiones profesionales originales (006 a 015).
    expect(lessons.length, greaterThanOrEqualTo(10));
    for (final lesson in lessons) {
      expect(lesson.estimatedMinutes, inInclusiveRange(45, 75));
      expect(lesson.blocks.length, greaterThanOrEqualTo(11));
      final quiz = lesson.blocks.last;
      expect(quiz.type, LessonBlockType.quiz);
      expect(quiz.questions, hasLength(8));
      expect(lesson.blocks.any((block) => block.type == LessonBlockType.challenge), isTrue);
      expect(lesson.concepts, isNotEmpty);
    }
  });

  test('Mission 015 integrates the required professional decisions', () {
    final lessons = const KnowledgeReader().parseAdvanced(
      File('knowledge/advanced_missions_v1.json').readAsStringSync(),
    );
    // Buscamos la misión 015 por id, no por posición: si se agregan
    // misiones nuevas después, "la última" ya no es necesariamente esta.
    final project = lessons.firstWhere((lesson) => lesson.id == 'lesson-project-015');
    final body = project.blocks.map((block) => '${block.title} ${block.content}').join(' ').toLowerCase();
    for (final concept in ['prompt', 'modelo', 'verificación', 'automatización', 'reflexión']) {
      expect(body, contains(concept));
    }
  });
}
