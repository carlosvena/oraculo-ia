import 'package:oraculo_ia/src/features/onboarding/domain/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalOnboardingRepository implements OnboardingRepository {
  const LocalOnboardingRepository(this._preferences);

  static const _completedKey = 'onboarding.completed';
  final SharedPreferencesAsync _preferences;

  @override
  Future<void> completeOnboarding() async {
    await _preferences.setBool(_completedKey, true);
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await _preferences.getBool(_completedKey) ?? false;
  }
}
