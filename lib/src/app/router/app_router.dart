import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/core/error/app_error_boundary.dart';
import 'package:oraculo_ia/src/features/assessment/presentation/assessment_screen.dart';
import 'package:oraculo_ia/src/features/beta/presentation/beta_screens.dart';
import 'package:oraculo_ia/src/features/career/career_paths.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_screens.dart';
import 'package:oraculo_ia/src/features/creator_studio/presentation/creator_studio_screen.dart';
import 'package:oraculo_ia/src/features/editorial/presentation/editorial_status_screen.dart';
import 'package:oraculo_ia/src/features/knowledge_map/presentation/knowledge_map_screen.dart';
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_screen.dart';
import 'package:oraculo_ia/src/features/manual_export/presentation/manual_export_screen.dart';
import 'package:oraculo_ia/src/features/mentor/presentation/mentor_panel_screen.dart';
import 'package:oraculo_ia/src/features/mentor/presentation/profile_screen.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/current_mission_screen.dart';
import 'package:oraculo_ia/src/features/model_comparator/presentation/model_comparator_screen.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/splash_screen.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/welcome_screen.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';
import 'package:oraculo_ia/src/features/progress/presentation/progress_screen.dart';
import 'package:oraculo_ia/src/features/progress/presentation/simulated_progress.dart';
import 'package:oraculo_ia/src/features/projects/project_builder.dart';
import 'package:oraculo_ia/src/features/prompt_lab/presentation/prompt_lab_screen.dart';
import 'package:oraculo_ia/src/features/review/presentation/review_screen.dart';
import 'package:oraculo_ia/src/features/thought_library/presentation/thought_library_screen.dart';

abstract final class AppRoute {
  static const splash = '/';
  static const welcome = '/welcome';
  static const mission = '/mission';
  static const lesson = '/lesson';
  static const progress = '/progress';
  static const manual = '/manual';
  static const dictionary = '/dictionary';
  static const catalog = '/catalog';
  static const thoughts = '/thoughts';
  static const promptLab = '/prompt-lab';
  static const knowledgeMap = '/knowledge-map';
  static const about = '/about';
  static const backup = '/backup';
  static const modelComparator = '/model-comparator';
  static const learnerProfile = '/learner-profile';
  static const assessment = '/assessment';
  static const review = '/review';
  static const editorial = '/editorial';
  static const manualExport='/manual-export';
  static const projects='/projects';
  static const career='/career';
  static const creatorStudio = '/creator-studio';
  static const mentorPanel = '/mentor-panel';

  static String lessonFor(Mission mission) {
    return '$lesson/${mission.id}/${mission.lessonId}';
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.splash,
    errorBuilder: (context, state) => RecoveryScreen(
      message: state.error?.toString() ?? 'Ruta no disponible.',
      onRecover: () => context.go(AppRoute.mission),
    ),
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
                final learning = ref.watch(learningStateProvider).value;
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
                    if (learning != null &&
                        learning.currentLessonId != 'lesson-models-001') {
                      context.go(
                        '${AppRoute.lesson}/${learning.currentLessonId}/${learning.currentLessonId}',
                      );
                      return;
                    }
                    ref
                        .read(simulatedProgressProvider.notifier)
                        .startMission001();
                    context.go(AppRoute.lessonFor(mission));
                  },
                  onManual: () => context.push(AppRoute.manual),
                  onDictionary: () => context.push(AppRoute.dictionary),
                  onCatalog: () => context.push(AppRoute.catalog),
                  onThoughtLibrary: () => context.push(AppRoute.thoughts),
                  onPromptLab: () => context.push(AppRoute.promptLab),
                  onKnowledgeMap: () => context.push(AppRoute.knowledgeMap),
                  onAbout: () => context.push(AppRoute.about),
                  onBackup: () => context.push(AppRoute.backup),
                  onModelComparator: () => context.push(AppRoute.modelComparator),
                  onLearnerProfile: () => context.push(AppRoute.learnerProfile),
                  onAssessment: () => context.push(AppRoute.assessment),
                  onReview: () => context.push(AppRoute.review),
                  onEditorial: () => context.push(AppRoute.editorial),
                  onManualExport:()=>context.push(AppRoute.manualExport),
                  onProjects:()=>context.push(AppRoute.projects),
                  onCareer:()=>context.push(AppRoute.career),
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
          return CatalogScreen(
            onOpenLesson:
                (lesson) => context.push(
                  '${AppRoute.lesson}/${lesson.id}/${lesson.id}',
                ),
          );
        },
      ),
      GoRoute(
        path: AppRoute.thoughts,
        builder: (context, state) => const ThoughtLibraryScreen(),
      ),
      GoRoute(
        path: AppRoute.promptLab,
        builder: (context, state) => const PromptLabScreen(),
      ),
      GoRoute(
        path: AppRoute.knowledgeMap,
        builder:
            (context, state) => KnowledgeMapScreen(
              onOpenMission: (id) => context.push('${AppRoute.lesson}/$id/$id'),
            ),
      ),
      GoRoute(
        path: AppRoute.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoute.backup,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: AppRoute.modelComparator,
        builder: (context, state) => const ModelComparatorScreen(),
      ),
      GoRoute(
        path: AppRoute.learnerProfile,
        builder: (context, state) => const LearnerProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.assessment,
        builder: (context, state) => const AssessmentScreen(),
      ),
      GoRoute(
        path: AppRoute.review,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(path: AppRoute.editorial,builder:(context,state)=>const EditorialStatusScreen()),
      GoRoute(path:AppRoute.manualExport,builder:(context,state)=>const ManualExportScreen()),
      GoRoute(path:AppRoute.projects,builder:(context,state)=>const ProjectBuilderScreen()),
      GoRoute(path:AppRoute.career,builder:(context,state)=>const CareerPathsScreen()),
      GoRoute(
        path: AppRoute.creatorStudio,
        builder: (context, state) => const CreatorStudioScreen(),
      ),
      GoRoute(
        path: AppRoute.mentorPanel,
        builder: (context, state) => const MentorPanelScreen(),
      ),
    ],
  );
});
