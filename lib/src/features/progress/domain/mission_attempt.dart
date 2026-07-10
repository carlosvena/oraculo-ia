final class MissionAttempt {
  const MissionAttempt({
    required this.id,
    required this.missionId,
    required this.missionContentVersion,
    required this.startedAt,
    required this.studySeconds,
    this.completedAt,
  });

  final String id;
  final String missionId;
  final int missionContentVersion;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int studySeconds;
}
