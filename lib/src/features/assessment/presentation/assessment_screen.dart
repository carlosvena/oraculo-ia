import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/assessment/domain/assessment.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({super.key});

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  late AssessmentTask task;
  final controller = TextEditingController();
  AssessmentFeedback? feedback;

  @override
  void initState() {
    super.initState();
    task = assessmentTasks.first;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed = ref.watch(learningStateProvider).value?.completed.length ?? 0;
    final available = assessmentTasks
        .where((item) => item.masteryCheckpoint == null || completed >= item.masteryCheckpoint!)
        .toList();

    if (!available.contains(task)) {
      task = available.first;
    }

    final isFavorited = ref.watch(learningStateProvider).value?.favorites.contains('assessment:${task.id}') ?? false;

    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Evaluación real',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Pensá, construí y explicá. La devolución automática es orientativa y siempre admite revisión personal.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<AssessmentTask>(
            initialValue: task,
            decoration: const InputDecoration(
              labelText: 'Actividad de evaluación',
            ),
            items: [
              for (final item in available)
                DropdownMenuItem(
                  value: item,
                  child: Text(item.title),
                )
            ],
            onChanged: (value) => setState(() {
              task = value!;
              feedback = null;
              controller.clear();
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            task.prompt,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            minLines: 7,
            maxLines: 14,
            decoration: const InputDecoration(
              labelText: 'Tu respuesta',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => setState(() => feedback = const LocalRubricEvaluator().evaluate(task, controller.text)),
            child: const Text('Evaluar con rúbrica local'),
          ),
          if (feedback case final result?) ...[
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Resultados de la evaluación',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: result.progress,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in result.criteria)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  item.met ? Icons.check_circle : Icons.pending_outlined,
                  color: item.met ? Colors.green : Colors.orange,
                ),
                title: Text(item.name),
                subtitle: Text(item.message),
              ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejemplo de respuesta sólida',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      task.solidExample,
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                result.disclaimer,
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ref.read(learningStateProvider.notifier).toggleFavorite('assessment:${task.id}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorited ? 'Removido de revisión personal' : 'Marcado para revisión personal',
                    ),
                  ),
                );
              },
              icon: Icon(isFavorited ? Icons.bookmark : Icons.bookmark_add_outlined),
              label: Text(
                isFavorited ? 'Quitar de revisión personal' : 'Marcar para revisión personal',
              ),
            )
          ]
        ],
      ),
    );
  }
}
