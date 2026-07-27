import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission_repository.dart';

final class SimulatedMissionRepository implements MissionRepository {
  const SimulatedMissionRepository();

  @override
  Future<Mission> getCurrentMission() async {
    return Mission(
      id: 'mission-foundations-001',
      contentVersion: 1,
      lessonId: 'lesson-models-001',
      title: 'Entender qué es un modelo de IA',
      estimatedMinutes: 15,
      sequence: 1,
      prerequisiteIds: const <String>[],
    );
  }
}
