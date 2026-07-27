import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/mission_providers.dart';

final currentMissionViewModelProvider =
    AsyncNotifierProvider<CurrentMissionViewModel, Mission>(
      CurrentMissionViewModel.new,
    );

final class CurrentMissionViewModel extends AsyncNotifier<Mission> {
  @override
  Future<Mission> build() => ref.read(getCurrentMissionProvider)();

  Future<void> retry() async {
    state = const AsyncLoading<Mission>();
    state = await AsyncValue.guard(() => ref.read(getCurrentMissionProvider)());
  }
}
