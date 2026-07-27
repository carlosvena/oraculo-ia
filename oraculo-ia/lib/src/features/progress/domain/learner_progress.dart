final class LearnerProgress {
  LearnerProgress({
    required this.learnerId,
    required this.currentMissionId,
    required Set<String> completedMissionIds,
    required this.xp,
    required this.level,
    required this.studySeconds,
    required this.streak,
    required this.updatedAt,
  }) : completedMissionIds = Set<String>.unmodifiable(completedMissionIds);

  final String learnerId;
  final String? currentMissionId;
  final Set<String> completedMissionIds;
  final int xp;
  final int level;
  final int studySeconds;
  final int streak;
  final DateTime updatedAt;
}
