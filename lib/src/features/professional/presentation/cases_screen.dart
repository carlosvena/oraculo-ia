import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class CasesScreen extends ConsumerStatefulWidget {
  const CasesScreen({super.key});

  @override
  ConsumerState<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends ConsumerState<CasesScreen> {
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(professionalRepositoryProvider);
    final state = ref.watch(professionalStateProvider);

    // Obtener categorías únicas
    final categoriesMap = <String, String>{'Todos': 'Todos'};
    for (final c in repo.cases) {
      categoriesMap[c.category] = c.categoryName;
    }

    final filteredCases = repo.cases.where((c) {
      return _selectedCategory == 'Todos' || c.category == _selectedCategory;
    }).toList();

    return OraculoScaffold(
      body: Column(
        children: [
          // Selector de Categoría
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesMap.length,
                itemBuilder: (context, idx) {
                  final catId = categoriesMap.keys.elementAt(idx);
                  final catName = categoriesMap.values.elementAt(idx);
                  final isSelected = catId == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(catName),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = catId;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Lista de Casos
          Expanded(
            child: filteredCases.isEmpty
                ? const Center(child: Text('No hay casos registrados.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: filteredCases.length,
                    itemBuilder: (context, idx) {
                      final item = filteredCases[idx];
                      final isCompleted = state.completedCaseIds.contains(item.id);
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.categoryName,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                                    ),
                                  ),
                                  if (isCompleted)
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                                        SizedBox(width: 4),
                                        Text('Completado', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              
                              const Text('Pasos de la Solución:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 4),
                              ...item.steps.map((step) => Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(child: Text(step, style: const TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: AppSpacing.md),

                              const Text('Prompt de Referencia:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.promptExample,
                                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              const Text('Resultado Esperado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 2),
                              Text(item.expectedResult, style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: AppSpacing.md),

                              // Botón de completado
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: isCompleted
                                      ? null
                                      : () async {
                                          await ref.read(professionalStateProvider.notifier).completeCase(item.id);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('¡Caso marcado como completado!')),
                                            );
                                          }
                                        },
                                  icon: Icon(isCompleted ? Icons.check : Icons.check_circle_outline),
                                  label: Text(isCompleted ? 'Resuelto' : 'Marcar como Resuelto'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
