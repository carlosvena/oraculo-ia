import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/universe/data/universe_repository.dart';
import 'package:oraculo_ia/src/features/universe/domain/universe_models.dart';

class KnowledgeUniverseScreen extends StatefulWidget {
  const KnowledgeUniverseScreen({super.key});

  @override
  State<KnowledgeUniverseScreen> createState() => _KnowledgeUniverseScreenState();
}

class _KnowledgeUniverseScreenState extends State<KnowledgeUniverseScreen> {
  final _ke = KnowledgeEngine.instance;
  final _le = LearningEngine.instance;
  final _repo = UniverseRepository.instance;

  String _selectedConcept = 'prompt';
  final _answerCtrl = TextEditingController();
  String? _challengeFeedback;

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  void _verifyChallenge(String key) {
    final ans = _answerCtrl.text.trim().toLowerCase();
    setState(() {
      if (ans.contains(key.toLowerCase())) {
        _challengeFeedback = '¡Correcto! Completaste el desafío del día offline.';
        _repo.recordEvent(
          TimelineEventType.conceptReviewed,
          'Desafío del Día Completado',
          'Aprobaste el reto de ${_repo.getDailyChallenge().title}.',
        );
      } else {
        _challengeFeedback = 'Incorrecto. Intenta de nuevo. Pista: la respuesta empieza con "${key.substring(0, 1)}".';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_le.nodes.isEmpty) {
      _le.initializeGraph();
    }

    final dailyConcept = _repo.getDailyConcept();
    final dailyChallenge = _repo.getDailyChallenge();

    // MÓDULO 3 — SECUENCIA DE EXPLORACIÓN SUGERIDA
    final sequentialPath = ['LLM', 'Transformer', 'Attention', 'Embeddings', 'RAG', 'Agentes'];

    // MÓDULO 2 — CONEXIONES DEL CONCEPTO SELECCIONADO
    final termNodeId = _selectedConcept;
    final conceptNodeId = 'concept-$_selectedConcept';

    final explains = _ke.articles.where((a) => a.title.toLowerCase().contains(termNodeId)).toList();
    final depends = _ke.academyMissions.where((m) => m.prerequisiteIds.contains(conceptNodeId) || m.concepts.contains(_selectedConcept)).toList();
    final projectsUsed = _ke.projects.where((p) => p.objective.toLowerCase().contains(termNodeId)).toList();
    final labsPracticed = _ke.promptExercises.where((ex) => ex.category.toLowerCase().contains(termNodeId) || ex.why.toLowerCase().contains(termNodeId)).toList();
    final missionsTaught = _ke.academyMissions.where((m) => m.concepts.contains(_selectedConcept)).toList();

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Cabecera Universe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KNOWLEDGE UNIVERSE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('Base de conocimiento no lineal offline', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Ir al Dashboard de Progreso',
                    icon: const Icon(Icons.dashboard_customize_outlined),
                    onPressed: () => context.push('/universe-dashboard'),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 3 — BREADCRUMB/EXPLORADOR SECUENCIAL
          Text(
            'Ruta Recomendada de Exploración',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sequentialPath.length,
              separatorBuilder: (context, idx) => const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              itemBuilder: (context, index) {
                final step = sequentialPath[index];
                final isSelected = _selectedConcept.toLowerCase() == step.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ActionChip(
                    backgroundColor: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                    label: Text(
                      step,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                      ),
                    ),
                    onPressed: () {
                      setState(() => _selectedConcept = step.toLowerCase());
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 1 & 2 — RED DE CONEXIONES DEL CONCEPTO SELECCIONADO
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.hub_outlined, color: Colors.purple),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Relaciones: "${_selectedConcept.toUpperCase()}"',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.md),
                  _buildConnectionRow(
                    context,
                    '¿Qué lo explica en el Manual?',
                    explains.isNotEmpty ? explains.map((e) => '• ${e.title}').join('\n') : 'Sin artículo directo.',
                  ),
                  _buildConnectionRow(
                    context,
                    '¿Qué depende de él?',
                    depends.isNotEmpty ? depends.map((d) => '• ${d.title}').join('\n') : 'Sin prerrequisitos críticos inmediatos.',
                  ),
                  _buildConnectionRow(
                    context,
                    '¿Qué laboratorios lo practican?',
                    labsPracticed.isNotEmpty ? labsPracticed.map((l) => '• ${l.title}').join('\n') : 'Práctica libre en AI Lab.',
                  ),
                  _buildConnectionRow(
                    context,
                    '¿Qué proyectos lo utilizan?',
                    projectsUsed.isNotEmpty ? projectsUsed.map((p) => '• ${p.title}').join('\n') : 'Ninguno asignado.',
                  ),
                  _buildConnectionRow(
                    context,
                    '¿Qué misiones lo enseñan?',
                    missionsTaught.isNotEmpty ? missionsTaught.map((m) => '• ${m.title}').join('\n') : 'Sin misión asignada.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 4 — CONCEPTO DEL DÍA DESTACADO
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: AppSpacing.xs),
                      const Text(
                        'CONCEPTO DESTACADO DEL DÍA',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    dailyConcept['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(dailyConcept['explanation'] as String, style: const TextStyle(height: 1.3)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Analogía: ${dailyConcept['analogy']}', style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.3)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Ejemplo: ${dailyConcept['example']}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                  const Divider(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Misión: ${dailyConcept['mission']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Lab: ${dailyConcept['lab']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 5 — DESAFÍO DEL DÍA
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology_outlined, color: Theme.of(context).colorScheme.tertiary),
                      const SizedBox(width: AppSpacing.xs),
                      const Text(
                        'DESAFÍO DEL DÍA OFFLINE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    dailyChallenge.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('${dailyChallenge.category} · Dificultad: ${dailyChallenge.difficulty}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(dailyChallenge.description, style: const TextStyle(height: 1.3)),
                  const SizedBox(height: AppSpacing.md),
                  Text(dailyChallenge.promptQuestion, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _answerCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Ingresá tu respuesta corta aquí...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () => _verifyChallenge(dailyChallenge.answerKey),
                    child: const Text('Verificar Desafío'),
                  ),
                  if (_challengeFeedback != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _challengeFeedback!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _challengeFeedback!.startsWith('¡') ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionRow(BuildContext context, String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.3)),
        ],
      ),
    );
  }
}
