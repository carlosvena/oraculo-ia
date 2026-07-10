/// Snapshot mínimo del alumno que necesita un motor de aprendizaje para decidir.
///
/// Contiene identificadores y señales pedagógicas, no datos de UI ni persistencia.
final class LearningContext {
  LearningContext({
    required this.learnerId,
    required Set<String> completedMissionIds,
    required Map<String, double> masteryBySkill,
    required List<String> recentMissionIds,
    required this.now,
    this.currentMissionId,
  }) : completedMissionIds = Set<String>.unmodifiable(completedMissionIds),
       masteryBySkill = Map<String, double>.unmodifiable(masteryBySkill),
       recentMissionIds = List<String>.unmodifiable(recentMissionIds);

  final String learnerId;
  final String? currentMissionId;
  final Set<String> completedMissionIds;
  final Map<String, double> masteryBySkill;
  final List<String> recentMissionIds;
  final DateTime now;
}

/// Misión elegible expresada sólo con las señales necesarias para decidir.
final class MissionCandidate {
  MissionCandidate({
    required this.id,
    required Set<String> skillIds,
    required Set<String> prerequisiteMissionIds,
    required this.difficulty,
    required this.estimatedMinutes,
  }) : skillIds = Set<String>.unmodifiable(skillIds),
       prerequisiteMissionIds = Set<String>.unmodifiable(
         prerequisiteMissionIds,
       );

  final String id;
  final Set<String> skillIds;
  final Set<String> prerequisiteMissionIds;
  final double difficulty;
  final int estimatedMinutes;
}

/// Resultado explicable producido al elegir la próxima misión.
final class LearningDecision {
  const LearningDecision({
    required this.missionId,
    required this.strategyId,
    required this.reason,
  });

  final String missionId;
  final String strategyId;
  final String reason;
}

/// Evidencia normalizada de una experiencia de aprendizaje completada.
final class LearningEvidence {
  const LearningEvidence({
    required this.missionId,
    required this.skillId,
    required this.score,
    required this.attempts,
    required this.studySeconds,
    required this.completedAt,
  });

  final String missionId;
  final String skillId;
  final double score;
  final int attempts;
  final int studySeconds;
  final DateTime completedAt;
}

/// Oportunidad opcional para ampliar una misión sin romper el camino principal.
final class CuriosityOpportunity {
  const CuriosityOpportunity({
    required this.id,
    required this.relatedMissionId,
    required this.relevance,
    required this.reason,
  });

  final String id;
  final String relatedMissionId;
  final double relevance;
  final String reason;
}
