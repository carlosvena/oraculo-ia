import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/missions/data/simulated_mission_repository.dart';

void main() {
  test('returns the first mission when nothing is completed', () async {
    const repository = SimulatedMissionRepository();

    final mission = await repository.getCurrentMission();

    expect(mission.id, 'mission-foundations-001');
    expect(mission.prerequisiteIds, isEmpty);
  });

  test('advances to the next mission once the current one is completed', () async {
    const repository = SimulatedMissionRepository();

    final mission = await repository.getCurrentMission(
      completedLessonIds: {'lesson-models-001'},
    );

    // Antes de este arreglo, esto seguía devolviendo la misión 1 siempre
    // (bug: la app nunca avanzaba de la primera misión).
    expect(mission.id, 'mission-prompts-002');
    expect(mission.lessonId, 'lesson-prompts-002');
  });

  test('advances through all 5 core missions in order', () async {
    const repository = SimulatedMissionRepository();
    final completed = <String>{};
    final seenIds = <String>[];

    for (var i = 0; i < 5; i++) {
      final mission = await repository.getCurrentMission(
        completedLessonIds: completed,
      );
      seenIds.add(mission.id);
      completed.add(mission.lessonId);
    }

    expect(seenIds, [
      'mission-foundations-001',
      'mission-prompts-002',
      'mission-llm-003',
      'mission-context-004',
      'mission-prompts-005',
    ]);
  });

  test('stays on the last mission once all 5 are completed', () async {
    const repository = SimulatedMissionRepository();

    final mission = await repository.getCurrentMission(
      completedLessonIds: {
        'lesson-models-001',
        'lesson-prompts-002',
        'lesson-llm-003',
        'lesson-context-004',
        'lesson-prompts-005',
      },
    );

    expect(mission.id, 'mission-prompts-005');
  });
}
