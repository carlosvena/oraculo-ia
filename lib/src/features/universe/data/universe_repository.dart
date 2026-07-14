import 'package:oraculo_ia/src/features/ai_lab/data/ai_lab_repository.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';
import 'package:oraculo_ia/src/features/universe/domain/universe_models.dart';

class UniverseRepository {
  UniverseRepository._() {
    _initBadges();
    _seedInitialTimeline();
  }
  static final instance = UniverseRepository._();

  final List<LearningTimelineEvent> _timelineEvents = [];
  final List<MasteryBadge> _badges = [];

  List<LearningTimelineEvent> get timelineEvents => List.unmodifiable(_timelineEvents);
  List<MasteryBadge> get badges => List.unmodifiable(_badges);

  void recordEvent(TimelineEventType type, String title, String description) {
    _timelineEvents.add(
      LearningTimelineEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        title: title,
        description: description,
        timestamp: DateTime.now(),
      ),
    );
    checkBadgeUnlocks();
  }

  void _initBadges() {
    _badges.addAll([
      const MasteryBadge(
        id: "badge-first-concept",
        title: "Iniciando el Viaje",
        description: "Entendiste tu primer concepto de IA en nivel >= 2.",
        iconName: "school_outlined",
      ),
      const MasteryBadge(
        id: "badge-prompt-master",
        title: "Arquitecto de Prompts",
        description: "Alcanzaste nivel 4 (Dominado) en el concepto de Prompt.",
        iconName: "architecture",
      ),
      const MasteryBadge(
        id: "badge-project-hero",
        title: "Entregable de Plata",
        description: "Completaste tu primer proyecto integrador offline.",
        iconName: "workspace_premium_outlined",
      ),
      const MasteryBadge(
        id: "badge-lab-champion",
        title: "Científico del Lab",
        description: "Realizaste al menos 3 prácticas en el AI Lab.",
        iconName: "science",
      ),
      const MasteryBadge(
        id: "badge-streak-consistency",
        title: "Constancia de Hierro",
        description: "Registraste al menos 5 horas de estudio en la Academia.",
        iconName: "timer_outlined",
      ),
    ]);
  }

  void _seedInitialTimeline() {
    _timelineEvents.addAll([
      LearningTimelineEvent(
        id: "seed-1",
        type: TimelineEventType.conceptLearned,
        title: "Concepto Aprendido: Prompt",
        description: "Alcanzaste nivel Comprendido tras aprobar el quiz inicial.",
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LearningTimelineEvent(
        id: "seed-2",
        type: TimelineEventType.labCompleted,
        title: "Práctica: Zero-Shot Básico",
        description: "Completaste la práctica con un puntaje de 80/100 en el AI Lab.",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  void checkBadgeUnlocks() {
    final le = LearningEngine.instance;
    final labRepo = AiLabRepository.instance;

    for (int i = 0; i < _badges.length; i++) {
      final badge = _badges[i];
      if (badge.isUnlocked) continue;

      bool shouldUnlock = false;

      if (badge.id == "badge-first-concept") {
        shouldUnlock = le.conceptMastery.values.any((lvl) => lvl.index >= 2);
      } else if (badge.id == "badge-prompt-master") {
        shouldUnlock = le.conceptMastery['concept-prompt']?.index == 4;
      } else if (badge.id == "badge-project-hero") {
        shouldUnlock = le.totalProjectsCompleted > 0;
      } else if (badge.id == "badge-lab-champion") {
        shouldUnlock = labRepo.history.length >= 3;
      } else if (badge.id == "badge-streak-consistency") {
        shouldUnlock = le.actualHoursStudied >= 5.0;
      }

      if (shouldUnlock) {
        _badges[i] = badge.copyWith(unlockedAt: DateTime.now());
      }
    }
  }

  // MÓDULO 5 — 10 DESAFÍOS DIARIOS OFFLINE ROTATIVOS
  final List<DailyChallenge> _dailyChallenges = const [
    DailyChallenge(
      title: "Optimización de Verbos Imperativos",
      category: "Prompt Engineering",
      difficulty: "Inicial",
      description: "Mejorá el prompt: '¿Podrías por favor resumir este texto?' quitando la cortesía y empezando con un verbo imperativo directo.",
      promptQuestion: "¿Cómo quedaría el prompt optimizado?",
      answerKey: "resumí",
    ),
    DailyChallenge(
      title: "Encapsulado XML",
      category: "Claude",
      difficulty: "Inicial",
      description: "Aislá la variable 'contexto' dentro de tags XML adecuados para prevenir inyecciones de código.",
      promptQuestion: "Escribí el tag de apertura y cierre envolviendo la palabra 'datos':",
      answerKey: "<contexto>datos</contexto>",
    ),
    DailyChallenge(
      title: "Inyección de Instrucciones",
      category: "Prompt Engineering",
      difficulty: "Intermedio",
      description: "Añadí una restricción para evitar que el modelo responda preguntas fuera del tema provisto.",
      promptQuestion: "¿Qué palabra clave usarías para prohibir respuestas?",
      answerKey: "evitá",
    ),
    DailyChallenge(
      title: "Estructura Minto",
      category: "Documentos",
      difficulty: "Intermedio",
      description: "Organizá un correo corporativo colocando la conclusión al inicio y luego 3 argumentos de soporte.",
      promptQuestion: "¿Cómo se llama este formato de pirámide invertida?",
      answerKey: "minto",
    ),
    DailyChallenge(
      title: "Rate Limit exponencial",
      category: "Automatización",
      difficulty: "Avanzado",
      description: "Al recibir un error HTTP 429 de Rate Limit, ¿cuál es la técnica de reintentos recomendada?",
      promptQuestion: "Retroceso exponencial con factor...",
      answerKey: "exponencial",
    ),
    DailyChallenge(
      title: "Excel BUSCARV",
      category: "Excel",
      difficulty: "Inicial",
      description: "Escribí la fórmula de Excel para buscar el valor de la celda A2 en el rango de la hoja Datos B2:C10.",
      promptQuestion: "Sintaxis de la fórmula:",
      answerKey: "buscarv",
    ),
    DailyChallenge(
      title: "Función Pura de Código",
      category: "Programación",
      difficulty: "Intermedio",
      description: "Una función que no altera ninguna variable externa de memoria y devuelve siempre el mismo resultado para las mismas entradas se denomina...",
      promptQuestion: "Tipo de función:",
      answerKey: "pura",
    ),
    DailyChallenge(
      title: "Dataset Fine-Tuning",
      category: "LLM",
      difficulty: "Avanzado",
      description: "¿Cuál es el formato estándar de archivo de texto JSON de múltiples líneas utilizado para cargar pares de entrenamiento de modelos?",
      promptQuestion: "Extensión del archivo:",
      answerKey: "jsonl",
    ),
    DailyChallenge(
      title: "RAG Retrieval",
      category: "Agentes",
      difficulty: "Intermedio",
      description: "La técnica que recupera documentos relevantes de una base de datos vectorial local para inyectarlos en el prompt de inferencia es...",
      promptQuestion: "Sigla de la técnica:",
      answerKey: "rag",
    ),
    DailyChallenge(
      title: "Chain of Thought",
      category: "Prompt Engineering",
      difficulty: "Intermedio",
      description: "La técnica CoT instruye al modelo a pensar de forma secuencial antes de dar la respuesta.",
      promptQuestion: "Siglas de Chain of Thought:",
      answerKey: "cot",
    ),
  ];

  DailyChallenge getDailyChallenge() {
    final day = DateTime.now().day;
    final index = day % _dailyChallenges.length;
    return _dailyChallenges[index];
  }

  // MÓDULO 4 — CONCEPTO DEL DÍA DESTACADO
  Map<String, dynamic> getDailyConcept() {
    final day = DateTime.now().day;
    final concepts = [
      {
        "title": "Chain of Thought (CoT)",
        "explanation": "Técnica que fuerza al modelo a generar pasos intermedios de razonamiento lógico antes de emitir la conclusión final.",
        "analogy": "Es equivalente a pedirle a un estudiante de matemáticas que escriba las operaciones en la hoja en lugar de solo poner el resultado final.",
        "example": "Prompt: 'Resolvé este acertijo paso a paso. Pensá de forma secuencial y al final da el resultado en <output>.'",
        "mission": "Misión: Chain of thought (ac-015)",
        "lab": "Lab 03: Chain of Thought (CoT)",
      },
      {
        "title": "Few-Shot Prompting",
        "explanation": "Proveer ejemplos estructurados de entrada y salida esperada dentro de la instrucción del modelo.",
        "analogy": "Como mostrarle a un pintor novato tres cuadros terminados del estilo que deseas antes de que empiece a pintar.",
        "example": "Entrada: Bueno -> Salida: Positivo. Entrada: Malo -> Salida: Negativo. Entrada: Regular -> Salida:",
        "mission": "Misión: Few-shot learning (ac-014)",
        "lab": "Lab 02: Few-Shot Estructurado",
      },
      {
        "title": "Model Context Protocol (MCP)",
        "explanation": "Protocolo abierto que estandariza la comunicación bidireccional y offline de recursos y herramientas entre clientes y servidores locales de IA.",
        "analogy": "Funciona como un cable USB virtual y regulado que conecta el cerebro del agente con los archivos de tu disco duro.",
        "example": "Handshake JSON-RPC local exponiendo métodos de lectura y escritura restringidos.",
        "mission": "Misión: Protocolo MCP (ac-035)",
        "lab": "Lab 28: Protocolo MCP Offline",
      }
    ];

    return concepts[day % concepts.length];
  }
}
