import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/progress/presentation/simulated_progress.dart';

void main() {
  test('completing mission 001 awards the simulated progress', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(simulatedProgressProvider.notifier)
      ..startMission001();
    expect(
      container.read(simulatedProgressProvider).status,
      MissionProgressStatus.inProgress,
    );

    notifier.completeMission001();
    final progress = container.read(simulatedProgressProvider);

    expect(progress.xpEarned, 100);
    expect(progress.level, 1);
    expect(progress.streakDays, 1);
    expect(progress.progress, 1);
    expect(progress.elapsedMinutes, 12);
    expect(progress.status, MissionProgressStatus.completed);
  });
}
