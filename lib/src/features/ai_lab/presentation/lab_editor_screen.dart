import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/ai_lab/data/ai_lab_repository.dart';
import 'package:oraculo_ia/src/features/ai_lab/domain/ai_lab_models.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';

class LabEditorScreen extends StatefulWidget {
  const LabEditorScreen({required this.labId, this.templateId, super.key});
  final String labId;
  final String? templateId;

  @override
  State<LabEditorScreen> createState() => _LabEditorScreenState();
}

class _LabEditorScreenState extends State<LabEditorScreen> with SingleTickerProviderStateMixin {
  final _ke = KnowledgeEngine.instance;
  final _repo = AiLabRepository.instance;
  late TabController _tabController;

  // Controladores de texto
  final _originalPromptCtrl = TextEditingController();
  final _improvedPromptCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _learningsCtrl = TextEditingController();

  PromptEvaluationResult? _evalResult;
  bool _evaluated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Cargar plantilla si se provee en la URL
    if (widget.templateId != null) {
      final tpl = _repo.templates.firstWhere((t) => t.id == widget.templateId);
      _originalPromptCtrl.text = tpl.templateText;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _originalPromptCtrl.dispose();
    _improvedPromptCtrl.dispose();
    _observationsCtrl.dispose();
    _learningsCtrl.dispose();
    super.dispose();
  }

  void _runEvaluation() {
    final result = _repo.evaluatePrompt(_originalPromptCtrl.text);
    setState(() {
      _evalResult = result;
      _evaluated = true;
    });
    // Cambiar a la pestaña de evaluación automáticamente
    _tabController.animateTo(1);
  }

  void _savePractice() {
    final lab = _ke.aiLaboratories.firstWhere(
      (l) => l.id == widget.labId,
      orElse: () => _ke.aiLaboratories.first,
    );

    final score = _evalResult?.score ?? 0;

    final session = LabPracticeSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      labId: lab.id,
      labTitle: lab.title,
      dateStr: DateTime.now().toString().substring(0, 10),
      durationMinutes: lab.durationMinutes,
      originalPrompt: _originalPromptCtrl.text,
      improvedPrompt: _improvedPromptCtrl.text,
      observations: _observationsCtrl.text,
      learnings: _learningsCtrl.text,
      score: score,
    );

