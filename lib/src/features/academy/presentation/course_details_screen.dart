import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({required this.courseId, super.key});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final ke = KnowledgeEngine.instance;
    
    // Buscar curso por id
    final course = ke.academyCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => ke.academyCourses.first,
    );

    // Misiones asociadas a este curso
    final courseMissions = ke.academyMissions.where(
      (m) => course.missionIds.contains(m.id),
    ).toList();

    // Simular métricas locales del curso
    final isIntro = course.id == 'fundamentos';
    final hoursStudied = isIntro ? 1.5 : 0.0;
    final conceptsMasteredCount = isIntro ? 3 : 0;
    final conceptsPendingCount = course.concepts.length - conceptsMasteredCount;
    final completedLabs = isIntro ? 2 : 0;

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
              Expanded(
                child: Text(
                  course.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Categoría, dificultad y tiempo total
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(label: Text(course.category)),
              Chip(label: Text(course.difficulty)),
              Chip(label: Text('${course.durationMinutes} min estimaciones')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Descripción general
          Text(
            course.description,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),

          // MÓDULO 5 — PESTAÑA PROGRESO POR CURSO
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tu Progreso del Curso',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('Tiempo invertido', '${hoursStudied}h'),
                      _buildStatColumn('Conceptos dominados', '$conceptsMasteredCount'),
                      _buildStatColumn('Conceptos pendientes', '$conceptsPendingCount'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('Labs realizados', '$completedLabs'),
                      _buildStatColumn('Proyecto final', 'Pendiente'),
                      _buildStatColumn('Nivel alcanzado', isIntro ? 'Comprendido' : 'No iniciado'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // MÓDULO 4 — PROGRAMA Y LISTA DE MISIONES
          Text(
            'Programa del Curso (${courseMissions.length} Misiones)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...courseMissions.map((mission) {
            final isMissionUnlocked = mission.id == 'ac-001' || isIntro;
            return Card(
              child: ListTile(
                leading: Icon(
                  isMissionUnlocked ? Icons.play_circle_outline : Icons.lock_outline,
                  color: isMissionUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                title: Text(mission.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.objective, style: const TextStyle(fontSize: 13, height: 1.3)),
                    const SizedBox(height: 4),
                    Text(
                      'Duración: ${mission.durationMinutes} min · Dificultad: ${mission.difficulty}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    if (mission.prerequisiteIds.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Requisitos: ${mission.prerequisiteIds.join(", ")}',
                        style: const TextStyle(color: Colors.blueGrey, fontSize: 10),
                      ),
                    ],
                    if (mission.projectAssociated != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Proyecto Final: ${mission.projectAssociated}',
                        style: const TextStyle(color: Colors.deepPurple, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
                isThreeLine: true,
                onTap: isMissionUnlocked
                    ? () {
                        // Enlazar al visualizador de misiones
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Abriendo simulación didáctica de "${mission.title}"')),
                        );
                      }
                    : null,
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),

          // Conceptos que desarrolla
          Text(
            'Conceptos Clave del Curso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: course.concepts.map((concept) {
              return Chip(
                avatar: const Icon(Icons.check, size: 14, color: Colors.green),
                label: Text(concept),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Recursos relacionados (Manual y Glosario)
          Text(
            'Material Offline Relacionado',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text('Artículos del Manual'),
                  subtitle: const Text('Guías de Prompting y Reducción de Alucinaciones'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => context.push('/review'), // Enlaza a repaso manual
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.book_outlined),
                  title: const Text('Diccionario Técnico'),
                  subtitle: const Text('Términos explicados con analogías cotidianas'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => context.push('/review'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}
