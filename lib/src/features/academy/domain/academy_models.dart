/// Representa un curso dentro de la Academia IA (Módulo 1).
final class AcademyCourse {
  const AcademyCourse({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.durationMinutes,
    required this.missionIds,
    required this.concepts,
  });

  final String id;
  final String category;
  final String title;
  final String description;
  final String difficulty;
  final int durationMinutes;
  final List<String> missionIds;
  final List<String> concepts;
}

/// Representa la planificación y metadatos de una de las 100 misiones (Módulo 2).
final class AcademyMission {
  const AcademyMission({
    required this.id,
    required this.title,
    required this.objective,
    required this.durationMinutes,
    required this.prerequisiteIds,
    required this.concepts,
    required this.difficulty,
    required this.projectAssociated,
  });

  final String id;
  final String title;
  final String objective;
  final int durationMinutes;
  final List<String> prerequisiteIds;
  final List<String> concepts;
  final String difficulty;
  final String? projectAssociated;
}
