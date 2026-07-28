enum LessonBlockType { title, text, analogy, example, challenge, quiz, summary }

final class LessonQuestion {
  const LessonQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
}

final class LessonBlock {
  const LessonBlock({
    required this.type,
    required this.title,
    required this.content,
    required this.sequence,
    this.items = const <String>[],
    this.prompt,
    this.questions = const <LessonQuestion>[],
  });

  final LessonBlockType type;
  final String title;
  final String content;
  final int sequence;
  final List<String> items;
  final String? prompt;
  final List<LessonQuestion> questions;

  /// Usado para personalizar contenido genérico (ej. reemplazar
  /// `{{trabajo}}` por el trabajo real guardado por la persona) sin
  /// tener que duplicar contenido editorial por profesión.
  LessonBlock copyWith({String? title, String? content, String? prompt}) =>
      LessonBlock(
        type: type,
        title: title ?? this.title,
        content: content ?? this.content,
        sequence: sequence,
        items: items,
        prompt: prompt ?? this.prompt,
        questions: questions,
      );
}

/// Reemplaza el placeholder `{{trabajo}}` por el trabajo real de la
/// persona, o por un genérico si todavía no cargó nada en su perfil.
/// Separado como función pura para poder testearlo sin levantar widgets.
String applyWorkPlaceholder(String text, String work) {
  final phrase = work.trim().isEmpty ? 'tu trabajo' : work.trim();
  return text.replaceAll('{{trabajo}}', phrase);
}

final class Lesson {
  Lesson({
    required this.id,
    required this.contentVersion,
    required this.title,
    required this.objective,
    this.estimatedMinutes = 15,
    this.concepts = const <String>[],
    required List<LessonBlock> blocks,
  }) : blocks = List<LessonBlock>.unmodifiable(blocks);

  final String id;
  final int contentVersion;
  final String title;
  final String objective;
  final int estimatedMinutes;
  final List<String> concepts;
  final List<LessonBlock> blocks;
}
