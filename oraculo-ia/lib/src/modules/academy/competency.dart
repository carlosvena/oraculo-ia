/// Nivel observable de dominio esperado para una competencia.
enum CompetencyLevel { foundational, developing, proficient, advanced }

/// Resultado educativo compuesto por una o más habilidades.
final class Competency {
  Competency({
    required this.id,
    required this.name,
    required this.description,
    required Set<String> skillIds,
    required this.targetLevel,
  }) : skillIds = Set<String>.unmodifiable(skillIds);

  final String id;
  final String name;
  final String description;
  final Set<String> skillIds;
  final CompetencyLevel targetLevel;
}
