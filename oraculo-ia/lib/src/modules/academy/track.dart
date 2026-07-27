/// Línea temática dentro de un camino de aprendizaje.
///
/// Agrupa competencias y secuencias sin decidir cuál debe estudiar el alumno hoy.
final class Track {
  Track({
    required this.id,
    required this.name,
    required this.description,
    required Set<String> competencyIds,
    required List<String> missionSequenceIds,
  }) : competencyIds = Set<String>.unmodifiable(competencyIds),
       missionSequenceIds = List<String>.unmodifiable(missionSequenceIds);

  final String id;
  final String name;
  final String description;
  final Set<String> competencyIds;
  final List<String> missionSequenceIds;
}
