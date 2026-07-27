/// Secuencia curricular estable de misiones relacionadas.
///
/// Contiene IDs, no objetos Mission. La validez de esos IDs se comprueba al publicar
/// contenido y no acopla Academy al módulo de misiones del runtime.
final class MissionSequence {
  MissionSequence({
    required this.id,
    required this.name,
    required List<String> missionIds,
    required Set<String> prerequisiteSequenceIds,
  }) : missionIds = List<String>.unmodifiable(missionIds),
       prerequisiteSequenceIds = Set<String>.unmodifiable(
         prerequisiteSequenceIds,
       );

  final String id;
  final String name;
  final List<String> missionIds;
  final Set<String> prerequisiteSequenceIds;
}
