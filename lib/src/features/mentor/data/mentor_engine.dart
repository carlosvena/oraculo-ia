import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';
import 'package:oraculo_ia/src/features/mentor/domain/mentor_events.dart';

/// Estilo de explicación pedagógica soportado por el Mentor.
enum ExplanationStyle {
  formal,
  simple,
  ejemploCotidiano,
  ejemploTecnico,
  analogia,
  pasoAPaso,
  resumenEjecutivo,
}

/// Recomendación generada por el Mentor.
final class MentorRecommendation {
  const MentorRecommendation({
    required this.type,
    required this.target,
    required this.reason,
  });

  final String type; // e.g. 'misión', 'manual', 'glosario', 'laboratorio', 'repaso'
  final String target; // ID o nombre del recurso sugerido
  final String reason; // Justificación pedagógica en español
}

/// Plan de estudio generado por el planificador del Mentor.
final class StudyPlan {
  const StudyPlan({
    required this.goal,
    required this.estimatedMinutes,
    required this.steps,
  });

  final String goal;
  final double estimatedMinutes;
  final List<String> steps;
}

/// Motor central del Mentor Inteligente (MentorEngine) - Singleton.
class MentorEngine {
  MentorEngine._();
  static final MentorEngine instance = MentorEngine._();

  // Perfil pedagógico persistido en memoria local de ejecución
  LearnerProfile _profile = const LearnerProfile();
  LearnerProfile get profile => _profile;

  // Memoria local del Mentor (Módulo 5)
  final List<String> _explainedConcepts = [];
  final List<String> _usedAnalogies = [];
  final List<String> _completedLabs = [];
  final List<String> _acceptedRecommendations = [];

  List<String> get explainedConcepts => List.unmodifiable(_explainedConcepts);
  List<String> get usedAnalogies => List.unmodifiable(_usedAnalogies);
  List<String> get completedLabs => List.unmodifiable(_completedLabs);
  List<String> get acceptedRecommendations => List.unmodifiable(_acceptedRecommendations);

  // --- REACCIÓN A EVENTOS INTERNOS (Módulo 9) ---
  void notify(MentorEvent event) {
    if (event is MissionCompleted) {
      final learned = List<String>.from(_profile.learnedConcepts);
      final pending = List<String>.from(_profile.pendingConcepts);
      
      // Mapear id misión a conceptos aproximados para simular aprendizaje
      final mId = event.missionId;
      String concept = 'nuevo concepto';
      if (mId.contains('models')) {
        concept = 'modelos';
      } else if (mId.contains('prompts')) {
        concept = 'prompts';
      } else if (mId.contains('agents')) {
        concept = 'agentes';
      } else if (mId.contains('workflows')) {
        concept = 'workflows';
      }

      if (!learned.contains(concept)) {
        learned.add(concept);
      }
      pending.remove(concept);

      _profile = _profile.copyWith(
        hoursStudied: _profile.hoursStudied + 0.5,
        learnedConcepts: learned,
        pendingConcepts: pending,
      );
    } else if (event is ConceptLearned) {
      final learned = List<String>.from(_profile.learnedConcepts);
      final pending = List<String>.from(_profile.pendingConcepts);
      if (!learned.contains(event.concept)) learned.add(event.concept);
      pending.remove(event.concept);

      _profile = _profile.copyWith(
        learnedConcepts: learned,
        pendingConcepts: pending,
      );
      _adjustDifficulty(success: true);
    } else if (event is ConceptFailed) {
      final errors = Map<String, int>.from(_profile.frequentErrors);
      errors[event.concept] = (errors[event.concept] ?? 0) + 1;

      _profile = _profile.copyWith(
        frequentErrors: errors,
      );
      _adjustDifficulty(success: false);
    } else if (event is ProjectStarted) {
      final active = List<String>.from(_profile.activeProjects);
      if (!active.contains(event.projectId)) active.add(event.projectId);

      _profile = _profile.copyWith(activeProjects: active);
    } else if (event is ProjectFinished) {
      final active = List<String>.from(_profile.activeProjects);
      active.remove(event.projectId);

      _profile = _profile.copyWith(
        activeProjects: active,
        hoursStudied: _profile.hoursStudied + 2.0,
      );
    } else if (event is ReviewCompleted) {
      final history = List<int>.from(_profile.evaluationHistory)..add(event.score);
      _profile = _profile.copyWith(
        evaluationHistory: history,
        hoursStudied: _profile.hoursStudied + 0.2,
      );
      _adjustDifficulty(success: event.score >= 80);
    } else if (event is ManualRead) {
      _profile = _profile.copyWith(hoursStudied: _profile.hoursStudied + 0.1);
    } else if (event is DictionaryViewed) {
      // Registrar en memoria de conceptos explicados o vistos
      if (!_explainedConcepts.contains(event.termId)) {
        _explainedConcepts.add(event.termId);
      }
    }
  }

