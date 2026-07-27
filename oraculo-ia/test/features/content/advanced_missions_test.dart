import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

void main() {
  test('missions 006 to 015 satisfy professional content contract', () {
    final source = File('knowledge/advanced_missions_v1.json').readAsStringSync();
    final lessons = const KnowledgeReader().parseAdvanced(source);
    expect(lessons, hasLength(10));
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
    final project = lessons.last;
    final body = project.blocks.map((block) => '${block.title} ${block.content}').join(' ').toLowerCase();
    for (final concept in ['prompt', 'modelo', 'verificación', 'automatización', 'reflexión']) {
      expect(body, contains(concept));
    }
  });
}
