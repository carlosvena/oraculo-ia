import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';
import 'package:oraculo_ia/src/features/missions/presentation/current_mission_view_model.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

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
    required this.onKnowledgeMap,
    required this.onAbout,
    required this.onBackup,
    required this.onModelComparator,
    required this.onLearnerProfile,
    required this.onAssessment,
    required this.onReview,
    required this.onEditorial,
    required this.onManualExport,
    required this.onProjects,
    required this.onCareer,
    super.key,
  });
  final String statusLabel, nextAction;
  final double progress;
  final int estimatedMinutes;
  final ValueChanged<Mission> onContinue;
  final VoidCallback onManual,
      onDictionary,
      onCatalog,
      onThoughtLibrary,
      onPromptLab,
      onKnowledgeMap,
      onAbout,
      onBackup;
  final VoidCallback onModelComparator;
  final VoidCallback onLearnerProfile;
  final VoidCallback onAssessment;
  final VoidCallback onReview;
  final VoidCallback onEditorial;
  final VoidCallback onManualExport;
  final VoidCallback onProjects;
  final VoidCallback onCareer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mission = ref.watch(currentMissionViewModelProvider);
    final learning =
        ref.watch(learningStateProvider).value ?? const LearningState();
    return OraculoScaffold(
      body: AsyncContent<Mission>(
        value: mission,
        errorMessage: l10n.missionLoadError,
        retryLabel: l10n.retry,
        onRetry:
            () => ref.read(currentMissionViewModelProvider.notifier).retry(),
        data:
            (value) => ListView(
              children: <Widget>[
                Text(
                  l10n.mentorGreeting,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  learning.reviewConcepts.isEmpty
                      ? 'Hoy tenés una misión clara para seguir avanzando.'
                      : 'Tenés ${learning.reviewConcepts.length} concepto para repasar antes de avanzar.',
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _Metric(
                        label: 'Estudiado',
                        value: '${learning.studyMinutes} min',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: _Metric(
                        label: 'Meta semanal',
                        value: '${learning.completed.length}/2 misiones',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Misión recomendada',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '$statusLabel · ${l10n.estimatedTime(estimatedMinutes)}',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: AppSpacing.xs),
                        Text(nextAction),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryMissionAction(
                  label: l10n.continueMission,
                  onPressed: () => onContinue(value),
                ),
                const SizedBox(height: AppSpacing.md),
                if (learning.reviewConcepts.isNotEmpty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.replay),
                      title: const Text('Repaso pendiente'),
                      subtitle: Text(learning.reviewConcepts.join(' · ')),
                    ),
                  ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: const Text('Próximo objetivo'),
                    subtitle: Text(
                      learning.completed.length >= 5
                          ? 'Aplicar y revisar lo aprendido.'
                          : 'Completar la próxima misión desbloqueada.',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Explorar', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  children: [
                    _Access('Manual', Icons.menu_book_outlined, onManual),
                    _Access('Diccionario', Icons.translate, onDictionary),
                    _Access('Catálogo', Icons.grid_view, onCatalog),
                    _Access('Ideas', Icons.lightbulb_outline, onThoughtLibrary),
                    _Access('Laboratorio', Icons.edit_note, onPromptLab),
                    _Access('Mapa', Icons.hub_outlined, onKnowledgeMap),
                    _Access('Modelos', Icons.compare_arrows, onModelComparator),
                    _Access('Mi perfil', Icons.person_outline, onLearnerProfile),
                    _Access('Evaluación', Icons.fact_check_outlined, onAssessment),
                    _Access('Repaso', Icons.replay_circle_filled_outlined, onReview),
                    _Access('Conocimiento', Icons.verified_outlined, onEditorial),
                    _Access('Manual Maestro', Icons.picture_as_pdf_outlined, onManualExport),
                    _Access('Proyectos', Icons.construction_outlined, onProjects),
                    _Access('Caminos', Icons.route_outlined, onCareer),
                    _Access('Respaldo', Icons.save_alt, onBackup),
                    _Access('Acerca', Icons.info_outline, onAbout),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const Center(
                  child: Text(
                    'ORÁCULO IA Beta local · versión 1.8',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
}

class _Access extends StatelessWidget {
  const _Access(this.label, this.icon, this.action);
  final String label;
  final IconData icon;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: action,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
