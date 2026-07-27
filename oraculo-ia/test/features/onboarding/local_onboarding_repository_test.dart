import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/onboarding/data/local_onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalOnboardingRepository', () {
    test('returns false before onboarding is completed', () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      final repository = LocalOnboardingRepository(SharedPreferencesAsync());

      expect(await repository.hasCompletedOnboarding(), isFalse);
    });

    test('persists completion', () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      final repository = LocalOnboardingRepository(SharedPreferencesAsync());

      await repository.completeOnboarding();

      expect(await repository.hasCompletedOnboarding(), isTrue);
    });
  });
}
