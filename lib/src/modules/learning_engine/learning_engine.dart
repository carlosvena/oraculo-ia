import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';

export 'package:oraculo_ia/src/modules/learning_engine/curiosity_engine.dart';
export 'package:oraculo_ia/src/modules/learning_engine/difficulty_adapter.dart';
export 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';
export 'package:oraculo_ia/src/modules/learning_engine/learning_strategy.dart';
export 'package:oraculo_ia/src/modules/learning_engine/mission_selector.dart';
export 'package:oraculo_ia/src/modules/learning_engine/review_scheduler.dart';

/// Fachada del sistema de decisiones pedagógicas.
///
/// Coordina una decisión sin exponer qué estrategia, selector o adaptador la
/// produjo. Los consumidores dependen de este contrato, nunca de una implementación.
abstract interface class LearningEngine {
  Future<LearningDecision> decideNextMission({
    required LearningContext context,
    required List<MissionCandidate> candidates,
  });
}
