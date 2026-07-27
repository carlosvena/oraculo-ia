final class PromptExercise {
  const PromptExercise({
    required this.id,
    required this.category,
    required this.level,
    required this.title,
    required this.original,
    required this.improved,
    required this.why,
  });
  final String id, category, title, original, improved, why;
  final int level;
}

final class PromptEvaluation {
  const PromptEvaluation({required this.score, required this.feedback});
  final int score;
  final List<String> feedback;
}

abstract final class PromptRules {
  static PromptEvaluation evaluate(String prompt) {
    final text = prompt.toLowerCase();
    final checks = <String, bool>{
      'Propósito claro': prompt.length > 35,
      'Contexto': text.contains('para ') || text.contains('contexto'),
      'Formato':
          text.contains('tabla') ||
          text.contains('puntos') ||
          text.contains('entreg'),
      'Criterio de calidad':
          text.contains('criterio') ||
          text.contains('evidencia') ||
          text.contains('verific'),
      'Límites':
          text.contains('no ') ||
          text.contains('sin ') ||
          text.contains('antes de'),
    };
    return PromptEvaluation(
      score: checks.values.where((v) => v).length,
      feedback: [
        for (final entry in checks.entries)
          '${entry.value ? '✓' : '○'} ${entry.key}',
      ],
    );
  }
}
