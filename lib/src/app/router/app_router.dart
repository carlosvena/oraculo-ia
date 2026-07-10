import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_screen.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/current_mission_screen.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/splash_screen.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/welcome_screen.dart';
import 'package:oraculo_ia/src/features/progress/presentation/progress_screen.dart';
import 'package:oraculo_ia/src/features/progress/presentation/simulated_progress.dart';

abstract final class AppRoute {
  static const splash = '/';
  static const welcome = '/welcome';
  static const mission = '/mission';
  static const lesson = '/lesson';
  static const progress = '/progress';

  static String lessonFor(Mission mission) {
    return '$lesson/${mission.id}/${mission.lessonId}';
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.splash,
        builder:
            (context, state) => SplashScreen(
              onResolved:
                  (completed) => context.go(
                    completed ? AppRoute.mission : AppRoute.welcome,
                  ),
            ),
      ),
      GoRoute(
        path: AppRoute.welcome,
        builder:
            (context, state) =>
                WelcomeScreen(onCompleted: () => context.go(AppRoute.mission)),
      ),
      GoRoute(
        path: AppRoute.mission,
        builder:
            (context, state) => Consumer(
              builder: (context, ref, child) {
                final l10n = AppLocalizations.of(context);
                final progress = ref.watch(simulatedProgressProvider);
                final statusLabel = switch (progress.status) {
                  MissionProgressStatus.notStarted =>
                    l10n.missionStatusNotStarted,
                  MissionProgressStatus.inProgress =>
                    l10n.missionStatusInProgress,
                  MissionProgressStatus.completed =>
                    l10n.missionStatusCompleted,
                };
                final nextAction = switch (progress.status) {
                  MissionProgressStatus.notStarted => l10n.nextActionStart,
                  MissionProgressStatus.inProgress => l10n.nextActionContinue,
                  MissionProgressStatus.completed => l10n.nextActionCompleted,
                };
                return CurrentMissionScreen(
                  statusLabel: statusLabel,
                  nextAction: nextAction,
                  progress: progress.progress,
                  estimatedMinutes: progress.estimatedMinutes,
                  onContinue: (mission) {
                    ref
                        .read(simulatedProgressProvider.notifier)
                        .startMission001();
                    context.go(AppRoute.lessonFor(mission));
                  },
                );
              },
            ),
      ),
      GoRoute(
        path: '${AppRoute.lesson}/:missionId/:lessonId',
        builder:
            (context, state) => LessonScreen(
              missionId: state.pathParameters['missionId']!,
              lessonId: state.pathParameters['lessonId']!,
              onComplete: () async {
                ref
                    .read(simulatedProgressProvider.notifier)
                    .completeMission001();
                if (context.mounted) context.go(AppRoute.progress);
              },
            ),
      ),
      GoRoute(
        path: AppRoute.progress,
        builder:
            (context, state) =>
                ProgressScreen(onContinue: () => context.go(AppRoute.mission)),
      ),
    ],
  );
});
