import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/onboarding_providers.dart';

final splashViewModelProvider = AsyncNotifierProvider<SplashViewModel, bool>(
  SplashViewModel.new,
);

final class SplashViewModel extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return ref.read(getOnboardingStatusProvider)();
  }
}
