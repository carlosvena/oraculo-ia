import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
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
        const SizedBox(height: 16),
        const Text('Beta local 1.8'),
        const SizedBox(height: 12),
        const Text(
          'Un mentor offline en español para desarrollar criterio y capacidad práctica en Inteligencia Artificial.',
        ),
        const SizedBox(height: 12),
        const Text(
          'Mission First · aprendizaje activo · contenido versionado · progreso local · privacidad por diseño.',
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
  String message = '';
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(learningStateProvider).value ?? const LearningState();
    final exported = jsonEncode(state.toJson());
    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Respaldo local',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Exportá el progreso como JSON o pegá un respaldo para validarlo antes de importar.',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: exported));
              setState(() => message = 'Respaldo copiado.');
            },
            icon: const Icon(Icons.copy),
            label: const Text('COPIAR JSON'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'Importar respaldo JSON',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              try {
                final restored = LearningState.fromJson(
                  jsonDecode(controller.text) as Map<String, dynamic>,
                );
                await ref
                    .read(learningStateProvider.notifier)
                    .restore(restored);
                setState(
                  () =>
                      message =
                          'Respaldo importado: ${restored.completed.length} misiones.',
                );
              } catch (_) {
                setState(() => message = 'El respaldo no es válido.');
              }
            },
            child: const Text('IMPORTAR RESPALDO'),
          ),
          if (message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(message),
            ),
        ],
      ),
    );
  }
}
