import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  String _searchQuery = '';
  String _selectedDifficulty = 'Todos';

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(professionalRepositoryProvider);
    final state = ref.watch(professionalStateProvider);

    final difficulties = ['Todos', 'Inicial', 'Intermedio', 'Avanzado'];

    final filteredChallenges = repo.challenges.where((c) {
      final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesDifficulty = _selectedDifficulty == 'Todos' || c.difficulty == _selectedDifficulty;

      return matchesSearch && matchesDifficulty;
    }).toList();

    return OraculoScaffold(
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar desafíos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: difficulties.length,
                    itemBuilder: (context, idx) {
                      final diff = difficulties[idx];
                      final isSelected = diff == _selectedDifficulty;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(diff),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              _selectedDifficulty = diff;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Lista de Desafíos
          Expanded(
            child: filteredChallenges.isEmpty
                ? const Center(child: Text('No se encontraron desafíos.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: filteredChallenges.length,
                    itemBuilder: (context, idx) {
                      final item = filteredChallenges[idx];
                      final isCompleted = state.completedChallengeIds.contains(item.id);
                      final diffColor = item.difficulty == 'Avanzado'
                          ? Colors.purple
                          : item.difficulty == 'Intermedio'
                              ? Colors.orange
                              : Colors.green;

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: diffColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.difficulty,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: diffColor),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              if (isCompleted)
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.description, style: const TextStyle(fontSize: 13)),
                                  const SizedBox(height: AppSpacing.md),

                                  const Text('Restricciones de Salida:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  ...item.constraints.map((c) => Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                                        child: Text('• $c', style: const TextStyle(fontSize: 12)),
                                      )),
                                  const SizedBox(height: AppSpacing.md),

                                  const Text('Pasos de Verificación:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  ...item.verificationSteps.map((s) => Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                                        child: Text('• $s', style: const TextStyle(fontSize: 12)),
                                      )),
                                  const SizedBox(height: AppSpacing.md),

                                  CheckboxListTile(
                                    title: const Text('He resuelto este desafío localmente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    value: isCompleted,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    dense: true,
                                    onChanged: isCompleted
                                        ? null
                                        : (val) async {
                                            if (val == true) {
                                              await ref.read(professionalStateProvider.notifier).completeChallenge(item.id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('¡Desafío marcado como resuelto!')),
                                                );
                                              }
                                            }
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
