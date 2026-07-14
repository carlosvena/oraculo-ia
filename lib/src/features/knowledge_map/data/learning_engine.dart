import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/learning_graph.dart';

/// Motor de Aprendizaje de Grafo No Lineal (Learning Engine v2) - Singleton.
class LearningEngine {
  LearningEngine._();
  static final LearningEngine instance = LearningEngine._();

  final Map<String, KnowledgeGraphNode> _nodes = {};
  final Map<String, ConceptMasteryLevel> _conceptMastery = {};

  // Detención Inteligente (Módulo 6)
  int _consecutiveErrors = 0;

  // Registro de Métricas Reales (Módulo 9)
  double _actualHoursStudied = 0.0;
  int _totalErrors = 0;
  int _totalReviewsDone = 0;
  int _totalProjectsCompleted = 0;
  final List<double> _sessionDurations = [];

  // Getters Públicos
  Map<String, KnowledgeGraphNode> get nodes => Map.unmodifiable(_nodes);
  Map<String, ConceptMasteryLevel> get conceptMastery => Map.unmodifiable(_conceptMastery);
  bool get isDetained => _consecutiveErrors >= 3;
  double get actualHoursStudied => _actualHoursStudied;
  int get totalErrors => _totalErrors;
  int get totalReviewsDone => _totalReviewsDone;
  int get totalProjectsCompleted => _totalProjectsCompleted;

  int get masteredConceptsCount =>
      _conceptMastery.values.where((v) => v == ConceptMasteryLevel.mastered).length;

  double get averageSessionDuration {
    if (_sessionDurations.isEmpty) return 0.0;
    return _sessionDurations.reduce((a, b) => a + b) / _sessionDurations.length;
  }

  // --- CONSTRUCCIÓN DEL GRAFO (Módulo 1) ---
  void initializeGraph() {
    _nodes.clear();
    final ke = KnowledgeEngine.instance;
    if (!ke.isInitialized) return;

    // 1. Registrar Nodos de Concepto
    final allConcepts = ke.terms.map((t) => t.term).toSet()
      ..addAll(ke.lessonsMetadata.expand((l) => l.concepts));

    for (final concept in allConcepts) {
      final cleanId = _conceptId(concept);
      _nodes[cleanId] = KnowledgeGraphNode(
        id: cleanId,
        label: concept,
        type: KnowledgeNodeType.concept,
        prerequisiteIds: const [],
        unlockIds: const [],
        dependencyIds: const [],
        difficulty: 'Inicial',
        estimatedMinutes: 5,
      );
      // Iniciar dominio en nivel 0 (Módulo 3)
      _conceptMastery[cleanId] ??= ConceptMasteryLevel.unseen;
    }

    // 2. Registrar Nodos de Términos
    for (final term in ke.terms) {
      _nodes[term.id] = KnowledgeGraphNode(
        id: term.id,
        label: term.term,
        type: KnowledgeNodeType.term,
        prerequisiteIds: [_conceptId(term.term)],
        unlockIds: const [],
        dependencyIds: term.related,
        difficulty: 'Inicial',
        estimatedMinutes: 2,
      );
    }

    // 3. Registrar Nodos de Misiones (Módulo 2)
    for (final lesson in ke.lessonsMetadata) {
      // Inferencia de prerrequisitos de lecciones anteriores
      final prereqIds = lesson.prerequisites.map((p) => 'mission-$p').toList();
      
      // Agregar prerrequisito de conceptos enseñados en ella
      final taught = lesson.concepts.map((c) => _conceptId(c)).toList();

      _nodes['mission-${lesson.id}'] = KnowledgeGraphNode(
        id: 'mission-${lesson.id}',
        label: lesson.title,
        type: KnowledgeNodeType.mission,
        prerequisiteIds: prereqIds,
        unlockIds: taught,
        dependencyIds: const [],
        difficulty: 'Intermedio',
        estimatedMinutes: lesson.duration.toDouble(),
      );
    }

    // 4. Registrar Nodos de Laboratorios
    for (final ex in ke.promptExercises) {
      _nodes[ex.id] = KnowledgeGraphNode(
        id: ex.id,
        label: ex.title,
        type: KnowledgeNodeType.laboratory,
        prerequisiteIds: [_conceptId(ex.category)], // Requiere dominar el concepto de su categoría
        unlockIds: const [],
        dependencyIds: const [],
        difficulty: ex.level == 3 ? 'Avanzado' : ex.level == 2 ? 'Intermedio' : 'Inicial',
        estimatedMinutes: 15,
      );
    }

    // 5. Registrar Nodos de Proyectos (Módulo 7)
    for (final proj in ke.projects) {
      final reqMissions = proj.missions.map((m) {
        // Mapear número de lección a ID de misión
        final match = ke.lessonsMetadata.firstWhere((l) => l.id.endsWith(m), orElse: () => ke.lessonsMetadata.first);
        return 'mission-${match.id}';
      }).toList();

      _nodes['project-${proj.id}'] = KnowledgeGraphNode(
        id: 'project-${proj.id}',
        label: proj.title,
        type: KnowledgeNodeType.project,
        prerequisiteIds: reqMissions,
        unlockIds: const [],
        dependencyIds: const [],
        difficulty: 'Avanzado',
        estimatedMinutes: 90,
      );
    }

    // 6. Registrar Nodos de Capítulos (Manual)
    for (final art in ke.articles) {
      _nodes[art.id] = KnowledgeGraphNode(
        id: art.id,
        label: art.title,
        type: KnowledgeNodeType.chapter,
        prerequisiteIds: const [],
        unlockIds: const [],
        dependencyIds: art.links,
        difficulty: 'Intermedio',
        estimatedMinutes: 10,
      );
    }

    // Rellenar inversamente los unlockIds del grafo
    _resolveUnlockIds();
  }

