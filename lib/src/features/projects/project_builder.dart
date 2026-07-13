import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/projects/domain/learning_project.dart';

class ProjectBuilderScreen extends StatefulWidget {
  const ProjectBuilderScreen({super.key});

  @override
  State<ProjectBuilderScreen> createState() => _ProjectBuilderScreenState();
}

class _ProjectBuilderScreenState extends State<ProjectBuilderScreen> {
  final done = <String>{};

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: FutureBuilder<List<LearningProject>>(
        future: KnowledgeEngine.instance.initialize().then((_) => KnowledgeEngine.instance.projects),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final projects = snapshot.data!;
          return ListView(
            children: [
              Text(
                'Constructor de proyectos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Elegí qué querés construir y convertí aprendizaje en entregables.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final p in projects)
                Card(
                  child: ExpansionTile(
                    title: Text(p.title),
                    subtitle: Text(
                      '${p.missions.length} misiones previas · ${done.where((x) => x.startsWith(p.id)).length}/${p.steps.length} pasos',
                    ),
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          p.objective,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      _buildBulletList('Conocimientos requeridos', p.knowledge),
                      _buildBulletList('Misiones de referencia', p.missions),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: Text(
                          'Pasos del proyecto',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      for (final (index, step) in p.steps.indexed)
                        CheckboxListTile(
                          value: done.contains('${p.id}:$index'),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (v) => setState(() => v!
                              ? done.add('${p.id}:$index')
                              : done.remove('${p.id}:$index')),
                          title: Text(step),
                        ),
                      const SizedBox(height: AppSpacing.xs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: done.where((x) => x.startsWith(p.id)).length / p.steps.length,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildBulletList('Entregables esperados', p.deliverables),
                      _buildBulletList('Criterios de éxito', p.success),
                      _buildBulletList('Riesgos a mitigar', p.risks),
                      _buildBulletList('Evaluación final', [p.evaluation]),
                      _buildBulletList(
                        'Documentación que vas a crear',
                        ['Decisiones tomadas', 'Pruebas ejecutadas', 'Resultados obtenidos', 'Próximos pasos'],
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

  Widget _buildBulletList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
