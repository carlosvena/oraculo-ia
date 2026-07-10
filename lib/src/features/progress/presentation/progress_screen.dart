import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/presentation/simulated_progress.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(simulatedProgressProvider);

    return OraculoScaffold(
      bottomAction: PrimaryMissionAction(
        label: l10n.backToMission,
        onPressed: onContinue,
      ),
      body: ListView(
        children: <Widget>[
          Text(
            l10n.progressTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Icon(
            Icons.check_circle_rounded,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.congratulations,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.missionCompletedMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l10n.missionStatusCompleted} · '
            '${l10n.elapsedTime(progress.elapsedMinutes)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.xpEarned(progress.xpEarned),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(value: progress.progress),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: _ProgressMetric(
                  icon: Icons.school_outlined,
                  label: l10n.levelLabel,
                  value: l10n.levelValue(progress.level),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ProgressMetric(
                  icon: Icons.local_fire_department_outlined,
                  label: l10n.streakLabel,
                  value: l10n.streakValue(progress.streakDays),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Card(
            child: ListTile(
              enabled: false,
              leading: const Icon(Icons.lock_outline_rounded),
              title: Text(l10n.nextMission),
              subtitle: Text(l10n.comingSoon),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
