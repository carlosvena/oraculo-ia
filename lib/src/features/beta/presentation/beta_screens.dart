import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/core/app_metadata.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => OraculoScaffold(
    body: ListView(
      children: [
        Text('Acerca de ORÁCULO IA', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        const Text('Beta local ${AppMetadata.version} (${AppMetadata.buildNumber})'),
        const Text('Compilación: ${AppMetadata.buildDate}'),
        const SizedBox(height: 20),
        Text('Notas de versión', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final note in AppMetadata.releaseNotes)
          ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(note)),
        const SizedBox(height: 12),
        const Text(
          'Mentor offline en español para desarrollar criterio y capacidad práctica en Inteligencia Artificial.',
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
  String message = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  LearningState _decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) throw const FormatException('El respaldo debe ser un objeto JSON.');
    return LearningState.fromJson(decoded);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningStateProvider).value ?? const LearningState();
    final exported = jsonEncode(state.toJson());
    return OraculoScaffold(
      body: ListView(
        children: [
          Text('Respaldo local', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Primero validaremos y mostraremos un resumen. Nada se sobrescribe sin tu confirmación.'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: exported));
              setState(() => message = 'Respaldo copiado al portapapeles.');
            },
            icon: const Icon(Icons.copy),
            label: const Text('COPIAR RESPALDO JSON'),
          ),
          const SizedBox(height: 10),
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
              setState(() => message = 'Diagnóstico local copiado. No contiene respuestas ni datos personales.');
            },
            icon: const Icon(Icons.monitor_heart_outlined),
            label: const Text('COPIAR DIAGNÓSTICO'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(labelText: 'Pegar respaldo JSON', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              try {
                setState(() {
                  preview = _decode(controller.text);
                  message = 'Respaldo válido. Revisá la vista previa antes de importar.';
                });
              } catch (error) {
                setState(() {
                  preview = null;
                  message = 'No pudimos validar el respaldo: $error';
                });
              }
            },
            child: const Text('VALIDAR Y VER VISTA PREVIA'),
          ),
          if (preview case final value?) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Vista previa', style: Theme.of(context).textTheme.titleMedium),
                  Text('Misiones completadas: ${value.completed.length}'),
                  Text('Tiempo estudiado: ${value.studyMinutes} minutos'),
                  Text('Misión actual: ${value.currentLessonId}'),
                  Text('Conceptos para repasar: ${value.reviewConcepts.length}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      await ref.read(learningStateProvider.notifier).restore(value);
                      if (mounted) setState(() { preview = null; message = 'Respaldo importado correctamente.'; });
                    },
                    child: const Text('CONFIRMAR IMPORTACIÓN'),
                  ),
                ]),
              ),
            ),
          ],
          if (message.isNotEmpty)
            Padding(padding: const EdgeInsets.only(top: 12), child: Semantics(liveRegion: true, child: Text(message))),
        ],
      ),
    );
  }
}
