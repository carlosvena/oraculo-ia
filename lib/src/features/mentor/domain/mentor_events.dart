/// Clase base para todos los eventos didácticos a los que reacciona el mentor.
abstract class MentorEvent {
  const MentorEvent({required this.timestamp});
  final DateTime timestamp;
}

final class MissionCompleted extends MentorEvent {
  MissionCompleted({required this.missionId}) : super(timestamp: DateTime.now());
  final String missionId;
}

final class ConceptLearned extends MentorEvent {
  ConceptLearned({required this.concept}) : super(timestamp: DateTime.now());
  final String concept;
}

final class ConceptFailed extends MentorEvent {
  ConceptFailed({required this.concept, this.errorType = 'general'})
      : super(timestamp: DateTime.now());
  final String concept;
  final String errorType;
}

final class ProjectStarted extends MentorEvent {
  ProjectStarted({required this.projectId}) : super(timestamp: DateTime.now());
  final String projectId;
}

final class ProjectFinished extends MentorEvent {
  ProjectFinished({required this.projectId}) : super(timestamp: DateTime.now());
  final String projectId;
}

final class ReviewCompleted extends MentorEvent {
  ReviewCompleted({required this.concept, required this.score})
      : super(timestamp: DateTime.now());
  final String concept;
  final int score;
}

final class ManualRead extends MentorEvent {
  ManualRead({required this.articleId}) : super(timestamp: DateTime.now());
  final String articleId;
}

final class DictionaryViewed extends MentorEvent {
  DictionaryViewed({required this.termId}) : super(timestamp: DateTime.now());
  final String termId;
}
