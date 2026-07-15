import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  bool _isCreating = false;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'IA';
  String _filterCategory = 'Todos';

  final _categories = ['IA', 'Trabajo', 'Banco', 'Excel', 'Programación', 'Personal'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveDocument() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) return;

    final doc = WorkspaceDocument(
      id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      category: _selectedCategory,
      createdAt: DateTime.now(),
    );

    ref.read(workspaceStateProvider.notifier).saveDocument(doc);
    _titleController.clear();
    _contentController.clear();

    setState(() {
      _isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceStateProvider);

    final filteredDocs = state.documents.where((d) {
      return _filterCategory == 'Todos' || d.category == _filterCategory;
    }).toList();

    if (_isCreating) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo Documento'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _isCreating = false),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título del documento', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCategory = val;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration(labelText: 'Contenido del documento', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saveDocument,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Documento'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Documentos'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Selector de filtro
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Todos', ..._categories].map((cat) {
                final isSelected = cat == _filterCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _filterCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Lista de documentos
          Expanded(
            child: filteredDocs.isEmpty
                ? const Center(child: Text('No hay documentos guardados.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, idx) {
                      final doc = filteredDocs[idx];
                      return Card(
                        child: ExpansionTile(
                          leading: const Icon(Icons.folder_shared_outlined, color: Colors.orange),
                          title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Categoría: ${doc.category} | ${doc.createdAt.toString().substring(0, 10)}', style: const TextStyle(fontSize: 11)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                doc.content,
                                style: const TextStyle(fontSize: 13, height: 1.4),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _isCreating = true),
        backgroundColor: const Color(0xFF1E3C72),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
