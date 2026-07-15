import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/onboarding_providers.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';

final splashViewModelProvider = AsyncNotifierProvider<SplashViewModel, bool>(
  SplashViewModel.new,
);

final class SplashViewModel extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    await Future.wait([
      KnowledgeEngine.instance.initialize(),
      ProfessionalRepository.instance.initialize(),
      WorkspaceRepository.instance.initialize(),
      Future<void>.delayed(const Duration(milliseconds: 900)),
    ]);
    return ref.read(getOnboardingStatusProvider)();
  }
}
