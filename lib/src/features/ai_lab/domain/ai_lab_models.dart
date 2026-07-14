/// Representa un laboratorio del AI Lab (Módulo 3).
final class AiLaboratory {
  const AiLaboratory({
    required this.id,
    required this.title,
    required this.category,
    required this.objective,
    required this.difficulty,
    required this.durationMinutes,
    required this.prerequisites,
    required this.steps,
    required this.expectedResult,
    required this.commonErrors,
    required this.concepts,
  });

  final String id;
  final String title;
  final String category;
  final String objective;
  final String difficulty;
  final int durationMinutes;
  final List<String> prerequisites;
  final List<String> steps;
  final String expectedResult;
  final List<String> commonErrors;
  final List<String> concepts;
}

/// Representa una plantilla reutilizable de prompt (Módulo 6).
final class PromptTemplate {
  const PromptTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.templateText,
  });

  final String id;
  final String title;
  final String category;
  final String description;
  final String templateText;
}

/// Detalle de la evaluación estructural offline del prompt (Módulo 5).
final class PromptEvaluationResult {
  const PromptEvaluationResult({
    required this.score, // 0 a 100
    required this.clarityScore, // 0 a 100
    required this.clarityExplanation,
    required this.contextScore,
    required this.contextExplanation,
    required this.restrictionsScore,
    required this.restrictionsExplanation,
    required this.formatScore,
    required this.formatExplanation,
    required this.objectiveScore,
    required this.objectiveExplanation,
    required this.suggestions,
  });

  final int score;
  final int clarityScore;
  final String clarityExplanation;
  final int contextScore;
  final String contextExplanation;
  final int restrictionsScore;
  final String restrictionsExplanation;
  final int formatScore;
  final String formatExplanation;
  final int objectiveScore;
  final String objectiveExplanation;
  final List<String> suggestions;
}

/// Sesión de práctica guardada en el historial (Módulos 4, 7 y 8).
final class LabPracticeSession {
  const LabPracticeSession({
    required this.id,
    required this.labId,
    required this.labTitle,
    required this.dateStr,
    required this.durationMinutes,
    required this.originalPrompt,
    required this.improvedPrompt,
    required this.observations,
    required this.learnings,
    required this.score,
  });

  final String id;
  final String labId;
  final String labTitle;
  final String dateStr;
  final int durationMinutes;
  final String originalPrompt;
  final String improvedPrompt;
  final String observations;
  final String learnings;
  final int score;
}