  // --- DIFICULTAD ADAPTATIVA (Módulo 4) ---
  void _adjustDifficulty({required bool success}) {
    String currentDiff = _profile.difficulty;
    if (success) {
      if (currentDiff == 'Inicial') {
        currentDiff = 'Intermedio';
      } else if (currentDiff == 'Intermedio') {
        currentDiff = 'Exigente';
      }
    } else {
      if (currentDiff == 'Exigente') {
        currentDiff = 'Intermedio';
      } else if (currentDiff == 'Intermedio') {
        currentDiff = 'Inicial';
      }
    }
    _profile = _profile.copyWith(difficulty: currentDiff);
  }

  // --- MOTOR DE RECOMENDACIONES (Módulo 2) ---
  MentorRecommendation getRecommendation() {
    // 1. Si hay errores repetidos (conceptos con errores >= 2), recomendar repaso del concepto débil
    final weakConcepts = _profile.frequentErrors.entries
        .where((e) => e.value >= 2)
        .map((e) => e.key)
        .toList();

    if (weakConcepts.isNotEmpty) {
      final concept = weakConcepts.first;
      return MentorRecommendation(
        type: 'repaso',
        target: concept,
        reason: 'Detectamos que has tenido dificultades repetidas con "$concept". Te sugiero hacer un repaso y practicar con laboratorios de prompts asociados.',
      );
    }

    // 2. Si hay proyectos activos, recomendar continuar
    if (_profile.activeProjects.isNotEmpty) {
      final proj = _profile.activeProjects.first;
      return MentorRecommendation(
        type: 'proyecto',
        target: proj,
        reason: 'Tienes un proyecto activo ("$proj"). Te sugiero dedicarle tiempo hoy para aplicar los conceptos teóricos aprendidos.',
      );
    }

    // 3. De lo contrario, recomendar la próxima misión de los conceptos pendientes
    if (_profile.pendingConcepts.isNotEmpty) {
      final nextConcept = _profile.pendingConcepts.first;
      return MentorRecommendation(
        type: 'misión',
        target: 'lesson-$nextConcept-001',
        reason: 'Para seguir avanzando hacia tus objetivos de "${_profile.objectives.first}", te recomiendo iniciar la misión de "$nextConcept".',
      );
    }

    // Fallback
    return const MentorRecommendation(
      type: 'manual',
      target: 'introduccion',
      reason: 'Has completado las misiones principales. Te recomiendo leer el manual general para reforzar conceptos avanzados.',
    );
  }

  void acceptRecommendation(MentorRecommendation rec) {
    if (!_acceptedRecommendations.contains(rec.target)) {
      _acceptedRecommendations.add(rec.target);
    }
  }

