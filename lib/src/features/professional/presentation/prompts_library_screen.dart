import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class PromptsLibraryScreen extends ConsumerStatefulWidget {
  const PromptsLibraryScreen({super.key});

  @override
  ConsumerState<PromptsLibraryScreen> createState() => _PromptsLibraryScreenState();
}

class _PromptsLibraryScreenState extends ConsumerState<PromptsLibraryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(professionalRepositoryProvider);
    final state = ref.watch(professionalStateProvider);

    // Filtrar prompts
    final filteredPrompts = repo.prompts.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.objective.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.example.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'Todos' || p.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    // Obtener categorías únicas
    final categories = ['Todos', ...repo.prompts.map((p) => p.category).toSet().toList()];

    return OraculoScaffold(
      body: Column(
        children: [
          // Barra de Búsqueda y Filtros
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar en biblioteca...',
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
                    itemCount: categories.length,
                    itemBuilder: (context, idx) {
                      final cat = categories[idx];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              _selectedCategory = cat;
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

          // Lista de Prompts
          Expanded(
            child: filteredPrompts.isEmpty
                ? const Center(child: Text('No se encontraron prompts.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: filteredPrompts.length,
                    itemBuilder: (context, idx) {
                      final prompt = filteredPrompts[idx];
                      final isCopied = state.copiedPromptIds.contains(prompt.id);
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  prompt.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  prompt.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            prompt.objective,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildDetailSection('Cuándo usarlo', prompt.whenToUse),
                                  _buildDetailSection('Cómo adaptarlo', prompt.howToAdapt),
                                  _buildDetailSection('Errores frecuentes', prompt.commonMistakes),
                                  _buildDetailSection('Ejemplo práctico', prompt.example),
                                  _buildDetailSection('Resultado esperado', prompt.expectedResult),
                                  const SizedBox(height: AppSpacing.sm),
                                  FilledButton.icon(
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(text: prompt.example));
                                      await ref.read(professionalStateProvider.notifier).copyPrompt(prompt.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Prompt copiado al portapapeles.')),
                                        );
                                      }
                                    },
                                    icon: Icon(isCopied ? Icons.check : Icons.copy),
                                    label: Text(isCopied ? 'Copiar de nuevo' : 'Copiar Prompt'),
                                  ),
                                ],
                              ),
                            )
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

  Widget _buildDetailSection(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