  void _resolveUnlockIds() {
    final Map<String, List<String>> unlocksMap = {};
    for (final node in _nodes.values) {
      for (final prereq in node.prerequisiteIds) {
        unlocksMap.putIfAbsent(prereq, () => []).add(node.id);
      }
    }

    for (final entry in unlocksMap.entries) {
      final prereqId = entry.key;
      if (_nodes.containsKey(prereqId)) {
        final node = _nodes[prereqId]!;
        _nodes[prereqId] = node.copyWith(unlockIds: entry.value);
      }
    }
  }

  String _conceptId(String concept) => 'concept-${concept.toLowerCase().trim()}';

  // --- COMPROBACIÓN DE PRERREQUISITOS (Módulo 2) ---
  bool isUnlocked(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return false;

    // Verificar si todos sus prerrequisitos críticos están resueltos
    for (final prereqId in node.prerequisiteIds) {
      final prereqNode = _nodes[prereqId];
      if (prereqNode == null) continue;

      if (prereqNode.type == KnowledgeNodeType.concept) {
        // Conceptos requieren nivel cognitivo >= 2 (Comprendido)
        final mastery = _conceptMastery[prereqId] ?? ConceptMasteryLevel.unseen;
        if (mastery.level < 2) return false;
      } else if (prereqNode.type == KnowledgeNodeType.mission) {
        // Misiones requieren estar resueltas en el KnowledgeEngine
        final cleanId = prereqId.replaceFirst('mission-', '');
        // Usar simulación para completar
        if (!_isMissionCompleted(cleanId)) return false;
      }
    }

    return true;
  }

  List<String> getMissingPrerequisites(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return const [];
    final missing = <String>[];

    for (final prereqId in node.prerequisiteIds) {
      final prereqNode = _nodes[prereqId];
      if (prereqNode == null) continue;

      if (prereqNode.type == KnowledgeNodeType.concept) {
        final mastery = _conceptMastery[prereqId] ?? ConceptMasteryLevel.unseen;
        if (mastery.level < 2) {
          missing.add('Concepto "${prereqNode.label}" (Nivel mínimo: Comprendido)');
        }
      } else if (prereqNode.type == KnowledgeNodeType.mission) {
        final cleanId = prereqId.replaceFirst('mission-', '');
        if (!_isMissionCompleted(cleanId)) {
          missing.add('Misión "${prereqNode.label}"');
        }
      }
    }
    return missing;
  }

  bool _isMissionCompleted(String lessonId) {
    // Si ya completó la misión o tiene nivel de conceptos enseñados en ella
    final lesson = KnowledgeEngine.instance.lessonsMetadata.firstWhere((l) => l.id == lessonId, orElse: () => KnowledgeEngine.instance.lessonsMetadata.first);
    for (final concept in lesson.concepts) {
      final cId = _conceptId(concept);
      if ((_conceptMastery[cId] ?? ConceptMasteryLevel.unseen).level >= 2) {
        return true;
      }
    }
    return false;
  }

