/// Recorrido educativo de alto nivel con una intención y un orden claros.
///
/// Un camino organiza tracks; no guarda progreso personal ni contiene reglas de
/// selección. Es catálogo curricular, no estado del alumno.
final class LearningPath {
  LearningPath({
    required this.id,
    required this.name,
    required this.description,
    required List<String> trackIds,
  }) : trackIds = List<String>.unmodifiable(trackIds);

  final String id;
  final String name;
  final String description;
  final List<String> trackIds;
}
