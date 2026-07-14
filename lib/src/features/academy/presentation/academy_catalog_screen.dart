import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/academy/domain/academy_models.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

class AcademyCatalogScreen extends StatefulWidget {
  const AcademyCatalogScreen({super.key});

  @override
  State<AcademyCatalogScreen> createState() => _AcademyCatalogScreenState();
}

class _AcademyCatalogScreenState extends State<AcademyCatalogScreen> {
  final _ke = KnowledgeEngine.instance;
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final courses = _ke.academyCourses;
    final categories = ['Todos', ...courses.map((c) => c.category).toSet()];

    final filteredCourses = _selectedCategory == 'Todos'
        ? courses
        : courses.where((c) => c.category == _selectedCategory).toList();

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Cabecera con buscador e historial
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catálogo Academia IA',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('Explorá nuestras rutas de aprendizaje offline', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Buscar en Academia',
                    icon: const Icon(Icons.search),
                    onPressed: () => context.push('/global-search'),
                  ),
                  IconButton(
                    tooltip: 'Explorador del Conocimiento',
                    icon: const Icon(Icons.hub_outlined),
                    onPressed: () => context.push('/knowledge-explorer'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Chips de categorías (Filtros)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Lista de Cursos
          if (filteredCourses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No hay cursos en esta categoría.'),
              ),
            )
          else
            ...filteredCourses.map((course) {
              return _buildCourseCard(context, course);
            }),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, AcademyCourse course) {
    // Simular progreso local: primer curso 40% completado, otros 0%
    final progress = course.id == 'fundamentos' ? 0.40 : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/course-details/${course.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    course.difficulty,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                course.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                course.description,
                style: const TextStyle(color: Colors.grey, height: 1.3),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${course.durationMinutes} min', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(Icons.class_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${course.missionIds.length} misiones', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  if (progress > 0)
                    Text(
                      '${(progress * 100).round()}% completado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    )
                  else
                    const Text('No iniciado', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              if (progress > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: progress,
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
