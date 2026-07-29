import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission_repository.dart';

final class SimulatedMissionRepository implements MissionRepository {
  const SimulatedMissionRepository();

  @override
  Future<Mission> getCurrentMission({Set<String> completedLessonIds = const <String>{}}) async {
    return nextCoreMission(completedLessonIds);
  }
}
