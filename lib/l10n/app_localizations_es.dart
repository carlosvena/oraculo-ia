// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'ORÁCULO IA';

  @override
  String get welcomeTitle => 'Aprender IA puede ser simple.';

  @override
  String get welcomeBody =>
      'Cada día recibirás una misión clara y breve. Sin ruido. Sin perderte. Siempre sabrás qué aprender hoy.';

  @override
  String get start => 'EMPEZAR';

  @override
  String get onboardingSaveError => 'No pudimos guardar tu progreso.';

  @override
  String get todayMission => 'Mi misión de hoy';

  @override
  String get mentorGreeting => 'Buenos días Carlos.';

  @override
  String get mentorJourney =>
      'Hoy comenzamos un viaje para aprender Inteligencia Artificial.';

  @override
  String get mentorSingleMission =>
      'Tu única misión de hoy es completar la Misión 001.';

  @override
  String get defaultMissionTitle => 'Entender qué es un modelo de IA';

  @override
  String get continueMission => 'CONTINUAR MI MISIÓN';

  @override
  String get missionStatusNotStarted => 'No iniciada';

  @override
  String get missionStatusInProgress => 'En progreso';

  @override
  String get missionStatusCompleted => 'Completada';

  @override
  String estimatedTime(int minutes) {
    return 'Tiempo estimado: $minutes min';
  }

  @override
  String elapsedTime(int minutes) {
    return 'Tiempo empleado: $minutes min (simulado)';
  }

  @override
  String get missionProgressLabel => 'Progreso de la misión';

  @override
  String get nextActionStart =>
      'Comenzá con el objetivo y avanzá bloque por bloque.';

  @override
  String get nextActionContinue => 'Continuá desde tu misión actual.';

  @override
  String get nextActionCompleted =>
      'Misión completada. Podés repasarla cuando quieras.';

  @override
  String get missionLoadError => 'No pudimos cargar tu misión.';

  @override
  String get retry => 'REINTENTAR';

  @override
  String get explanationTitle => 'Explicación';

  @override
  String get whyItMattersTitle => '¿Por qué esto importa?';

  @override
  String get contextTitle => 'Contexto';

  @override
  String get conceptTitle => 'Concepto';

  @override
  String get examplesTitle => 'Ejemplos';

  @override
  String get laboratoryTitle => 'Laboratorio';

  @override
  String get challengeTitle => 'Desafío';

  @override
  String get debateTitle => 'Debate';

  @override
  String get toolsTitle => 'Herramientas';

  @override
  String get commonMistakeTitle => 'Error común';

  @override
  String get executiveSummaryTitle => 'Resumen ejecutivo';

  @override
  String get nextStepTitle => 'Siguiente paso';

  @override
  String get exampleTitle => 'Ejemplo';

  @override
  String get exerciseTitle => 'Ejercicio';

  @override
  String get summaryTitle => 'Resumen';

  @override
  String get objectiveTitle => 'Objetivo';

  @override
  String get miniAssessmentTitle => 'Mini evaluación';

  @override
  String get temporaryContentLabel =>
      'Contenido temporal para evaluar la experiencia de aprendizaje.';

  @override
  String get exerciseQuestion =>
      'Para entrenar un modelo que detecte spam, ¿qué información sería más útil?';

  @override
  String get exerciseOptionOne => 'El color favorito del usuario.';

  @override
  String get exerciseOptionTwo =>
      'Ejemplos de correos marcados como spam y como válidos.';

  @override
  String get exerciseOptionThree => 'La hora actual.';

  @override
  String get exerciseCorrect =>
      'Muy bien. El modelo necesita ejemplos relacionados con la tarea que debe aprender.';

  @override
  String get exerciseTryAgain =>
      'Esa información no le enseña a distinguir spam. Probá con otra opción.';

  @override
  String get quizQuestionOne =>
      '¿Qué aprende un modelo de IA a partir de ejemplos?';

  @override
  String get quizOneOptionOne => 'Patrones.';

  @override
  String get quizOneOptionTwo => 'Contraseñas.';

  @override
  String get quizOneOptionThree => 'Reglas secretas de Internet.';

  @override
  String get quizQuestionTwo =>
      '¿Para qué puede usar un modelo los patrones aprendidos?';

  @override
  String get quizTwoOptionOne => 'Para responder o clasificar casos nuevos.';

  @override
  String get quizTwoOptionTwo => 'Sólo para repetir los ejemplos originales.';

  @override
  String get quizTwoOptionThree => 'Para garantizar respuestas perfectas.';

  @override
  String get quizQuestionThree =>
      '¿Qué influye en la calidad de las respuestas de un modelo?';

  @override
  String get quizThreeOptionOne => 'El nombre de la aplicación.';

  @override
  String get quizThreeOptionTwo => 'La hora del dispositivo.';

  @override
  String get quizThreeOptionThree =>
      'Los ejemplos aprendidos y la información recibida.';

  @override
  String get quizCorrect => 'Respuesta correcta.';

  @override
  String get quizTryAgain => 'Revisá la explicación e intentá nuevamente.';

  @override
  String quizProgress(int answered) {
    return '$answered de 3 respuestas correctas';
  }

  @override
  String get assessmentOptionOne => 'Memoriza siempre una única respuesta.';

  @override
  String get assessmentOptionTwo =>
      'Aprende patrones y los aplica a casos nuevos.';

  @override
  String get assessmentOptionThree => 'Busca todas sus respuestas en Internet.';

  @override
  String get assessmentCorrect =>
      'Exacto. Un modelo aprende patrones para trabajar con situaciones nuevas.';

  @override
  String get assessmentTryAgain =>
      'Casi. Volvé a leer la explicación y probá otra vez.';

  @override
  String get completeMission => 'MISIÓN COMPLETADA';

  @override
  String get lessonLoadError => 'No pudimos cargar la lección.';

  @override
  String get missionCompleteError => 'No pudimos completar la misión.';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get congratulations => '¡Excelente trabajo!';

  @override
  String get missionCompletedMessage => 'Completaste la Misión 001.';

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String get nextMission => 'Misión 002';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get levelLabel => 'Nivel';

  @override
  String levelValue(int level) {
    return 'Nivel $level';
  }

  @override
  String get streakLabel => 'Racha';

  @override
  String streakValue(int days) {
    return '$days día';
  }

  @override
  String completedMissions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Completaste $count misiones.',
      one: 'Completaste 1 misión.',
      zero: 'Todavía no completaste misiones.',
    );
    return '$_temp0';
  }

  @override
  String get backToMission => 'CONTINUAR MI MISIÓN';
}
