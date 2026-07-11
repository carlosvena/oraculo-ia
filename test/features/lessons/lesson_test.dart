import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

void main() {
  test('lesson supports every educational block in Sprint 3', () {
    final blocks = <LessonBlock>[
      for (final (index, type) in LessonBlockType.values.indexed)
        LessonBlock(
          type: type,
          title: 'Título',
          content: 'Contenido temporal',
          sequence: index + 1,
        ),
    ];

    expect(blocks.map((block) => block.type), LessonBlockType.values);
    expect(blocks, hasLength(7));
  });
}
