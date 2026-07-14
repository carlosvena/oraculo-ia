/// Tipos de eventos en la línea temporal de aprendizaje (Módulo 6).
enum TimelineEventType {
  conceptLearned,
  conceptReviewed,
  labCompleted,
  projectFinished,
}

/// Representa un hito/evento en la línea temporal cronológica del alumno.
final class LearningTimelineEvent {
  const LearningTimelineEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  final String id;
  final TimelineEventType type;
  final String title;
  final String description;
  final DateTime timestamp;
}

/// Representa una insignia de maestría por méritos didácticos (Módulo 7).
final class MasteryBadge {
  const MasteryBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;

  MasteryBadge copyWith({DateTime? unlockedAt}) {
    return MasteryBadge(
      id: id,
      title: title,
      description: description,
      iconName: iconName,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

/// Representa un desafío diario generado de forma determinista offline (Módulo 5).
final class DailyChallenge {
  const DailyChallenge({
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.promptQuestion,
    required this.answerKey,
  });

  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String promptQuestion;
  final String answerKey;
}