  // --- EXPLICACIONES ALTERNATIVAS OFFLINE (Módulo 3) ---
  String getAlternativeExplanation(String concept, ExplanationStyle style) {
    final cleanConcept = concept.toLowerCase().trim();

    // Banco de explicaciones deterministas de alta calidad para conceptos clave de IA
    final Map<String, Map<ExplanationStyle, String>> database = {
      'prompts': {
        ExplanationStyle.formal: 'Un prompt es una especificación estructurada en lenguaje natural que sirve como entrada (input) para parametrizar y guiar la inferencia de un modelo autoregresivo.',
        ExplanationStyle.simple: 'Es la instrucción o pregunta que le escribís a la IA para pedirle que haga algo.',
        ExplanationStyle.ejemploCotidiano: 'Es como pedirle un café al mozo: si decís "quiero un café con leche templado, en taza grande y con edulcorante", el resultado es mucho más preciso que si solo decís "quiero café".',
        ExplanationStyle.ejemploTecnico: 'System Prompt: "Actúa como formateador JSON estricto." \nUser Prompt: "Lista las tres capitales del Cono Sur." -> Garantiza una salida parseable sin texto decorativo.',
        ExplanationStyle.analogia: 'Es el volante de un auto: la IA tiene un motor muy potente, pero el prompt decide hacia dónde gira.',
        ExplanationStyle.pasoAPaso: '1. Dale contexto a la IA.\n2. Especificá la tarea exacta.\n3. Añadí restricciones o límites.\n4. Definí el formato de salida esperado.',
        ExplanationStyle.resumenEjecutivo: 'El diseño del prompt determina el 90% de la precisión en tareas de producción offline sin reentrenamiento.',
      },
      'agentes': {
        ExplanationStyle.formal: 'Un agente de IA es una entidad de software autónoma que percibe su entorno a través de inputs, toma decisiones basadas en políticas de razonamiento y ejecuta acciones mediante herramientas integradas (tools).',
        ExplanationStyle.simple: 'Es un programa de IA al que le das una meta y puede usar herramientas (como buscar en internet o crear archivos) por sí mismo para lograrlo.',
        ExplanationStyle.ejemploCotidiano: 'Es como contratar a un asistente personal: en lugar de decirle paso a paso qué hacer, le decís "reservame un hotel en Bariloche para el finde" y él busca, compara y elige.',
        ExplanationStyle.ejemploTecnico: 'Un bucle de ejecución (loop) que evalúa el plan actual, invoca una herramienta del protocolo MCP (Model Context Protocol), analiza el resultado devuelto y decide si completó el objetivo.',
        ExplanationStyle.analogia: 'Es como un robot aspiradora: sabe que tiene que limpiar la sala, decide qué camino tomar y esquiva los obstáculos sola.',
        ExplanationStyle.pasoAPaso: '1. Recibe la meta principal.\n2. Planifica los pasos necesarios.\n3. Invoca una herramienta específica.\n4. Observa el resultado.\n5. Repite hasta alcanzar la meta.',
        ExplanationStyle.resumenEjecutivo: 'La arquitectura de agentes permite delegar flujos complejos estructurando barreras de seguridad (guardrails) y límites presupuestarios operacionales.',
      }
    };

    final entry = database[cleanConcept];
    if (entry != null && entry.containsKey(style)) {
      if (style == ExplanationStyle.analogia) {
        final analogy = entry[style]!;
        if (!_usedAnalogies.contains(analogy)) _usedAnalogies.add(analogy);
      }
      if (!_explainedConcepts.contains(concept)) _explainedConcepts.add(concept);
      return entry[style]!;
    }

    // Fallback dinámico general si el concepto no está en la base de datos de ejemplo
    final styleLabel = style.name.toUpperCase();
    return '[Explicación Offline] Perspectiva $styleLabel para "$concept": Analizar entradas claras, estructurar el flujo de control y contrastar los resultados contra las métricas definidas.';
  }

  // --- PLANIFICADOR INTELIGENTE (Módulo 6) ---
  StudyPlan generatePlan(double timeAvailableMinutes, String goal) {
    final steps = <String>[];

    if (timeAvailableMinutes <= 15) {
      steps.add('1. Repasar términos rápidos del Glosario (5 minutos)');
      if (goal.toLowerCase().contains('agente')) {
        steps.add('2. Leer sección sobre bucles y límites de agentes en el Manual (10 minutos)');
      } else {
        steps.add('3. Leer sección de Prompts Profesionales en el Manual (10 minutos)');
      }
    } else {
      steps.add('1. Inicializar conceptos en el motor de conocimiento (5 minutos)');
      if (goal.toLowerCase().contains('agente') || goal.toLowerCase().contains('prompt')) {
        steps.add('2. Resolver Misión Práctica en Oráculo (25 minutos)');
        steps.add('3. Completar Laboratorio Práctico de Prompts (20 minutos)');
        steps.add('4. Revisar rúbricas de verificación y aprobación humana (10 minutos)');
      } else {
        steps.add('2. Estudiar misiones secuenciales del Track inicial (35 minutos)');
        steps.add('3. Realizar evaluación corta en el Panel de Repaso (15 minutos)');
        steps.add('4. Lectura de referencias en el Manual (5 minutos)');
      }
    }

    return StudyPlan(
      goal: goal,
      estimatedMinutes: timeAvailableMinutes,
      steps: steps,
    );
  }
}
