import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';
import 'package:oraculo_ia/src/modules/learning_engine/learning_strategy.dart';

/// Elige una misión entre candidatos ya considerados elegibles.
///
/// No carga contenido, no calcula progreso y no navega. Una implementación debe
/// devolver una decisión explicable y reproducible para el mismo contexto.
abstract interface class MissionSelector {
  LearningDecision select({
    required LearningContext context,
    required List<MissionCandidate> candidates,
    required LearningStrategy strategy,
  });
}
