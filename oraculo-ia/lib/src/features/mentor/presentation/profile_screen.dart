import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class LearnerProfileScreen extends ConsumerStatefulWidget {
  const LearnerProfileScreen({super.key});
  @override
  ConsumerState<LearnerProfileScreen> createState() => _LearnerProfileScreenState();
}

class _LearnerProfileScreenState extends ConsumerState<LearnerProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController workController;
  String message = '';
  bool _initialized = false;

  @override
  void dispose() {
    nameController.dispose();
    workController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learningState = ref.watch(learningStateProvider).value ?? const LearningState();
    if (!_initialized) {
      nameController = TextEditingController(text: learningState.learnerName);
      workController = TextEditingController(text: learningState.learnerWork);
      _initialized = true;
    }
    final profile = LearnerProfile.fromState(learningState);
    return OraculoScaffold(
      body: ListView(
        children: [
          Text('Mi perfil', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text(
            'Este perfil vive solo en este dispositivo y adapta los ejemplos '
            'del mentor a tu trabajo real. No se envía a servicios externos.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Tu nombre',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: workController,
            decoration: const InputDecoration(
              labelText: 'A qué te dedicás',
              hintText: 'Ej: bibliotecario, contador, docente, comerciante...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('GUARDAR PERFIL'),
            onPressed: () async {
              await ref.read(learningStateProvider.notifier).setProfile(
                    name: nameController.text,
                    work: workController.text,
                  );
              if (mounted) setState(() => message = 'Perfil guardado.');
            },
          ),
          if (message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Semantics(liveRegion: true, child: Text(message)),
            ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Text('Cómo te ve el mentor ahora', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _Item('Nombre', profile.displayName),
          _Item('Trabajo', profile.hasWork ? profile.work : 'Sin cargar todavía'),
          _Item('Recorrido', profile.intensive ? 'Modo intensivo' : 'Modo esencial'),
          _Item('Dificultad', profile.difficulty),
          _Item('Intereses', profile.interests.join(' · ')),
          _Item('Temas prioritarios', profile.priorities.join(' · ')),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.title, this.value);
  final String title, value;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(title: Text(title), subtitle: Text(value)));
}
