import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_providers.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/knowledge_map.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class KnowledgeMapScreen extends ConsumerWidget {
  const KnowledgeMapScreen({required this.onOpenMission, super.key});
  final ValueChanged<String> onOpenMission;
  @override
  Widget build(BuildContext context, WidgetRef ref) => OraculoScaffold(
    body: AsyncContent<KnowledgeContent>(
      value: ref.watch(knowledgeProvider),
      errorMessage: 'No pudimos construir el mapa.',
      retryLabel: 'REINTENTAR',
      onRetry: () => ref.invalidate(knowledgeProvider),
      data: (content) {
        final learning =
            ref.watch(learningStateProvider).value ?? const LearningState();
        final nodes = KnowledgeMapBuilder.build(content.lessons);
        return ListView(
          children: <Widget>[
            Text(
              'Mapa de conocimiento',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Una ruta clara entre conceptos. Tocá una tarjeta para ver relaciones y abrir su misión.',
            ),
            const SizedBox(height: 16),
            for (final node in nodes)
              _NodeCard(
                node: node,
                status: _status(node, learning),
                onOpen: () => onOpenMission(node.missionId),
              ),
          ],
        );
      },
    ),
  );
  KnowledgeNodeStatus _status(KnowledgeNode node, LearningState state) {
    if (state.reviewConcepts.contains(node.missionId)) {
      return KnowledgeNodeStatus.review;
    }
    if (state.masteredConcepts.contains(node.label)) {
      return KnowledgeNodeStatus.mastered;
    }
    if (state.completed.contains(node.missionId)) {
      return KnowledgeNodeStatus.understood;
    }
    if (state.currentLessonId == node.missionId) {
      return KnowledgeNodeStatus.learning;
    }
    return KnowledgeNodeStatus.unseen;
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({
    required this.node,
    required this.status,
    required this.onOpen,
  });
  final KnowledgeNode node;
  final KnowledgeNodeStatus status;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      KnowledgeNodeStatus.unseen => Colors.grey,
      KnowledgeNodeStatus.learning => Colors.amber,
      KnowledgeNodeStatus.understood => Colors.blue,
      KnowledgeNodeStatus.review => Colors.orange,
      KnowledgeNodeStatus.mastered => Theme.of(context).colorScheme.primary,
    };
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.hub_outlined, color: color),
        title: Text(node.label),
        subtitle: Text(_label(status)),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Text(
            'Lo precede: ${node.precedes.isEmpty ? 'Inicio' : node.precedes.join(' · ')}',
          ),
          const SizedBox(height: 8),
          Text(
            'Desbloquea: ${node.unlocks.isEmpty ? 'Cierre del recorrido' : node.unlocks.join(' · ')}',
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onOpen,
              child: const Text('ABRIR MISIÓN'),
            ),
          ),
        ],
      ),
    );
  }

  String _label(KnowledgeNodeStatus value) => switch (value) {
    KnowledgeNodeStatus.unseen => 'No visto',
    KnowledgeNodeStatus.learning => 'En aprendizaje',
    KnowledgeNodeStatus.understood => 'Comprendido',
    KnowledgeNodeStatus.review => 'Necesita repaso',
    KnowledgeNodeStatus.mastered => 'Dominado',
  };
}
