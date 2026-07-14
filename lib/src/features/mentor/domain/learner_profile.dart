/// Perfil pedagógico detallado del estudiante para adaptaciones locales.
class LearnerProfile {
  const LearnerProfile({
    this.name = 'Carlos',
    this.level = 'Intermedio',
    this.interests = const ['IA aplicada', 'automatización', 'criterio tecnológico'],
    this.work = 'Supervisor bancario',
    this.intensive = true,
    this.priorities = const ['prompts profesionales', 'agentes', 'verificación'],
    this.difficulty = 'Exigente',
    this.hoursStudied = 4.5,
    this.learnedConcepts = const ['prompts', 'tokens', 'temperatura'],
    this.pendingConcepts = const ['criterio', 'verificación', 'modelos', 'agentes', 'MCP', 'workflows'],
    this.frequentErrors = const {'alucinaciones': 2, 'seguridad': 1},
    this.evaluationHistory = const [85, 90, 75],
    this.learningSpeed = 1.0,
    this.objectives = const ['Aprender Prompt Engineering', 'Automatizar tareas bancarias'],
    this.activeProjects = const ['prompt-library'],
  });

  final String name;
  final String level;
  final String work;
  final String difficulty;
  final List<String> interests;
  final List<String> priorities;
  final bool intensive;

  // Nuevas métricas del perfil pedagógico (Módulo 1)
  final double hoursStudied;
  final List<String> learnedConcepts;
  final List<String> pendingConcepts;
  final Map<String, int> frequentErrors;
  final List<int> evaluationHistory;
  final double learningSpeed;
  final List<String> objectives;
  final List<String> activeProjects;

  LearnerProfile copyWith({
    String? name,
    String? level,
    String? work,
    String? difficulty,
    List<String>? interests,
    List<String>? priorities,
    bool? intensive,
    double? hoursStudied,
    List<String>? learnedConcepts,
    List<String>? pendingConcepts,
    Map<String, int>? frequentErrors,
    List<int>? evaluationHistory,
    double? learningSpeed,
    List<String>? objectives,
    List<String>? activeProjects,
  }) {
    return LearnerProfile(
      name: name ?? this.name,
      level: level ?? this.level,
      work: work ?? this.work,
      difficulty: difficulty ?? this.difficulty,
      interests: interests ?? this.interests,
      priorities: priorities ?? this.priorities,
      intensive: intensive ?? this.intensive,
      hoursStudied: hoursStudied ?? this.hoursStudied,
      learnedConcepts: learnedConcepts ?? this.learnedConcepts,
      pendingConcepts: pendingConcepts ?? this.pendingConcepts,
      frequentErrors: frequentErrors ?? this.frequentErrors,
      evaluationHistory: evaluationHistory ?? this.evaluationHistory,
      learningSpeed: learningSpeed ?? this.learningSpeed,
      objectives: objectives ?? this.objectives,
      activeProjects: activeProjects ?? this.activeProjects,
    );
  }
}

// Funciones auxiliares de compatibilidad editorial
String mentorAlternative(String concept) =>
    'Miremos $concept desde otro ángulo: identificá primero la entrada, luego la transformación y finalmente cómo verificarías el resultado.';

String mentorHardExample(String concept) =>
    'Ejemplo avanzado de $concept: aplicalo con información incompleta, dos fuentes contradictorias y una decisión que debe quedar auditada.';

String mentorWorkExample(String concept, LearnerProfile profile) =>
    'En tu trabajo como ${profile.work.toLowerCase()}, aplicá $concept a un informe de supervisión: protegé datos, citá la fuente y conservá la aprobación humana.';
