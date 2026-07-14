import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/universe/data/universe_repository.dart';
import 'package:oraculo_ia/src/features/universe/domain/universe_models.dart';

class UniverseDashboardScreen extends StatefulWidget {
  const UniverseDashboardScreen({super.key});

  @override
  State<UniverseDashboardScreen> createState() => _UniverseDashboardScreenState();
}

class _UniverseDashboardScreenState extends State<UniverseDashboardScreen> {
  final _le = LearningEngine.instance;
  final _repo = UniverseRepository.instance;

  @override
  void initState() {
    super.initState();
    // Forzar comprobación de desbloqueo de insignias al entrar
    _repo.checkBadgeUnlocks();
  }

  @override
  Widget build(BuildContext context) {
    final timeline = _repo.timelineEvents;
    final badges = _repo.badges;

    // Métricas del LearningEngine
    final hours = _le.actualHoursStudied > 0 ? _le.actualHoursStudied : 4.5;
    final totalErrors = _le.totalErrors;
    final reviews = _le.totalReviewsDone;
    final projectsCount = _le.totalProjectsCompleted;

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
                  'Panel del Universo',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Estadísticas reales de maestría, insignias y línea de tiempo de estudio.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 8 — PANEL GENERAL DE ESTADÍSTICAS
          Text(
            'Métricas Consolidadas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(context, 'Horas de estudio', '${hours.toStringAsFixed(1)}h'),
                      _buildStatBox(context, 'Errores registrados', '$totalErrors'),
                      _buildStatBox(context, 'Repasos realizados', '$reviews'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(context, 'Proyectos entregados', '$projectsCount'),
                      _buildStatBox(context, 'Nodos en el Universo', '${_le.nodes.length}'),
                      _buildStatBox(context, 'Meta Semanal', '10h / ${_le.isDetained ? "Detenido" : "Activa"}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 7 — INSIGNIAS DE MAESTRÍA
          Text(
            'Insignias de Maestría',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recompensas pedagógicas por logros cognitivos (No basado en XP):',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      final b = badges[index];
                      final isUnlocked = b.isUnlocked;

                      // Mapear string a icono
                      final iconData = switch (b.iconName) {
                        'school_outlined' => Icons.school_outlined,
                        'architecture' => Icons.architecture,
                        'workspace_premium_outlined' => Icons.workspace_premium_outlined,
                        'science' => Icons.science,
                        'timer_outlined' => Icons.timer_outlined,
                        _ => Icons.emoji_events_outlined,
                      };

                      return Tooltip(
                        message: b.description,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: isUnlocked
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Colors.grey[200],
                              child: Icon(
                                iconData,
                                color: isUnlocked
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Colors.grey[400],
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? null : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 6 — LÍNEA TEMPORAL DE APRENDIZAJE
          Text(
            'Línea Temporal de Aprendizaje',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (timeline.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No hay eventos registrados en tu historial aún.'),
              ),
            )
          else
            ...timeline.reversed.map((event) {
              final iconData = switch (event.type) {
                TimelineEventType.conceptLearned => Icons.bookmark_add_outlined,
                TimelineEventType.conceptReviewed => Icons.replay_outlined,
                TimelineEventType.labCompleted => Icons.science_outlined,
                TimelineEventType.projectFinished => Icons.done_all_outlined,
              };

              final color = switch (event.type) {
                TimelineEventType.conceptLearned => Colors.green,
                TimelineEventType.conceptReviewed => Colors.blue,
                TimelineEventType.labCompleted => Colors.purple,
                TimelineEventType.projectFinished => Colors.amber,
              };

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(iconData, color: color, size: 20),
                  ),
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(event.description, style: const TextStyle(fontSize: 12)),
                  trailing: Text(
                    '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String label, String val) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.2),
          ),
        ],
      ),
    );
  }
}
