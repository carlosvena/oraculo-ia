import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';
import 'package:oraculo_ia/src/features/workspace/domain/workspace_models.dart';

class ExperimentsScreen extends ConsumerStatefulWidget {
  const ExperimentsScreen({super.key});

  @override
  ConsumerState<ExperimentsScreen> createState() => _ExperimentsScreenState();
}

class _ExperimentsScreenState extends ConsumerState<ExperimentsScreen> {
  bool _isCreating = false;
  final _objectiveController = TextEditingController();
  final _hypothesisController = TextEditingController();
  final _promptController = TextEditingController();
  final _resultController = TextEditingController();
  final _learningController = TextEditingController();
  final _improvementsController = TextEditingController();

  @override
  void dispose() {
    _objectiveController.dispose();
    _hypothesisController.dispose();
    _promptController.dispose();
    _resultController.dispose();
    _learningController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  void _saveExperiment() {
    final obj = _objectiveController.text.trim();
    final hyp = _hypothesisController.text.trim();
    if (obj.isEmpty || hyp.isEmpty) return;

    final exp = WorkspaceExperiment(
      id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
      objective: obj,
      hypothesis: hyp,
      promptText: _promptController.text,
      result: _resultController.text,
      learning: _learningController.text,
      nextSteps: _improvementsController.text,
      createdAt: DateTime.now(),
    );

    ref.read(workspaceStateProvider.notifier).saveExperiment(exp);
    
    // Limpiar y volver
    _objectiveController.clear();
    _hypothesisController.clear();
    _promptController.clear();
    _resultController.clear();
    _learningController.clear();
    _improvementsController.clear();

    setState(() {
      _isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceStateProvider);

    if (_isCreating) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo Experimento'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _isCreating = false),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _objectiveController,
              decoration: const InputDecoration(labelText: 'Objetivo de la prueba', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hypothesisController,
              decoration: const InputDecoration(labelText: 'Hipótesis', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Prompt utilizado', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _resultController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Resultado obtenido', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _learningController,
              decoration: const InputDecoration(labelText: 'Aprendizaje obtenido', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _improvementsController,
              decoration: const InputDecoration(labelText: 'Mejoras futuras y próximos pasos', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saveExperiment,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Experimento'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Experimentos'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: state.experiments.isEmpty
          ? const Center(child: Text('Aún no has registrado experimentos.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.experiments.length,
              itemBuilder: (context, idx) {
                final e = state.experiments[idx];
                return Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.biotech_rounded, color: Colors.green),
                    title: Text(e.objective, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Fecha: ${e.createdAt.toString().substring(0, 10)}', style: const TextStyle(fontSize: 11)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hipótesis: ${e.hypothesis}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Prompt de Prueba:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(e.promptText, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                            ),
                            const SizedBox(height: 8),
                            Text('Resultado: ${e.result}'),
                            const SizedBox(height: 4),
                            Text('Aprendizaje: ${e.learning}', style: const TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _isCreating = true),
        backgroundColor: const Color(0xFF1E3C72),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
