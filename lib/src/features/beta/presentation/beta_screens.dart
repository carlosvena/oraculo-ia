import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/core/app_metadata.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => OraculoScaffold(
        body: ListView(
          children: [
            Text(
              'Acerca de ORÁCULO IA',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Beta local ${AppMetadata.version} (${AppMetadata.buildNumber})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Compilación: ${AppMetadata.buildDate}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Notas de versión',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final note in AppMetadata.releaseNotes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline, size: 20),
                title: Text(note),
              ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Mentor offline en español para desarrollar criterio y capacidad práctica en Inteligencia Artificial.',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      );
}

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  final controller = TextEditingController();
  LearningState? preview;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  LearningState _decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('El respaldo debe ser un objeto JSON.');
    }
    return LearningState.fromJson(decoded);
  }

  void _showFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningStateProvider).value ?? const LearningState();
    final exported = jsonEncode(state.toJson());

    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Respaldo local',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Primero validaremos y mostraremos un resumen. Nada se sobrescribe sin tu confirmación.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: exported));
              _showFeedback('Respaldo copiado al portapapeles.');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar respaldo JSON'),
          ),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: () async {
              final diagnostic = jsonEncode(<String, Object>{
                'appVersion': AppMetadata.version,
                'build': AppMetadata.buildNumber,
                'buildDate': AppMetadata.buildDate,
                'completedMissions': state.completed.length,
                'studyMinutes': state.studyMinutes,
                'currentLesson': state.currentLessonId,
                'currentBlock': state.currentBlock,
                'reviewCount': state.reviewConcepts.length,
              });
              await Clipboard.setData(ClipboardData(text: diagnostic));
              _showFeedback('Diagnóstico local copiado al portapapeles.');
            },
            icon: const Icon(Icons.monitor_heart_outlined),
            label: const Text('Copiar diagnóstico'),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'Pegar respaldo JSON',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () {
              try {
                setState(() {
                  preview = _decode(controller.text);
                  _showFeedback('Respaldo válido. Revisá la vista previa antes de importar.');
                });
              } catch (error) {
                setState(() {
                  preview = null;
                  _showFeedback('No pudimos validar el respaldo: $error');
                });
              }
            },
            child: const Text('Validar y ver vista previa'),
          ),
          if (preview case final value?) ...[
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vista previa del respaldo',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Misiones completadas: ${value.completed.length}'),
                    Text('Tiempo estudiado: ${value.studyMinutes} minutos'),
                    Text('Misión actual: ${value.currentLessonId}'),
                    Text('Conceptos para repasar: ${value.reviewConcepts.length}'),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: () async {
                        await ref.read(learningStateProvider.notifier).restore(value);
                        if (mounted) {
                          setState(() {
                            preview = null;
                            _showFeedback('Respaldo importado correctamente.');
                          });
                        }
                      },
                      child: const Text('Confirmar importación'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
