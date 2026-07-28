import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/welcome_view_model.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final nameController = TextEditingController();
  final workController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    workController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(welcomeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 24),
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
              const SizedBox(height: 32),
              Text(
                'Antes de arrancar, contanos quién sos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Así los ejemplos hablan de tu trabajo real, no de uno genérico. '
                'Podés cambiarlo después en "Mi perfil".',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tu nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: workController,
                decoration: const InputDecoration(
                  labelText: 'A qué te dedicás',
                  hintText: 'Ej: bibliotecario, contador, docente...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed:
                    state.isLoading
                        ? null
                        : () async {
                          await ref
                              .read(learningStateProvider.notifier)
                              .setProfile(
                                name: nameController.text,
                                work: workController.text,
                              );
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
                            widget.onCompleted();
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
              TextButton(
                onPressed:
                    state.isLoading
                        ? null
                        : () async {
                          await ref
                              .read(welcomeViewModelProvider.notifier)
                              .continueToMission();
                          if (!context.mounted) return;
                          final result = ref.read(welcomeViewModelProvider);
                          if (!result.hasError) widget.onCompleted();
                        },
                child: const Text('Prefiero cargarlo después'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
