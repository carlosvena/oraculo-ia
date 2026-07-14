/// Tipos de nodo de conocimiento dentro del grafo.
enum KnowledgeNodeType {
  mission,
  concept,
  laboratory,
  project,
  term,
  chapter,
}

/// Niveles cognitivos del dominio de un concepto (Módulo 3).
enum ConceptMasteryLevel {
  unseen(0, 'No visto'),
  read(1, 'Leído'),
  understood(2, 'Comprendido'),
  applied(3, 'Aplicado'),
  mastered(4, 'Dominado'),
  taught(5, 'Enseñado');

  const ConceptMasteryLevel(this.level, this.label);
  final int level;
  final String label;

  static ConceptMasteryLevel fromInt(int val) {
    return ConceptMasteryLevel.values.firstWhere(
      (v) => v.level == val,
      orElse: () => ConceptMasteryLevel.unseen,
    );
  }
}

/// Representa un nodo real en el grafo de conocimiento unificado (Módulo 1).
final class KnowledgeGraphNode {
  const KnowledgeGraphNode({
    required this.id,
    required this.label,
    required this.type,
    required this.prerequisiteIds,
    required this.unlockIds,
    required this.dependencyIds,
    required this.difficulty,
    required this.estimatedMinutes,
  });

  final String id;
  final String label;
  final KnowledgeNodeType type;
  final List<String> prerequisiteIds; // Nodos críticos anteriores
  final List<String> unlockIds; // Nodos que este desbloquea
  final List<String> dependencyIds; // Relaciones débiles de contexto
  final String difficulty; // 'Inicial', 'Intermedio', 'Avanzado'
  final double estimatedMinutes;

  KnowledgeGraphNode copyWith({
    List<String>? prerequisiteIds,
    List<String>? unlockIds,
  }) {
    return KnowledgeGraphNode(
      id: id,
      label: label,
      type: type,
      prerequisiteIds: prerequisiteIds ?? this.prerequisiteIds,
      unlockIds: unlockIds ?? this.unlockIds,
      dependencyIds: dependencyIds,
      difficulty: difficulty,
      estimatedMinutes: estimatedMinutes,
    );
  }
}
