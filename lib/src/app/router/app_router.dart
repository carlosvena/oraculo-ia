import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_screens.dart';
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
  static const manual = '/manual';
  static const dictionary = '/dictionary';
  static const catalog = '/catalog';

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
                  onManual: () => context.push(AppRoute.manual),
                  onDictionary: () => context.push(AppRoute.dictionary),
                  onCatalog: () => context.push(AppRoute.catalog),
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
      GoRoute(
        path: AppRoute.manual,
        builder:
            (context, state) => ManualScreen(
              onOpenDictionary:
                  (id) => context.push('${AppRoute.dictionary}?term=$id'),
            ),
      ),
      GoRoute(
        path: AppRoute.dictionary,
        builder:
            (context, state) => DictionaryScreen(
              initialTerm: state.uri.queryParameters['term'],
            ),
      ),
      GoRoute(
        path: AppRoute.catalog,
        builder: (context, state) {
          final unlocked =
              ref.watch(simulatedProgressProvider).status ==
              MissionProgressStatus.completed;
          return CatalogScreen(
            mission002Unlocked: unlocked,
            onOpenMission002:
                () => context.push(
                  '${AppRoute.lesson}/mission-prompts-002/lesson-prompts-002',
                ),
          );
        },
      ),
    ],
  );
});
