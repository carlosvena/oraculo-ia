class LearnerProfile {
  const LearnerProfile({this.name='Carlos', this.level='Intermedio', this.interests=const ['IA aplicada','automatización','criterio tecnológico'], this.work='Supervisor bancario', this.intensive=true, this.priorities=const ['prompts profesionales','agentes','verificación'], this.difficulty='Exigente'});
  final String name, level, work, difficulty;
  final List<String> interests, priorities;
  final bool intensive;
}

String mentorAlternative(String concept) => 'Miremos $concept desde otro ángulo: identificá primero la entrada, luego la transformación y finalmente cómo verificarías el resultado.';
String mentorHardExample(String concept) => 'Ejemplo avanzado de $concept: aplicalo con información incompleta, dos fuentes contradictorias y una decisión que debe quedar auditada.';
String mentorWorkExample(String concept, LearnerProfile profile) => 'En tu trabajo como ${profile.work.toLowerCase()}, aplicá $concept a un informe de supervisión: protegé datos, citá la fuente y conservá la aprobación humana.';
