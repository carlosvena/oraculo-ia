import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/current_mission_view_model.dart';

class CurrentMissionScreen extends ConsumerWidget {
  const CurrentMissionScreen({
    required this.statusLabel,
    required this.nextAction,
    required this.progress,
    required this.estimatedMinutes,
    required this.onContinue,
    required this.onManual,
    required this.onDictionary,
    required this.onCatalog,
    required this.onThoughtLibrary,
    required this.onPromptLab,
    super.key,
  });

  final String statusLabel;
  final String nextAction;
  final double progress;
  final int estimatedMinutes;
  final ValueChanged<Mission> onContinue;
  final VoidCallback onManual;
  final VoidCallback onDictionary;
  final VoidCallback onCatalog;
  final VoidCallback onThoughtLibrary;
  final VoidCallback onPromptLab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mission = ref.watch(currentMissionViewModelProvider);

    return OraculoScaffold(
      body: AsyncContent<Mission>(
        value: mission,
        errorMessage: l10n.missionLoadError,
        retryLabel: l10n.retry,
        onRetry:
            () => ref.read(currentMissionViewModelProvider.notifier).retry(),
        data:
            (value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.mentorGreeting,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.mentorJourney,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.mentorSingleMission,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  l10n.todayMission,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  value.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.adjust_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusLabel,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Text(l10n.estimatedTime(estimatedMinutes)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 12),
                        Text(nextAction),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryMissionAction(
                  label: l10n.continueMission,
                  onPressed: () => onContinue(value),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: onManual,
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Manual'),
                    ),
                    TextButton.icon(
                      onPressed: onDictionary,
                      icon: const Icon(Icons.translate_rounded),
                      label: const Text('Diccionario'),
                    ),
                    TextButton.icon(
                      onPressed: onCatalog,
                      icon: const Icon(Icons.grid_view_outlined),
                      label: const Text('Catálogo'),
                    ),
                    TextButton.icon(
                      onPressed: onThoughtLibrary,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Ideas'),
                    ),
                    TextButton.icon(
                      onPressed: onPromptLab,
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Laboratorio'),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
