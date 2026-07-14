import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';


class KnowledgeExplorerScreen extends StatefulWidget {
  const KnowledgeExplorerScreen({super.key});

  @override
  State<KnowledgeExplorerScreen> createState() => _KnowledgeExplorerScreenState();
}

class _KnowledgeExplorerScreenState extends State<KnowledgeExplorerScreen> {
  final _ke = KnowledgeEngine.instance;
  String _selectedCourseId = 'Todos';
  String _difficultyFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final courses = _ke.academyCourses;
    final allMissions = _ke.academyMissions;
    final allLabs = _ke.promptExercises;

    // Filtrar misiones
    var filteredMissions = allMissions;
    if (_selectedCourseId != 'Todos') {
      final course = courses.firstWhere((c) => c.id == _selectedCourseId);
      filteredMissions = filteredMissions.where((m) => course.missionIds.contains(m.id)).toList();
    }
    if (_difficultyFilter != 'Todos') {
      filteredMissions = filteredMissions.where((m) => m.difficulty == _difficultyFilter).toList();
    }

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Botón Atrás & Título
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Explorador del Conocimiento',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Navegación jerárquica de cursos, módulos, misiones, conceptos y laboratorios.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.md),

          // Filtros
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCourseId,
                    decoration: const InputDecoration(labelText: 'Filtrar por Curso'),
                    items: [
                      const DropdownMenuItem(value: 'Todos', child: Text('Todos los Cursos')),
                      ...courses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.title))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCourseId = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Text('Dificultad: '),
                      const SizedBox(width: 8),
                      ...['Todos', 'Inicial', 'Intermedio', 'Avanzado'].map((diff) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: ChoiceChip(
                            label: Text(diff),
                            selected: _difficultyFilter == diff,
                            onSelected: (val) {
                              if (val) setState(() => _difficultyFilter = diff);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Lista Jerárquica
          Text(
            'Estructura Curricular (${filteredMissions.length} Misiones encontradas)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),

          if (filteredMissions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No hay resultados con los filtros aplicados.'),
              ),
            )
          else
            ...filteredMissions.map((mission) {
              // Buscar labs y proyectos vinculados
              final matchedLabs = allLabs.where((l) => mission.concepts.contains(l.category)).toList();
              final hasProject = mission.projectAssociated != null;

              return Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.explore_outlined),
                  title: Text(mission.title),
                  subtitle: Text('Dificultad: ${mission.difficulty} · Duración: ${mission.durationMinutes} min'),
                  childrenPadding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Objetivo: ${mission.objective}', style: const TextStyle(height: 1.3)),
                          const SizedBox(height: AppSpacing.sm),
                          const Text('Conceptos Desarrollados:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 4,
                            children: mission.concepts.map((c) => Chip(label: Text(c))).toList(),
                          ),
                          if (matchedLabs.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            const Text('Laboratorios Prácticos Vínculados:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...matchedLabs.map((l) => Text('• ${l.title} (${l.why})', style: const TextStyle(fontSize: 13, height: 1.3))),
                          ],
                          if (hasProject) ...[
                            const SizedBox(height: AppSpacing.sm),
                            const Text('Proyecto Final del Módulo:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                            Text('• Requiere entregar proyecto: ${mission.projectAssociated}', style: const TextStyle(fontSize: 13)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
