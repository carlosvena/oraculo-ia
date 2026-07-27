import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/welcome_view_model.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(welcomeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(flex: 2),
              Icon(
                Icons.explore_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.welcomeTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.welcomeBody,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed:
                    state.isLoading
                        ? null
                        : () async {
                          await ref
                              .read(welcomeViewModelProvider.notifier)
                              .continueToMission();
                          if (!context.mounted) return;
                          final result = ref.read(welcomeViewModelProvider);
                          if (result.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.onboardingSaveError)),
                            );
                          } else {
                            onCompleted();
                          }
                        },
                child:
                    state.isLoading
                        ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(l10n.start),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
