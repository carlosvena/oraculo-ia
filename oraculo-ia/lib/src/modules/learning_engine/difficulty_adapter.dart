import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';

/// Estima la dificultad adecuada a partir de evidencia de aprendizaje.
///
/// No altera misiones ni progreso. Devuelve una recomendación numérica que otro
/// componente puede aceptar, limitar o ignorar.
abstract interface class DifficultyAdapter {
  double recommendDifficulty({
    required double currentDifficulty,
    required List<LearningEvidence> evidence,
  });
}
