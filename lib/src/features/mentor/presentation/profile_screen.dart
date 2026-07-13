import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';

class LearnerProfileScreen extends StatelessWidget {
  const LearnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = LearnerProfile();
    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Perfil de Carlos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Este perfil vive solo en el dispositivo y adapta ejemplos editoriales. No se envía a servicios externos.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Item(title: 'Nivel actual', value: profile.level),
          _Item(title: 'Trabajo', value: profile.work),
          _Item(title: 'Recorrido', value: profile.intensive ? 'Modo intensivo' : 'Modo esencial'),
          _Item(title: 'Dificultad', value: profile.difficulty),
          _Item(title: 'Intereses', value: profile.interests.join(' · ')),
          _Item(title: 'Temas prioritarios', value: profile.priorities.join(' · ')),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(value),
        ),
      );
}
