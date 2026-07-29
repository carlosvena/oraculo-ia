final class Mission {
  Mission({
    required this.id,
    required this.contentVersion,
    required this.lessonId,
    required this.title,
    required this.estimatedMinutes,
    required this.sequence,
    required List<String> prerequisiteIds,
  }) : prerequisiteIds = List<String>.unmodifiable(prerequisiteIds);

  final String id;
  final int contentVersion;
  final String lessonId;
  final String title;
  final int estimatedMinutes;
  final int sequence;
  final List<String> prerequisiteIds;
}

/// Las 5 misiones núcleo del recorrido principal, en orden. Antes solo
/// existía la primera (hardcodeada) y no había forma de avanzar a las
/// siguientes desde la pantalla "Hoy" — ver [nextCoreMission].
final List<Mission> coreMissions = <Mission>[
  Mission(
    id: 'mission-foundations-001',
    contentVersion: 1,
    lessonId: 'lesson-models-001',
    title: 'Qué es realmente un modelo de IA',
    estimatedMinutes: 15,
    sequence: 1,
    prerequisiteIds: const <String>[],
  ),
  Mission(
    id: 'mission-prompts-002',
    contentVersion: 1,
    lessonId: 'lesson-prompts-002',
    title: 'Anatomía de un prompt profesional',
    estimatedMinutes: 40,
    sequence: 2,
    prerequisiteIds: const <String>['lesson-models-001'],
  ),
  Mission(
    id: 'mission-llm-003',
    contentVersion: 1,
    lessonId: 'lesson-llm-003',
    title: 'Qué es un LLM',
    estimatedMinutes: 45,
    sequence: 3,
    prerequisiteIds: const <String>['lesson-prompts-002'],
  ),
  Mission(
    id: 'mission-context-004',
    contentVersion: 1,
    lessonId: 'lesson-context-004',
    title: 'Tokens y ventana de contexto',
    estimatedMinutes: 45,
    sequence: 4,
    prerequisiteIds: const <String>['lesson-llm-003'],
  ),
  Mission(
    id: 'mission-prompts-005',
    contentVersion: 1,
    lessonId: 'lesson-prompts-005',
    title: 'Cómo construir prompts profesionales',
    estimatedMinutes: 60,
    sequence: 5,
    prerequisiteIds: const <String>['lesson-context-004'],
  ),
];

/// Devuelve la primera misión núcleo que todavía no está en [completedLessonIds].
/// Si ya se completaron las 5, devuelve la última (para repasarla).
Mission nextCoreMission(Set<String> completedLessonIds) {
  for (final mission in coreMissions) {
    if (!completedLessonIds.contains(mission.lessonId)) return mission;
  }
  return coreMissions.last;
}
