import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

enum KnowledgeNodeStatus { unseen, learning, understood, review, mastered }

final class KnowledgeNode {
  const KnowledgeNode({
    required this.id,
    required this.label,
    required this.missionId,
    required this.precedes,
    required this.unlocks,
  });
  final String id, label, missionId;
  final List<String> precedes, unlocks;
}

abstract final class KnowledgeMapBuilder {
  static List<KnowledgeNode> build(List<Lesson> lessons) {
    final nodes = <KnowledgeNode>[];
    for (var missionIndex = 0; missionIndex < lessons.length; missionIndex++) {
      final lesson = lessons[missionIndex];
      for (var i = 0; i < lesson.concepts.length; i++) {
        final concept = lesson.concepts[i];
        nodes.add(
          KnowledgeNode(
            id: '${lesson.id}:$concept',
            label: concept,
            missionId: lesson.id,
            precedes:
                i == 0 && missionIndex > 0
                    ? <String>[lessons[missionIndex - 1].concepts.last]
                    : i > 0
                    ? <String>[lesson.concepts[i - 1]]
                    : const <String>[],
            unlocks:
                i < lesson.concepts.length - 1
                    ? <String>[lesson.concepts[i + 1]]
                    : missionIndex < lessons.length - 1
                    ? <String>[lessons[missionIndex + 1].concepts.first]
                    : const <String>[],
          ),
        );
      }
    }
    return nodes;
  }
}
