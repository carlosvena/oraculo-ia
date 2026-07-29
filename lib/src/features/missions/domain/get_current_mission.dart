import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission_repository.dart';

final class GetCurrentMission {
  const GetCurrentMission(this._repository);

  final MissionRepository _repository;

  Future<Mission> call({Set<String> completedLessonIds = const <String>{}}) =>
      _repository.getCurrentMission(completedLessonIds: completedLessonIds);
}
