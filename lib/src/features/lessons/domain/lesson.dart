enum LessonBlockType {
  title,
  text,
  analogy,
  example,
  challenge,
  quiz,
  summary,
}

final class LessonBlock {
  const LessonBlock({
    required this.type,
    required this.title,
    required this.content,
    required this.sequence,
    this.items = const <String>[],
    this.prompt,
  });

  final LessonBlockType type;
  final String title;
  final String content;
  final int sequence;
  final List<String> items;
  final String? prompt;
}

final class Lesson {
  Lesson({
    required this.id,
    required this.contentVersion,
    required this.title,
    required this.objective,
    required List<LessonBlock> blocks,
  }) : blocks = List<LessonBlock>.unmodifiable(blocks);

  final String id;
  final int contentVersion;
  final String title;
  final String objective;
  final List<LessonBlock> blocks;
}
