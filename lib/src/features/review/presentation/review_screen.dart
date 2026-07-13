import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';
import 'package:oraculo_ia/src/features/review/domain/review_engine.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int minutes = 5;
  final answers = <String, String>{};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningStateProvider).value ?? const LearningState();
    final plan = const LocalReviewEngine().create(state, minutes);

    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Repaso inteligente',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Recordá activamente. Primero respondé; después compará con la explicación.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 5, label: Text('5 min')),
              ButtonSegment(value: 15, label: Text('15 min')),
              ButtonSegment(value: 30, label: Text('30 min')),
            ],
            selected: {minutes},
            onSelectionChanged: (value) => setState(() => minutes = value.single),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (plan.items.isEmpty)
            const Card(
              child: ListTile(
                title: Text('Nada urgente para repasar'),
                subtitle: Text('Completá una misión o marcá un concepto difícil.'),
              ),
            ),
          for (final item in plan.items)
            Card(
              child: ExpansionTile(
                title: Text(item.concept),
                subtitle: Text(
                  '${item.reason}\nVuelve: ${item.nextReview.day}/${item.nextReview.month}',
                ),
                shape: const Border(),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      item.prompt,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  TextFormField(
                    initialValue: answers[item.concept],
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Tu recuperación activa',
                    ),
                    onChanged: (value) => answers[item.concept] = value,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ExpansionTile(
                    title: const Text(
                      'Ver explicación',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    shape: const Border(),
                    childrenPadding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.explanation,
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    '¿Cuánta seguridad sentís?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Slider(
                    value: (state.confidence[item.concept] ?? 2).toDouble(),
                    min: 1,
                    max: 4,
                    divisions: 3,
                    label: '${state.confidence[item.concept] ?? 2}/4',
                    onChanged: (value) =>
                        ref.read(learningStateProvider.notifier).setConfidence(item.concept, value.round()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
