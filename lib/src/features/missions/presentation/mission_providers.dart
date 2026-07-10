import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/missions/domain/get_current_mission.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission_repository.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  throw UnimplementedError('Debe configurarse durante bootstrap.');
});

final getCurrentMissionProvider = Provider<GetCurrentMission>((ref) {
  return GetCurrentMission(ref.watch(missionRepositoryProvider));
});
