import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/onboarding_providers.dart';

final welcomeViewModelProvider = AsyncNotifierProvider<WelcomeViewModel, void>(
  WelcomeViewModel.new,
);

final class WelcomeViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> continueToMission() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(
      () => ref.read(completeOnboardingProvider)(),
    );
  }
}
