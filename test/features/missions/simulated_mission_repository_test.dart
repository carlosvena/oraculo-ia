import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/missions/data/simulated_mission_repository.dart';

void main() {
  test('returns the deterministic current mission', () async {
    const repository = SimulatedMissionRepository();

    final mission = await repository.getCurrentMission();

    expect(mission.id, 'mission-foundations-001');
    expect(mission.prerequisiteIds, isEmpty);
  });
}
