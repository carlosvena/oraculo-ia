import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';
import 'package:oraculo_ia/src/features/prompt_lab/data/prompt_exercise_reader.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';

final promptExercisesProvider = FutureProvider<List<PromptExercise>>(
  (ref) => const PromptExerciseReader().load(),
);

class PromptLabScreen extends ConsumerStatefulWidget {
  const PromptLabScreen({super.key});
  @override
  ConsumerState<PromptLabScreen> createState() => _PromptLabScreenState();
}

class _PromptLabScreenState extends ConsumerState<PromptLabScreen> {
  final controller = TextEditingController();
  String? selectedId;
  String category = 'trabajo';
  int level = 1;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises =
        ref.watch(promptExercisesProvider).value ?? const <PromptExercise>[];
    final filtered =
        exercises
            .where((e) => e.category == category && e.level == level)
            .toList();
    final selected = exercises.where((e) => e.id == selectedId).firstOrNull;
    final evaluation = PromptRules.evaluate(controller.text);
    final history =
        ref.watch(learningStateProvider).value?.promptHistory ??
        const <String>[];
    return OraculoScaffold(
      body: ListView(
        children: <Widget>[
          Text(
            'Laboratorio de prompts',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Práctica local basada en reglas editoriales. No envía datos a modelos externos.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                [
                      'trabajo',
                      'Excel',
                      'investigación',
                      'escritura',
                      'aprendizaje',
                      'programación',
                      'automatización',
                    ]
                    .map(
                      (value) => ChoiceChip(
                        label: Text(value),
                        selected: category == value,
                        onSelected: (_) => setState(() => category = value),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Inicial')),
              ButtonSegment(value: 2, label: Text('Intermedio')),
              ButtonSegment(value: 3, label: Text('Avanzado')),
            ],
            selected: <int>{level},
            onSelectionChanged: (v) => setState(() => level = v.single),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final exercise in filtered)
            Card(
              child: ListTile(
                title: Text(exercise.title),
                subtitle: Text(exercise.original),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    selectedId = exercise.id;
                    controller.text = exercise.original;
                  });
                },
              ),
            ),
          if (selected != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              maxLines: 6,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Editor de prompt',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: () {
                ref
                    .read(learningStateProvider.notifier)
                    .addPromptHistory(controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guardado en el historial local.')),
                );
              },
              child: const Text('Guardar en historial'),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Evaluación local: ${evaluation.score}/5',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(evaluation.feedback.join(' · ')),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comparación',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Original\n${selected.original}'),
                    const Divider(),
                    Text('Mejorado\n${selected.improved}'),
                    const Divider(),
                    Text('Por qué mejora\n${selected.why}'),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          (ref
                                      .watch(learningStateProvider)
                                      .value
                                      ?.favorites
                                      .contains('prompt:${selected.id}') ??
                                  false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed:
                            () => ref
                                .read(learningStateProvider.notifier)
                                .toggleFavorite('prompt:${selected.id}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (history.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Historial local',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final item in history.take(5))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: Text(item, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                  controller.text = item;
                  setState(() {});
                },
              ),
          ],
        ],
      ),
    );
  }
}
