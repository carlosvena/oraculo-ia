/// Unidad concreta de conocimiento o capacidad que puede desarrollarse.
final class Skill {
  Skill({
    required this.id,
    required this.name,
    required this.description,
    required Set<String> tags,
  }) : tags = Set<String>.unmodifiable(tags);

  final String id;
  final String name;
  final String description;
  final Set<String> tags;
}