  // --- DOMINIO DE CONCEPTOS (Módulo 3) ---
  void setConceptMastery(String concept, ConceptMasteryLevel level) {
    final cId = _conceptId(concept);
    _conceptMastery[cId] = level;
  }

  void incrementConceptMastery(String concept) {
    final cId = _conceptId(concept);
    final current = _conceptMastery[cId] ?? ConceptMasteryLevel.unseen;
    if (current.level < 5) {
      setConceptMastery(concept, ConceptMasteryLevel.fromInt(current.level + 1));
    }
  }

  // --- TRANSFERENCIA DE CONOCIMIENTO (Módulo 5) ---
  String getTransferPrompt(String concept) {
    final cId = _conceptId(concept);
    final mastery = _conceptMastery[cId] ?? ConceptMasteryLevel.unseen;
    if (mastery.level >= 2) {
      return 'Dado que ya comprendiste "$concept" en misiones anteriores, no volveremos a repasar la teoría básica. En esta sección nos enfocaremos directamente en su aplicación avanzada y control de alucinaciones.';
    }
    return 'Analicemos desde cero el concepto de "$concept" para entender sus bases conceptuales y límites teóricos.';
  }

  // --- DETENCIÓN INTELIGENTE (Módulo 6) ---
  void recordQuizFailure() {
    _consecutiveErrors++;
    _totalErrors++;
    if (_consecutiveErrors >= 3) {
      // Forzar un incremento en repasos
      _totalReviewsDone++;
    }
  }

  void recordQuizSuccess() {
    _consecutiveErrors = 0;
  }

  void resetSmartDetention() {
    _consecutiveErrors = 0;
  }

  // --- BLOQUEO DE PROYECTOS OBLIGATORIOS (Módulo 7) ---
  bool isProjectBlockActive(String trackId) {
    // Si es track-automation o track-agents, validar que los proyectos del track anterior estén completados.
    if (trackId == 'track-automation' || trackId == 'track-agents') {
      // Buscar proyectos de track-foundations (ej. prompt-library, model-comparison)
      final requiredProjects = ['prompt-library', 'model-comparison'];
      for (final pId in requiredProjects) {
        if (!_isProjectCompleted(pId)) {
          return true; // Bloqueo activo
        }
      }
    }
    return false;
  }

  bool _isProjectCompleted(String projectId) {
    // Retorna verdadero si ha finalizado o simulado el proyecto
    return _totalProjectsCompleted > 0;
  }

  void completeProject(String projectId) {
    _totalProjectsCompleted++;
  }

  // --- GENERACIÓN DE RUTA DINÁMICA (Módulo 4) ---
  List<KnowledgeGraphNode> generateDynamicRoute({
    required double timeAvailableMinutes,
    required String goal,
  }) {
    final route = <KnowledgeGraphNode>[];
    
    // 1. Si está detenido por fallos (Detención Inteligente), solo sugerir capítulos de manual y glosario de repaso
    if (isDetained) {
      final reviews = _nodes.values.where((n) => n.type == KnowledgeNodeType.chapter || n.type == KnowledgeNodeType.term).toList();
      reviews.shuffle();
      return reviews.take(2).toList();
    }

    // 2. Si hay proyectos prioritarios pendientes desbloqueados
    final unlockedProjects = _nodes.values
        .where((n) => n.type == KnowledgeNodeType.project && isUnlocked(n.id))
        .toList();
    if (unlockedProjects.isNotEmpty && timeAvailableMinutes >= 60) {
      route.add(unlockedProjects.first);
    }

    // 3. Agregar misiones desbloqueadas y laboratorios que entren en el tiempo estimado
    double currentMinutes = 0.0;
    final candidates = _nodes.values
        .where((n) => (n.type == KnowledgeNodeType.mission || n.type == KnowledgeNodeType.laboratory) && isUnlocked(n.id))
        .toList();

    for (final node in candidates) {
      if (currentMinutes + node.estimatedMinutes <= timeAvailableMinutes) {
        route.add(node);
        currentMinutes += node.estimatedMinutes;
      }
    }

    return route;
  }

  // --- REGISTRO DE MÉTRICAS (Módulo 9) ---
  void recordSession(double durationMinutes) {
    _sessionDurations.add(durationMinutes);
    _actualHoursStudied += (durationMinutes / 60.0);
  }
}
