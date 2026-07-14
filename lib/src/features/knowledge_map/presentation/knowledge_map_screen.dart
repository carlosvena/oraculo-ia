import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_providers.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/learning_graph.dart';

class KnowledgeMapScreen extends ConsumerStatefulWidget {
  const KnowledgeMapScreen({required this.onOpenMission, super.key});
  final ValueChanged<String> onOpenMission;

  @override
  ConsumerState<KnowledgeMapScreen> createState() => _KnowledgeMapScreenState();
}

class _KnowledgeMapScreenState extends ConsumerState<KnowledgeMapScreen> {
  final _engine = LearningEngine.instance;
  List<KnowledgeGraphNode> _recommendedRoute = [];
  double _timeMinutes = 45.0;
  String _selectedGoal = 'Aprender Prompt Engineering';

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: AsyncContent<KnowledgeContent>(
        value: ref.watch(knowledgeProvider),
        errorMessage: 'No pudimos construir el mapa.',
        retryLabel: 'Reintentar',
        onRetry: () => ref.invalidate(knowledgeProvider),
        data: (content) {
          // Inicializar grafo si no está inicializado
          if (_engine.nodes.isEmpty) {
            _engine.initializeGraph();
          }

          final nodesList = _engine.nodes.values.toList();
          final errors = _engine.isDetained ? ['El sistema se encuentra detenido temporalmente por errores repetidos. Completá repasos.'] : <String>[];

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            children: <Widget>[
              // Cabecera Premium
              Text(
                'Árbol del Conocimiento V2',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Grafo no lineal de conceptos, laboratorios y proyectos. Tocá cada nodo para ver sus conexiones y estado de desbloqueo.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.md),

              // Panel de Métricas de Estudio Real (Módulo 9)
              _buildMetricsPanel(context),
              const SizedBox(height: AppSpacing.md),

              if (errors.isNotEmpty)
                Card(
                  color: Colors.orange.shade50.withOpacity(0.1),
                  shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.orange)),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      errors.first,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // Generador de Rutas Dinámicas (Módulo 4)
              _buildDynamicRouteGenerator(context),
              const SizedBox(height: AppSpacing.lg),

              // Lista de Nodos
              Text(
                'Nodos de Aprendizaje',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final node in nodesList)
                _buildGraphNodeTile(context, node),
            ],
          );
        },
      ),
    );
  }

  // --- COMPONENTE DE MÉTRICAS REALES ---
  Widget _buildMetricsPanel(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Estadísticas Reales de Aprendizaje',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniStat('Estudiado', '${_engine.actualHoursStudied.toStringAsFixed(1)}h'),
                _buildMiniStat('Proyectos', '${_engine.totalProjectsCompleted}'),
                _buildMiniStat('Repasos', '${_engine.totalReviewsDone}'),
                _buildMiniStat('Errores', '${_engine.totalErrors}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // --- GENERADOR DE RUTA DINÁMICA ---
  Widget _buildDynamicRouteGenerator(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cálculo de Ruta Dinámica del Día',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Calcula la ruta ideal adaptada a tu rendimiento y tiempo disponible.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGoal,
                    decoration: const InputDecoration(labelText: 'Objetivo'),
                    items: const [
                      DropdownMenuItem(value: 'Aprender Prompt Engineering', child: Text('Aprender Prompt Engineering')),
                      DropdownMenuItem(value: 'Construir un agente conceptual', child: Text('Construir un agente conceptual')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGoal = val);
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: _timeMinutes.round().toString(),
                    decoration: const InputDecoration(labelText: 'Tiempo (min)'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) _timeMinutes = parsed;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _recommendedRoute = _engine.generateDynamicRoute(
                    timeAvailableMinutes: _timeMinutes,
                    goal: _selectedGoal,
                  );
                });
              },
              child: const Text('Calcular Ruta Sugerida'),
            ),
            if (_recommendedRoute.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),
              const Text('Ruta recomendada para hoy:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _recommendedRoute.map((node) {
                  return Chip(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    label: Text(node.label),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- RENDERIZADO DE NODO DEL GRAFO ---
  Widget _buildGraphNodeTile(BuildContext context, KnowledgeGraphNode node) {
    final unlocked = _engine.isUnlocked(node.id);
    final missing = _engine.getMissingPrerequisites(node.id);

    // Seleccionar color por tipo de nodo
    final color = switch (node.type) {
      KnowledgeNodeType.concept => Colors.purple,
      KnowledgeNodeType.mission => Colors.blue,
      KnowledgeNodeType.laboratory => Colors.teal,
      KnowledgeNodeType.project => Colors.amber,
      KnowledgeNodeType.term => Colors.indigo,
      KnowledgeNodeType.chapter => Colors.deepOrange,
    };

    final icon = switch (node.type) {
      KnowledgeNodeType.concept => Icons.lightbulb_outline,
      KnowledgeNodeType.mission => Icons.explore,
      KnowledgeNodeType.laboratory => Icons.science,
      KnowledgeNodeType.project => Icons.work,
      KnowledgeNodeType.term => Icons.menu_book,
      KnowledgeNodeType.chapter => Icons.article,
    };

    // Obtener nivel cognitivo si es concepto
    String masteryLabel = '';
    if (node.type == KnowledgeNodeType.concept) {
      final mId = node.id;
      final level = _engine.conceptMastery[mId] ?? ConceptMasteryLevel.unseen;
      masteryLabel = ' · Dominio: ${level.label} (Nivel ${level.level})';
    }

    return Card(
      child: ExpansionTile(
        leading: Icon(unlocked ? icon : Icons.lock_outline, color: unlocked ? color : Colors.grey),
        title: Text(node.label),
        subtitle: Text(
          '${node.type.name.toUpperCase()} · ${_engine.isDetained && node.type == KnowledgeNodeType.mission ? 'BLOQUEADO POR ERRORES' : unlocked ? 'DESBLOQUEADO' : 'BLOQUEADO'}$masteryLabel',
          style: TextStyle(
            color: unlocked ? Colors.grey : Colors.red.shade400,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const Border(),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dificultad: ${node.difficulty} · Tiempo estimado: ${node.estimatedMinutes.round()} minutos'),
                const SizedBox(height: 4),
                if (!unlocked && missing.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '⚠️ Prerrequisitos Faltantes:',
                    style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  ...missing.map((m) => Text('• $m', style: TextStyle(color: Colors.red.shade300, fontSize: 13))),
                ],
                if (node.prerequisiteIds.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text('Predecesores directos: ${node.prerequisiteIds.join(" · ")}'),
                ],
                if (node.unlockIds.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text('Nodos que desbloquea: ${node.unlockIds.join(" · ")}'),
                ],
              ],
            ),
          ),
          if (unlocked && (node.type == KnowledgeNodeType.mission || node.type == KnowledgeNodeType.project))
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  if (node.type == KnowledgeNodeType.mission) {
                    final cleanId = node.id.replaceFirst('mission-', '');
                    widget.onOpenMission(cleanId);
                  } else {
                    // Simular entrega de proyecto
                    _engine.completeProject(node.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('¡Proyecto "${node.label}" completado!')),
                    );
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: Text(node.type == KnowledgeNodeType.mission ? 'Iniciar Misión' : 'Entregar Proyecto'),
              ),
            ),
        ],
      ),
    );
  }
}
