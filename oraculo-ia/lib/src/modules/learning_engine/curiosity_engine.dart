import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';

/// Propone desvíos opcionales relevantes sin reemplazar la misión principal.
///
/// Su salida es una sugerencia ordenable. Nunca cambia la misión actual ni introduce
/// una segunda acción primaria por sí mismo.
abstract interface class CuriosityEngine {
  List<CuriosityOpportunity> suggest({
    required LearningContext context,
    required List<MissionCandidate> candidates,
  });
}
