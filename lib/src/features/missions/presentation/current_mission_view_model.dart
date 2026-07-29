import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/mission_providers.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

final currentMissionViewModelProvider =
    AsyncNotifierProvider<CurrentMissionViewModel, Mission>(
      CurrentMissionViewModel.new,
    );

final class CurrentMissionViewModel extends AsyncNotifier<Mission> {
  @override
  Future<Mission> build() async {
    // Se vuelve a calcular cada vez que cambia el progreso guardado, para
    // que "Hoy" muestre siempre la próxima misión real, no una fija.
    final completed =
        ref.watch(learningStateProvider).value?.completed ?? const <String>{};
    return ref.read(getCurrentMissionProvider)(completedLessonIds: completed);
  }

  Future<void> retry() async {
    state = const AsyncLoading<Mission>();
    final completed =
        ref.read(learningStateProvider).value?.completed ?? const <String>{};
    state = await AsyncValue.guard(
      () => ref.read(getCurrentMissionProvider)(completedLessonIds: completed),
    );
  }
}
