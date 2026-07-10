import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/lessons/data/simulated_lesson_repository.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_providers.dart';
import 'package:oraculo_ia/src/features/missions/data/simulated_mission_repository.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission_repository.dart';
import 'package:oraculo_ia/src/features/missions/presentation/mission_providers.dart';
import 'package:oraculo_ia/src/features/onboarding/data/local_onboarding_repository.dart';
import 'package:oraculo_ia/src/features/onboarding/domain/onboarding_repository.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/onboarding_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget bootstrap(Widget child) {
  final OnboardingRepository repository = LocalOnboardingRepository(
    SharedPreferencesAsync(),
  );
  const MissionRepository missionRepository = SimulatedMissionRepository();
  const LessonRepository lessonRepository = SimulatedLessonRepository();

  return ProviderScope(
    overrides: [
      onboardingRepositoryProvider.overrideWithValue(repository),
      missionRepositoryProvider.overrideWithValue(missionRepository),
      lessonRepositoryProvider.overrideWithValue(lessonRepository),
    ],
    child: child,
  );
}
