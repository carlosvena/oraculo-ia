import 'package:oraculo_ia/src/modules/learning_engine/learning_engine_models.dart';

/// Decide cuándo conviene revisar una habilidad o misión ya estudiada.
///
/// Recibe el tiempo explícitamente para ser determinista y comprobable. No crea
/// recordatorios, tareas del sistema ni efectos externos.
abstract interface class ReviewScheduler {
  DateTime? scheduleNextReview({
    required String skillId,
    required List<LearningEvidence> evidence,
    required DateTime now,
  });
}
