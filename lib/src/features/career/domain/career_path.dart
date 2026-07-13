import 'dart:convert';

/// Camino profesional/curso que agrupa habilidades, misiones y proyectos.
final class CareerPath {
  const CareerPath(
    this.id,
    this.priority,
    this.title,
    this.level,
    this.skills,
    this.missions,
    this.projects,
    this.hours,
    this.finalEvaluation,
  );

  final String id;
  final String title;
  final String level;
  final String finalEvaluation;
  final int priority;
  final int hours;
  final List<String> skills;
  final List<String> missions;
  final List<String> projects;
}

List<CareerPath> parseCareerPaths(String s) {
  final r = jsonDecode(s) as Map<String, dynamic>;
  return (r['paths'] as List).cast<Map<String, dynamic>>().map((p) {
    List<String> l(String k) => (p[k] as List).cast<String>();
    return CareerPath(
      p['id'] as String,
      p['priority'] as int,
      p['title'] as String,
      p['level'] as String,
      l('skills'),
      l('missions'),
      l('projects'),
      p['hours'] as int,
      p['final'] as String,
    );
  }).toList()
    ..sort((a, b) => a.priority.compareTo(b.priority));
}
