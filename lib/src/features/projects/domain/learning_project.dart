import 'dart:convert';

/// Proyecto práctico compuesto por pasos y entregables concretos.
final class LearningProject {
  const LearningProject(
    this.id,
    this.title,
    this.objective,
    this.knowledge,
    this.missions,
    this.steps,
    this.deliverables,
    this.success,
    this.risks,
    this.evaluation,
  );

  final String id;
  final String title;
  final String objective;
  final String evaluation;
  final List<String> knowledge;
  final List<String> missions;
  final List<String> steps;
  final List<String> deliverables;
  final List<String> success;
  final List<String> risks;
}

List<LearningProject> parseProjects(String s) {
  final r = jsonDecode(s) as Map<String, dynamic>;
  if (r['schemaVersion'] != 1) {
    throw const FormatException('Proyectos incompatibles');
  }
  return (r['projects'] as List).cast<Map<String, dynamic>>().map((p) {
    List<String> l(String k) => (p[k] as List).cast<String>();
    return LearningProject(
      p['id'] as String,
      p['title'] as String,
      p['objective'] as String,
      l('knowledge'),
      l('missions'),
      l('steps'),
      l('deliverables'),
      l('success'),
      l('risks'),
      p['evaluation'] as String,
    );
  }).toList();
}