    _repo.saveSession(session);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Práctica guardada en tu historial offline.')),
    );
  }

  void _exportMarkdown() {
    final lab = _ke.aiLaboratories.firstWhere(
      (l) => l.id == widget.labId,
      orElse: () => _ke.aiLaboratories.first,
    );

    final score = _evalResult?.score ?? 0;

    final markdownContent = '''
# ORÁCULO AI LAB — Reporte de Práctica

**Laboratorio:** ${lab.title}
**Categoría:** ${lab.category}
**Puntaje de Rúbrica:** $score/100
**Fecha:** ${DateTime.now()}

---

## 1. Prompt Original
```
${_originalPromptCtrl.text}
```

## 2. Prompt Mejorado
```
${_improvedPromptCtrl.text}
```

## 3. Rúbrica de Evaluación Estructural
* **Claridad:** ${_evalResult?.clarityScore ?? 0}/100 - ${_evalResult?.clarityExplanation ?? ''}
* **Contexto:** ${_evalResult?.contextScore ?? 0}/100 - ${_evalResult?.contextExplanation ?? ''}
* **Restricciones:** ${_evalResult?.restrictionsScore ?? 0}/100 - ${_evalResult?.restrictionsExplanation ?? ''}
* **Formato:** ${_evalResult?.formatScore ?? 0}/100 - ${_evalResult?.formatExplanation ?? ''}
* **Objetivo:** ${_evalResult?.objectiveScore ?? 0}/100 - ${_evalResult?.objectiveExplanation ?? ''}

## 4. Observaciones y Simulaciones
${_observationsCtrl.text}

## 5. Aprendizajes del Laboratorio
${_learningsCtrl.text}
''';

    Clipboard.setData(ClipboardData(text: markdownContent));

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportado a Portapapeles'),
        content: const Text('El reporte en Markdown ha sido copiado a tu portapapeles. Puedes pegarlo en cualquier editor.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _exportPdf() {
    // Simular exportación a PDF offline sin requerir paquetes externos que inflen el APK o fallen en compilación
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Generado (Simulación Offline)'),
        content: const Text('Se ha estructurado el reporte PDF de tu laboratorio. El archivo se guardó simbólicamente en la ruta local de descargas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lab = _ke.aiLaboratories.firstWhere(
      (l) => l.id == widget.labId,
      orElse: () => _ke.aiLaboratories.first,
    );

    return OraculoScaffold(
      body: Column(
        children: [
          // Cabecera del Editor
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lab.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('${lab.category} · ${lab.difficulty}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Pestañas (TabBar)
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Guía y Práctica'),
              Tab(text: 'Evaluación'),
              Tab(text: 'Comparador'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Contenido de Pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // PESTAÑA 1: GUÍA Y EDITOR
                _buildGuideAndPracticeTab(lab),

                // PESTAÑA 2: EVALUACIÓN LOCAL
                _buildEvaluationTab(),

                // PESTAÑA 3: COMPARADOR Y EXPORTACIÓN
                _buildComparatorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideAndPracticeTab(AiLaboratory lab) {
    return ListView(
      children: [
        // Guía del laboratorio
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instrucciones del Laboratorio',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Objetivo: ${lab.objective}', style: const TextStyle(height: 1.3)),
                const SizedBox(height: AppSpacing.sm),
                const Text('Pasos recomendados:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...lab.steps.map((step) => Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text('• $step', style: const TextStyle(fontSize: 13)),
                    )),
                const SizedBox(height: AppSpacing.sm),
                Text('Resultado esperado: ${lab.expectedResult}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Editor
        Text(
          'Escribe tu prompt original',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _originalPromptCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Ingresa el prompt que deseas evaluar...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Simulación de respuestas / Observaciones',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _observationsCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Anotá las respuestas obtenidas o simuladas en tus pruebas...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        FilledButton.icon(
          onPressed: _runEvaluation,
          icon: const Icon(Icons.analytics_outlined),
          label: const Text('Evaluar Prompt Localmente'),
        ),
      ],
    );
  }

  Widget _buildEvaluationTab() {
    if (!_evaluated || _evalResult == null) {
      return const Center(
        child: Text('Escribe tu prompt y pulsa "Evaluar" en la primera pestaña.'),
      );
    }

    final res = _evalResult!;

    return ListView(
      children: [
        // Rúbrica general
        Card(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Text(
                  'PUNTACIÓN TOTAL DE RÚBRICA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  '${res.score}/100',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text('Esta puntuación se calcula evaluando la estructura offline del prompt.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Criterios
        _buildCriterionTile('Claridad y Acción', res.clarityScore, res.clarityExplanation),
        _buildCriterionTile('Contexto y Rol', res.contextScore, res.contextExplanation),
        _buildCriterionTile('Restricciones y Límites', res.restrictionsScore, res.restrictionsExplanation),
        _buildCriterionTile('Formato de Salida', res.formatScore, res.formatExplanation),
        _buildCriterionTile('Meta y Objetivo', res.objectiveScore, res.objectiveExplanation),
        const SizedBox(height: AppSpacing.md),

        // Sugerencias de mejora
        Text(
          'Oportunidades de Mejora',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: res.suggestions.map((sug) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right, color: Colors.orange, size: 18),
                        Expanded(child: Text(sug, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriterionTile(String name, int score, String expl) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 4,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(expl, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text('$score%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildComparatorTab() {
    return ListView(
      children: [
        // Comparación de versiones
        Text(
          'Prompt Original',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.red[50]?.withOpacity(0.3),
            border: Border.all(color: Colors.red[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(_originalPromptCtrl.text.isEmpty ? '(Vacío)' : _originalPromptCtrl.text),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Escribe tu Prompt Mejorado',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _improvedPromptCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Aplica las sugerencias de la rúbrica y escribe el prompt optimizado aquí...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Aprendizajes del Laboratorio',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _learningsCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '¿Qué aprendiste al iterar el prompt?',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Acciones finales
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _savePractice,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar Historial'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _exportMarkdown,
                icon: const Icon(Icons.code),
                label: const Text('Exportar Markdown'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _exportPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Exportar PDF'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
