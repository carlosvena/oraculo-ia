import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({required this.onContinue, super.key});
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learning =
        ref.watch(learningStateProvider).value ?? const LearningState();
    final completed = learning.completed.length;
    final journey = (completed / 5).clamp(0.0, 1.0);
    final review =
        learning.reviews[learning.currentLessonId] ?? ReviewLevel.understood;
    return OraculoScaffold(
      bottomAction: PrimaryMissionAction(
        label: 'CONTINUAR MI MISIÓN',
        onPressed: onContinue,
      ),
      body: ListView(
        children: <Widget>[
          Text(
            'Tu progreso real',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'El objetivo no es sumar puntos: es poder aplicar lo aprendido.',
          ),
          const SizedBox(height: AppSpacing.lg),
          LinearProgressIndicator(value: journey, minHeight: 10),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$completed de 5 misiones · ${(journey * 100).round()}% del recorrido',
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  icon: Icons.schedule,
                  label: 'Horas estudiadas',
                  value: (learning.studyMinutes / 60).toStringAsFixed(1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _Metric(
                  icon: Icons.psychology_outlined,
                  label: 'Conceptos dominados',
                  value: '${learning.masteredConcepts.length}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ConceptCard(
            title: 'Conceptos dominados',
            values: learning.masteredConcepts,
            empty: 'Completá una misión para consolidar conceptos.',
          ),
          const SizedBox(height: AppSpacing.md),
          _ConceptCard(
            title: 'Conceptos para revisar',
            values: learning.reviewConcepts,
            empty: 'No marcaste conceptos para revisar.',
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '¿Cómo te sentís con la última misión?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ReviewLevel>(
                    segments: const <ButtonSegment<ReviewLevel>>[
                      ButtonSegment(
                        value: ReviewLevel.understood,
                        label: Text('Entendido'),
                      ),
                      ButtonSegment(
                        value: ReviewLevel.review,
                        label: Text('Repasar'),
                      ),
                      ButtonSegment(
                        value: ReviewLevel.notUnderstood,
                        label: Text('No entendí'),
                      ),
                    ],
                    selected: <ReviewLevel>{review},
                    onSelectionChanged:
                        (values) => ref
                            .read(learningStateProvider.notifier)
                            .setReview(learning.currentLessonId, values.single),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Próxima meta concreta'),
              subtitle: Text(
                completed >= 5
                    ? 'Aplicar una técnica y revisar los conceptos pendientes.'
                    : 'Completar la próxima misión desbloqueada.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({
    required this.title,
    required this.values,
    required this.empty,
  });
  final String title;
  final Set<String> values;
  final String empty;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(values.isEmpty ? empty : values.join(' · ')),
        ],
      ),
    ),
  );
}
