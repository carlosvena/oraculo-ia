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
    super.key,
  });

  final String statusLabel;
  final String nextAction;
  final double progress;
  final int estimatedMinutes;
  final ValueChanged<Mission> onContinue;

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
              ],
            ),
      ),
    );
  }
}
