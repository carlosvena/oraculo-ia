import 'package:oraculo_ia/src/features/onboarding/domain/onboarding_repository.dart';

final class GetOnboardingStatus {
  const GetOnboardingStatus(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() => _repository.hasCompletedOnboarding();
}
