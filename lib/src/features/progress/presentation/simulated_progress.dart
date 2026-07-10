import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MissionProgressStatus { notStarted, inProgress, completed }

final class SimulatedProgress {
  const SimulatedProgress({
    required this.status,
    required this.xpEarned,
    required this.progress,
    required this.level,
    required this.streakDays,
    required this.estimatedMinutes,
    required this.elapsedMinutes,
  });

  const SimulatedProgress.initial()
    : status = MissionProgressStatus.notStarted,
      xpEarned = 0,
      progress = 0,
      level = 1,
      streakDays = 0,
      estimatedMinutes = 15,
      elapsedMinutes = 0;

  final MissionProgressStatus status;
  final int xpEarned;
  final double progress;
  final int level;
  final int streakDays;
  final int estimatedMinutes;
  final int elapsedMinutes;
}

final simulatedProgressProvider =
    NotifierProvider<SimulatedProgressNotifier, SimulatedProgress>(
      SimulatedProgressNotifier.new,
    );

final class SimulatedProgressNotifier extends Notifier<SimulatedProgress> {
  @override
  SimulatedProgress build() => const SimulatedProgress.initial();

  void startMission001() {
    if (state.status != MissionProgressStatus.notStarted) return;
    state = SimulatedProgress(
      status: MissionProgressStatus.inProgress,
      xpEarned: state.xpEarned,
      progress: 0.1,
      level: state.level,
      streakDays: state.streakDays,
      estimatedMinutes: state.estimatedMinutes,
      elapsedMinutes: 0,
    );
  }

  void completeMission001() {
    state = const SimulatedProgress(
      status: MissionProgressStatus.completed,
      xpEarned: 100,
      progress: 1,
      level: 1,
      streakDays: 1,
      estimatedMinutes: 15,
      elapsedMinutes: 12,
    );
  }
}
