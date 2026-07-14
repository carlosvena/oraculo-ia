import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/ai_lab/data/ai_lab_repository.dart';
import 'package:oraculo_ia/src/features/ai_lab/domain/ai_lab_models.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

class AiLabScreen extends StatefulWidget {
  const AiLabScreen({super.key});

  @override
  State<AiLabScreen> createState() => _AiLabScreenState();
}

class _AiLabScreenState extends State<AiLabScreen> {
  final _ke = KnowledgeEngine.instance;
  final _repo = AiLabRepository.instance;
  String _selectedCategory = 'Prompt Engineering';
  final Set<String> _favoriteLabIds = {};

  @override
  Widget build(BuildContext context) {
    final labs = _ke.aiLaboratories;
    final categories = [
      "Prompt Engineering", "ChatGPT", "Gemini", "Claude", "DeepSeek",
      "LLM", "Agentes", "Automatización", "Excel", "Programación",
      "Documentos", "Investigación", "Productividad"
    ];

    // Laboratorios de la categoría elegida
    final filteredLabs = labs.where((l) => l.category == _selectedCategory).toList();

    // Historial reciente
    final history = _repo.history;

    // Recomendados (primeros de la lista que no están en historial)
    final recommendedLabs = labs
        .where((l) => !history.any((h) => h.labId == l.id))
        .take(3)
        .toList();

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Cabecera AI Lab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORÁCULO AI LAB',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('Experimentación de Prompts & Rúbricas Locales', style: TextStyle(color: Colors.grey)),
                ],
              ),
              IconButton(
                tooltip: 'Atrás a la Academia',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Historial Reciente (Módulo 8)
          if (history.isNotEmpty) ...[
            Text(
              'Últimos Realizados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: history.length,
                separatorBuilder: (context, idx) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.labTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.dateStr, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Score: ${item.score}',
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Laboratorios Recomendados (Módulo 1)
          if (recommendedLabs.isNotEmpty) ...[
            Text(
              'Recomendados para ti',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...recommendedLabs.map((l) => _buildRecommendedRow(context, l)),
            const SizedBox(height: AppSpacing.md),
          ],

          // MÓDULO 6 — ACCESO RÁPIDO A PLANTILLAS DE PROMPTS
          Text(
            'Plantillas de Prompts Rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _repo.templates.length,
              separatorBuilder: (context, idx) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final t = _repo.templates[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // Cargar la plantilla directamente en el editor con un Lab ID ficticio
                      context.push('/lab-editor/lab-001?template=${t.id}');
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(t.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Categorías (Filtros del Módulo 2)
          Text(
            'Explorar por Categoría',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, idx) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSel = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSel,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Lista de laboratorios filtrados
          if (filteredLabs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No hay laboratorios en esta categoría.'),
              ),
            )
          else
            ...filteredLabs.map((lab) {
              final isFav = _favoriteLabIds.contains(lab.id);
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: const Icon(Icons.science_outlined),
                  title: Text(lab.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Dificultad: ${lab.difficulty} · Tiempo: ${lab.durationMinutes} min\nConceptos: ${lab.concepts.join(", ")}',
                    style: const TextStyle(fontSize: 11, height: 1.3),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                    onPressed: () {
                      setState(() {
                        if (isFav) {
                          _favoriteLabIds.remove(lab.id);
                        } else {
                          _favoriteLabIds.add(lab.id);
                        }
                      });
                    },
                  ),
                  onTap: () => context.push('/lab-editor/${lab.id}'),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecommendedRow(BuildContext context, AiLaboratory lab) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(Icons.star_outline, color: Theme.of(context).colorScheme.primary),
        title: Text(lab.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${lab.category} · ${lab.durationMinutes} min', style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/lab-editor/${lab.id}'),
      ),
    );
  }
}
