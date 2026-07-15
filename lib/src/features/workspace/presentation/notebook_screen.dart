import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';

class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key});

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  WorkspaceNote? _activeNote;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Timer? _autoSaveTimer;
  bool _isPreviewMode = false;

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _saveCurrentNote();
    });
  }

  void _saveCurrentNote() {
    if (_activeNote == null) return;
    final title = _titleController.text.trim();
    final body = _bodyController.text;

    if (title.isEmpty && body.isEmpty) return;

    final updated = _activeNote!.copyWith(
      title: title.isEmpty ? 'Nota sin título' : title,
      body: body,
      updatedAt: DateTime.now(),
    );

    ref.read(workspaceStateProvider.notifier).saveNote(updated);
  }

  void _openNote(WorkspaceNote note) {
    setState(() {
      _activeNote = note;
      _titleController.text = note.title;
      _bodyController.text = note.body;
      _isPreviewMode = false;
    });
    _startAutoSave();
  }

  void _createNewNote() {
    final note = WorkspaceNote(
      id: 'note-${DateTime.now().millisecondsSinceEpoch}',
      title: '',
      body: '',
      tags: [],
      updatedAt: DateTime.now(),
    );
    _openNote(note);
  }

  void _insertMarkdown(String prefix, String suffix) {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    
    int start = selection.start;
    int end = selection.end;

    if (start < 0 || end < 0) {
      start = text.length;
      end = text.length;
    }

    final selectedText = text.substring(start, end);
    final replacement = '$prefix$selectedText$suffix';

    final nextText = text.replaceRange(start, end, replacement);
    _bodyController.text = nextText;
    _bodyController.selection = TextSelection.collapsed(offset: start + prefix.length + selectedText.length);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceStateProvider);

    if (_activeNote != null) {
      return _buildEditorView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook Markdown'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: state.notes.isEmpty
          ? const Center(child: Text('No tienes notas aún. ¡Crea una!'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.notes.length,
              itemBuilder: (context, idx) {
                final note = state.notes[idx];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.edit_note_rounded, color: Colors.blue),
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Actualizado: ${note.updatedAt.toString().substring(0, 16)}', style: const TextStyle(fontSize: 11)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        ref.read(workspaceStateProvider.notifier).deleteNote(note.id);
                      },
                    ),
                    onTap: () => _openNote(note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewNote,
        backgroundColor: const Color(0xFF1E3C72),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEditorView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nota'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _autoSaveTimer?.cancel();
            _saveCurrentNote();
            setState(() {
              _activeNote = null;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isPreviewMode ? Icons.edit : Icons.remove_red_eye),
            tooltip: _isPreviewMode ? 'Modo Editor' : 'Modo Vista Previa',
            onPressed: () {
              _saveCurrentNote();
              setState(() {
                _isPreviewMode = !_isPreviewMode;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Herramientas de Formato Markdown (solo en modo edición)
          if (!_isPreviewMode)
            Container(
              color: Colors.grey.withOpacity(0.15),
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  IconButton(
                    icon: const Icon(Icons.title, size: 20),
                    tooltip: 'Título H1',
                    onPressed: () => _insertMarkdown('# ', ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_bold, size: 20),
                    tooltip: 'Negrita',
                    onPressed: () => _insertMarkdown('**', '**'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted, size: 20),
                    tooltip: 'Lista',
                    onPressed: () => _insertMarkdown('- ', ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.code, size: 20),
                    tooltip: 'Código',
                    onPressed: () => _insertMarkdown('```dart\n', '\n```'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_add_check_rounded, size: 20),
                    tooltip: 'Checklist',
                    onPressed: () => _insertMarkdown('- [ ] ', ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_quote_rounded, size: 20),
                    tooltip: 'Cita',
                    onPressed: () => _insertMarkdown('> ', ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.table_chart_rounded, size: 20),
                    tooltip: 'Tabla',
                    onPressed: () => _insertMarkdown('| Columna 1 | Columna 2 |\n|---|---|\n| celda | celda |\n', ''),
                  ),
                ],
              ),
            ),

          // Área Principal (Edición o Vista Previa)
          Expanded(
            child: _isPreviewMode
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _titleController.text.isEmpty ? 'Nota sin título' : _titleController.text,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          // Simple render del markdown para evitar dependencias
                          Text(
                            _bodyController.text.isEmpty ? '*Nota vacía*' : _bodyController.text,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Título de la nota...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Expanded(
                          child: TextField(
                            controller: _bodyController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Escribe contenido en Markdown aquí...',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
