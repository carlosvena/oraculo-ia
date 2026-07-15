import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';

class PromptVaultScreen extends ConsumerStatefulWidget {
  const PromptVaultScreen({super.key});

  @override
  ConsumerState<PromptVaultScreen> createState() => _PromptVaultScreenState();
}

class _PromptVaultScreenState extends ConsumerState<PromptVaultScreen> {
  WorkspacePrompt? _activePrompt;
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _tagsController = TextEditingController();
  String? _relatedConcept;

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _openPromptForm(WorkspacePrompt? prompt) {
    setState(() {
      _activePrompt = prompt;
      if (prompt != null) {
        _titleController.text = prompt.title;
        _textController.text = prompt.promptText;
        _tagsController.text = prompt.tags.join(', ');
        _relatedConcept = prompt.relatedConcepts.isNotEmpty ? prompt.relatedConcepts.first : null;
      } else {
        _titleController.clear();
        _textController.clear();
        _tagsController.clear();
        _relatedConcept = null;
      }
    });
  }

  void _savePrompt() {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();
    if (title.isEmpty || text.isEmpty) return;

    final tags = _tagsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final isNew = _activePrompt == null;
    final version = isNew ? 1 : (_activePrompt!.version + 1);
    final id = isNew ? 'prompt-${DateTime.now().millisecondsSinceEpoch}' : _activePrompt!.id;

    final updated = WorkspacePrompt(
      id: id,
      title: title,
      promptText: text,
      tags: tags,
      version: version,
      isFavorite: _activePrompt?.isFavorite ?? false,
      relatedConcepts: _relatedConcept != null ? [_relatedConcept!] : [],
      updatedAt: DateTime.now(),
    );

    ref.read(workspaceStateProvider.notifier).savePrompt(updated);
    setState(() {
      _activePrompt = null;
    });
  }

  void _duplicatePrompt(WorkspacePrompt p) {
    final copy = WorkspacePrompt(
      id: 'prompt-${DateTime.now().millisecondsSinceEpoch}',
      title: '${p.title} (Copia)',
      promptText: p.promptText,
      tags: p.tags,
      version: 1,
      isFavorite: p.isFavorite,
      relatedConcepts: p.relatedConcepts,
      updatedAt: DateTime.now(),
    );
    ref.read(workspaceStateProvider.notifier).savePrompt(copy);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceStateProvider);
    final ke = KnowledgeEngine.instance;

    // Obtener lista de conceptos/cursos/labs del grafo para vincular
    final conceptsList = ke.articles.map((a) => a.title).toList();

    if (_activePrompt != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_activePrompt!.title.isEmpty ? 'Nuevo Prompt' : 'Editar Prompt'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _activePrompt = null),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título del Prompt',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Estructura o Contenido del Prompt',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Etiquetas (separadas por comas)',
                hintText: 'Excel, Análisis, Trabajo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            
            // Selector de Relación
            const Text('Vincular con Concepto o Capítulo del Manual:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _relatedConcept,
              items: conceptsList.map((c) => DropdownMenuItem(
                value: c,
                child: Text(c, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
              )).toList(),
              onChanged: (val) {
                setState(() {
                  _relatedConcept = val;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _savePrompt,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Guardar en Vault'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Vault'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: state.prompts.isEmpty
          ? const Center(child: Text('Vault vacío. Carga tus metaprompts.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.prompts.length,
              itemBuilder: (context, idx) {
                final p = state.prompts[idx];
                return Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.vpn_key_rounded, color: Colors.purple),
                    title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Versión: v${p.version} | Modificado: ${p.updatedAt.toString().substring(0, 10)}', style: const TextStyle(fontSize: 11)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(p.promptText, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                            ),
                            if (p.relatedConcepts.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Vinculado a: ${p.relatedConcepts.join(", ")}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey)),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _duplicatePrompt(p),
                                  icon: const Icon(Icons.copy_rounded, size: 16),
                                  label: const Text('Duplicar', style: TextStyle(fontSize: 11)),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => _openPromptForm(p),
                                  icon: const Icon(Icons.edit_rounded, size: 16),
                                  label: const Text('Editar', style: TextStyle(fontSize: 11)),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () {
                                    ref.read(workspaceStateProvider.notifier).deletePrompt(p.id);
                                  },
                                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                  label: const Text('Borrar', style: TextStyle(fontSize: 11, color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPromptForm(null),
        backgroundColor: const Color(0xFF1E3C72),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
