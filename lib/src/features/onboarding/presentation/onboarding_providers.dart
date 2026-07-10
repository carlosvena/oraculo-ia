import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/onboarding/domain/complete_onboarding.dart';
import 'package:oraculo_ia/src/features/onboarding/domain/get_onboarding_status.dart';
import 'package:oraculo_ia/src/features/onboarding/domain/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError('Debe configurarse durante bootstrap.');
});

final getOnboardingStatusProvider = Provider<GetOnboardingStatus>((ref) {
  return GetOnboardingStatus(ref.watch(onboardingRepositoryProvider));
});

final completeOnboardingProvider = Provider<CompleteOnboarding>((ref) {
  return CompleteOnboarding(ref.watch(onboardingRepositoryProvider));
});
