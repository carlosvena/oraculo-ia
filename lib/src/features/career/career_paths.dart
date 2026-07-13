import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class CareerPath {
  const CareerPath(
    this.id,
    this.priority,
    this.title,
    this.level,
    this.skills,
    this.missions,
    this.projects,
    this.hours,
    this.finalEvaluation,
  );

  final String id, title, level, finalEvaluation;
  final int priority, hours;
  final List<String> skills, missions, projects;
}

List<CareerPath> parseCareerPaths(String s) {
  final r = jsonDecode(s) as Map<String, dynamic>;
  return (r['paths'] as List).cast<Map<String, dynamic>>().map((p) {
    List<String> l(String k) => (p[k] as List).cast<String>();
    return CareerPath(
      p['id'] as String,
      p['priority'] as int,
      p['title'] as String,
      p['level'] as String,
      l('skills'),
      l('missions'),
      l('projects'),
      p['hours'] as int,
      p['final'] as String,
    );
  }).toList()
    ..sort((a, b) => a.priority.compareTo(b.priority));
}

class CareerPathsScreen extends ConsumerWidget {
  const CareerPathsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(learningStateProvider).value?.completed.length ?? 0;

    return OraculoScaffold(
      body: FutureBuilder<List<CareerPath>>(
        future: rootBundle.loadString('knowledge/career_paths_v1.json').then(parseCareerPaths),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar caminos profesionales.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final paths = snapshot.data!;
          return ListView(
            children: [
              Text(
                'Caminos profesionales',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Prioridad personalizada para Carlos.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final p in paths)
                Card(
                  child: ExpansionTile(
                    title: Text('${p.priority}. ${p.title}'),
                    subtitle: Text('${p.level} · ${p.hours} h'),
                    shape: const Border(), // Removes the default border when expanded
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.xs,
                          bottom: AppSpacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Progreso del camino',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (completed / p.missions.length).clamp(0.0, 1.0),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Habilidades'),
                        subtitle: Text(p.skills.join(' · ')),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Misiones obligatorias'),
                        subtitle: Text(p.missions.join(' · ')),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Proyectos'),
                        subtitle: Text(p.projects.join(' · ')),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Conocimientos pendientes'),
                        subtitle: Text(
                          '${(p.missions.length - completed).clamp(0, p.missions.length)} misiones del camino',
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Evaluación final'),
                        subtitle: Text(p.finalEvaluation),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
