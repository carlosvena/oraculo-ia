import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class LearnerProfile {
  const LearnerProfile({
    this.name = '',
    this.level = 'Intermedio',
    this.interests = const ['IA aplicada', 'automatización', 'criterio tecnológico'],
    this.work = '',
    this.intensive = true,
    this.priorities = const ['prompts profesionales', 'agentes', 'verificación'],
    this.difficulty = 'Exigente',
  });

  /// Construye el perfil a partir de lo que la persona guardó realmente en
  /// este dispositivo. Si todavía no completó su perfil, usa valores
  /// genéricos en vez de asumir un trabajo específico.
  factory LearnerProfile.fromState(LearningState state) => LearnerProfile(
    name: state.learnerName,
    work: state.learnerWork,
    intensive: state.mode == LearningMode.intensive,
  );

  final String name, level, work, difficulty;
  final List<String> interests, priorities;
  final bool intensive;

  bool get hasWork => work.trim().isNotEmpty;
  String get displayName => name.trim().isEmpty ? 'vos' : name.trim();
  String get workOrGeneric => hasWork ? work.trim() : 'tu trabajo';
}

String mentorAlternative(String concept) =>
    'Miremos $concept desde otro ángulo: identificá primero la entrada, luego la transformación y finalmente cómo verificarías el resultado.';

String mentorHardExample(String concept) =>
    'Ejemplo avanzado de $concept: aplicalo con información incompleta, dos fuentes contradictorias y una decisión que debe quedar auditada.';

String mentorWorkExample(String concept, LearnerProfile profile) {
  if (!profile.hasWork) {
    return 'Todavía no cargaste tu trabajo en tu perfil. Contámelo en '
        '"Progreso → Acerca de esta versión → Mi perfil" y voy a poder '
        'darte ejemplos de $concept aplicados específicamente a lo que hacés.';
  }
  return 'En tu trabajo (${profile.work}), aplicá $concept a una tarea real: '
      'protegé datos sensibles, citá la fuente de la información y conservá '
      'una aprobación humana antes de actuar sobre el resultado.';
}
