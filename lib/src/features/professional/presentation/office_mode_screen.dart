import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/learning_graph.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class OfficeModeScreen extends ConsumerWidget {
  const OfficeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(professionalStateProvider);
    final learning = LearningEngine.instance;

    // Calcular estadísticas
    final promptsCount = state.copiedPromptIds.length;
    final casesCount = state.completedCaseIds.length;
    final challengesCount = state.completedChallengeIds.length;
    
    final simScores = state.simulatorScores.values.toList();
    final avgSimScore = simScores.isEmpty 
        ? 0 
        : (simScores.fold<int>(0, (a, b) => a + b) / simScores.length).round();

    // Stats de lecciones y proyectos del motor de aprendizaje
    final activeProjects = learning.nodes.values
        .where((n) => n.type == KnowledgeNodeType.project)
        .length;
    final activeLabs = learning.nodes.values
        .where((n) => n.type == KnowledgeNodeType.laboratory)
        .length;

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        children: [
          // Banner de Cabecera Premium
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E3C72),
                  const Color(0xFF2A5298),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.work_outline_rounded, size: 40, color: Colors.white),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'MODO OFICINA',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Tu espacio de trabajo y herramientas profesionales offline.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Sección de Estadísticas de Trabajo
          Text(
            'Desempeño Profesional',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(context, 'Prompts Usados', '$promptsCount', Icons.copy_rounded, Colors.orange),
                  _buildStatCard(context, 'Casos Resueltos', '$casesCount / 16', Icons.check_circle_outline, Colors.green),
                  _buildStatCard(context, 'Simulador (Avg)', '$avgSimScore%', Icons.analytics_outlined, Colors.blue),
                  _buildStatCard(context, 'Desafíos Listos', '$challengesCount / 210', Icons.extension_outlined, Colors.purple),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Grid de Accesos Rápidos
          Text(
            'Herramientas y Recursos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildAccessCard(context, 'Biblioteca Prompts', '300+ plantillas de prompts', Icons.library_books_rounded, () => context.push('/office-mode/prompts')),
              _buildAccessCard(context, 'Casos Reales', 'Casos prácticos por sector', Icons.business_center_rounded, () => context.push('/office-mode/cases')),
              _buildAccessCard(context, 'Simuladores', 'Ejercicios de toma de decisión', Icons.model_training_rounded, () => context.push('/office-mode/simulators')),
              _buildAccessCard(context, 'Desafíos Prácticos', '210 problemas clasificados', Icons.emoji_events_rounded, () => context.push('/office-mode/challenges')),
              _buildAccessCard(context, 'Plantillas Corporativas', 'Actas, minutas e informes', Icons.description_rounded, () => context.push('/office-mode/templates')),
              _buildAccessCard(context, 'Centro de Recursos', 'Guías y buenas prácticas', Icons.menu_book_rounded, () => context.push('/office-mode/resources')),
              _buildAccessCard(context, 'Métricas Internas', 'Estadísticas y LOC del sistema', Icons.insights_rounded, () => context.push('/office-mode/metrics')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Accesos rápidos a la Academia tradicional
          Text(
            'Accesos Rápidos Academia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/projects'),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(Icons.architecture_rounded, color: Colors.blue),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Proyectos ($activeProjects)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/ai-lab'),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(Icons.science_outlined, color: Colors.green),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Laboratorios ($activeLabs)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/manual'),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(Icons.book_rounded, color: Colors.orange),
                          const SizedBox(height: AppSpacing.xs),
                          const Text('Manual', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/dictionary'),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(Icons.abc_rounded, color: Colors.purple),
                          const SizedBox(height: AppSpacing.xs),
                          const Text('Glosario', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
