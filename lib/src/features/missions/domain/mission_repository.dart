import 'package:oraculo_ia/src/features/missions/domain/mission.dart';

abstract interface class MissionRepository {
  Future<Mission> getCurrentMission({
    Set<String> completedLessonIds = const <String>{},
  });
}

