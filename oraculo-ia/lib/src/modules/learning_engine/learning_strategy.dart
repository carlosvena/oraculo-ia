import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';

/// Política intercambiable que prioriza candidatos según objetivos pedagógicos.
///
/// No elige directamente ni modifica estado. Sólo puntúa, lo que permite comparar,
/// probar y versionar estrategias sin cambiar el motor o el selector.
abstract interface class LearningStrategy {
  String get id;

  double score({
    required LearningContext context,
    required MissionCandidate candidate,
  });
}
