import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'ORÁCULO IA'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Aprender IA puede ser simple.'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In es, this message translates to:
  /// **'Cada día recibirás una misión clara y breve. Sin ruido. Sin perderte. Siempre sabrás qué aprender hoy.'**
  String get welcomeBody;

  /// No description provided for @start.
  ///
  /// In es, this message translates to:
  /// **'EMPEZAR'**
  String get start;

  /// No description provided for @onboardingSaveError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar tu progreso.'**
  String get onboardingSaveError;

  /// No description provided for @todayMission.
  ///
  /// In es, this message translates to:
  /// **'Mi misión de hoy'**
  String get todayMission;

  /// No description provided for @mentorGreeting.
  ///
  /// In es, this message translates to:
  /// **'Buenos días Carlos.'**
  String get mentorGreeting;

  /// No description provided for @mentorJourney.
  ///
  /// In es, this message translates to:
  /// **'Hoy comenzamos un viaje para aprender Inteligencia Artificial.'**
  String get mentorJourney;

  /// No description provided for @mentorSingleMission.
  ///
  /// In es, this message translates to:
  /// **'Tu única misión de hoy es completar la Misión 001.'**
  String get mentorSingleMission;

  /// No description provided for @defaultMissionTitle.
  ///
  /// In es, this message translates to:
  /// **'Entender qué es un modelo de IA'**
  String get defaultMissionTitle;

  /// No description provided for @continueMission.
  ///
  /// In es, this message translates to:
  /// **'CONTINUAR MI MISIÓN'**
  String get continueMission;

  /// No description provided for @missionStatusNotStarted.
  ///
  /// In es, this message translates to:
  /// **'No iniciada'**
  String get missionStatusNotStarted;

  /// No description provided for @missionStatusInProgress.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get missionStatusInProgress;

  /// No description provided for @missionStatusCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get missionStatusCompleted;

  /// No description provided for @estimatedTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo estimado: {minutes} min'**
  String estimatedTime(int minutes);

  /// No description provided for @elapsedTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo empleado: {minutes} min (simulado)'**
  String elapsedTime(int minutes);

  /// No description provided for @missionProgressLabel.
  ///
  /// In es, this message translates to:
  /// **'Progreso de la misión'**
  String get missionProgressLabel;

  /// No description provided for @nextActionStart.
  ///
  /// In es, this message translates to:
  /// **'Comenzá con el objetivo y avanzá bloque por bloque.'**
  String get nextActionStart;

  /// No description provided for @nextActionContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuá desde tu misión actual.'**
  String get nextActionContinue;

  /// No description provided for @nextActionCompleted.
  ///
  /// In es, this message translates to:
  /// **'Misión completada. Podés repasarla cuando quieras.'**
  String get nextActionCompleted;

  /// No description provided for @missionLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tu misión.'**
  String get missionLoadError;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'REINTENTAR'**
  String get retry;

  /// No description provided for @explanationTitle.
  ///
  /// In es, this message translates to:
  /// **'Explicación'**
  String get explanationTitle;

  /// No description provided for @whyItMattersTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué esto importa?'**
  String get whyItMattersTitle;

  /// No description provided for @contextTitle.
  ///
  /// In es, this message translates to:
  /// **'Contexto'**
  String get contextTitle;

  /// No description provided for @conceptTitle.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get conceptTitle;

  /// No description provided for @examplesTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejemplos'**
  String get examplesTitle;

  /// No description provided for @laboratoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Laboratorio'**
  String get laboratoryTitle;

  /// No description provided for @challengeTitle.
  ///
  /// In es, this message translates to:
  /// **'Desafío'**
  String get challengeTitle;

  /// No description provided for @debateTitle.
  ///
  /// In es, this message translates to:
  /// **'Debate'**
  String get debateTitle;

  /// No description provided for @toolsTitle.
  ///
  /// In es, this message translates to:
  /// **'Herramientas'**
  String get toolsTitle;

  /// No description provided for @commonMistakeTitle.
  ///
  /// In es, this message translates to:
  /// **'Error común'**
  String get commonMistakeTitle;

  /// No description provided for @executiveSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen ejecutivo'**
  String get executiveSummaryTitle;

  /// No description provided for @nextStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Siguiente paso'**
  String get nextStepTitle;

  /// No description provided for @exampleTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo'**
  String get exampleTitle;

  /// No description provided for @exerciseTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejercicio'**
  String get exerciseTitle;

  /// No description provided for @summaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get summaryTitle;

  /// No description provided for @objectiveTitle.
  ///
  /// In es, this message translates to:
  /// **'Objetivo'**
  String get objectiveTitle;

  /// No description provided for @miniAssessmentTitle.
  ///
  /// In es, this message translates to:
  /// **'Mini evaluación'**
  String get miniAssessmentTitle;

  /// No description provided for @temporaryContentLabel.
  ///
  /// In es, this message translates to:
  /// **'Contenido temporal para evaluar la experiencia de aprendizaje.'**
  String get temporaryContentLabel;

  /// No description provided for @exerciseQuestion.
  ///
  /// In es, this message translates to:
  /// **'Para entrenar un modelo que detecte spam, ¿qué información sería más útil?'**
  String get exerciseQuestion;

  /// No description provided for @exerciseOptionOne.
  ///
  /// In es, this message translates to:
  /// **'El color favorito del usuario.'**
  String get exerciseOptionOne;

  /// No description provided for @exerciseOptionTwo.
  ///
  /// In es, this message translates to:
  /// **'Ejemplos de correos marcados como spam y como válidos.'**
  String get exerciseOptionTwo;

  /// No description provided for @exerciseOptionThree.
  ///
  /// In es, this message translates to:
  /// **'La hora actual.'**
  String get exerciseOptionThree;

  /// No description provided for @exerciseCorrect.
  ///
  /// In es, this message translates to:
  /// **'Muy bien. El modelo necesita ejemplos relacionados con la tarea que debe aprender.'**
  String get exerciseCorrect;

  /// No description provided for @exerciseTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Esa información no le enseña a distinguir spam. Probá con otra opción.'**
  String get exerciseTryAgain;

  /// No description provided for @quizQuestionOne.
  ///
  /// In es, this message translates to:
  /// **'¿Qué aprende un modelo de IA a partir de ejemplos?'**
  String get quizQuestionOne;

  /// No description provided for @quizOneOptionOne.
  ///
  /// In es, this message translates to:
  /// **'Patrones.'**
  String get quizOneOptionOne;

  /// No description provided for @quizOneOptionTwo.
  ///
  /// In es, this message translates to:
  /// **'Contraseñas.'**
  String get quizOneOptionTwo;

  /// No description provided for @quizOneOptionThree.
  ///
  /// In es, this message translates to:
  /// **'Reglas secretas de Internet.'**
  String get quizOneOptionThree;

  /// No description provided for @quizQuestionTwo.
  ///
  /// In es, this message translates to:
  /// **'¿Para qué puede usar un modelo los patrones aprendidos?'**
  String get quizQuestionTwo;

  /// No description provided for @quizTwoOptionOne.
  ///
  /// In es, this message translates to:
  /// **'Para responder o clasificar casos nuevos.'**
  String get quizTwoOptionOne;

  /// No description provided for @quizTwoOptionTwo.
  ///
  /// In es, this message translates to:
  /// **'Sólo para repetir los ejemplos originales.'**
  String get quizTwoOptionTwo;

  /// No description provided for @quizTwoOptionThree.
  ///
  /// In es, this message translates to:
  /// **'Para garantizar respuestas perfectas.'**
  String get quizTwoOptionThree;

  /// No description provided for @quizQuestionThree.
  ///
  /// In es, this message translates to:
  /// **'¿Qué influye en la calidad de las respuestas de un modelo?'**
  String get quizQuestionThree;

  /// No description provided for @quizThreeOptionOne.
  ///
  /// In es, this message translates to:
  /// **'El nombre de la aplicación.'**
  String get quizThreeOptionOne;

  /// No description provided for @quizThreeOptionTwo.
  ///
  /// In es, this message translates to:
  /// **'La hora del dispositivo.'**
  String get quizThreeOptionTwo;

  /// No description provided for @quizThreeOptionThree.
  ///
  /// In es, this message translates to:
  /// **'Los ejemplos aprendidos y la información recibida.'**
  String get quizThreeOptionThree;

  /// No description provided for @quizCorrect.
  ///
  /// In es, this message translates to:
  /// **'Respuesta correcta.'**
  String get quizCorrect;

  /// No description provided for @quizTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Revisá la explicación e intentá nuevamente.'**
  String get quizTryAgain;

  /// No description provided for @quizProgress.
  ///
  /// In es, this message translates to:
  /// **'{answered} de 3 respuestas correctas'**
  String quizProgress(int answered);

  /// No description provided for @assessmentOptionOne.
  ///
  /// In es, this message translates to:
  /// **'Memoriza siempre una única respuesta.'**
  String get assessmentOptionOne;

  /// No description provided for @assessmentOptionTwo.
  ///
  /// In es, this message translates to:
  /// **'Aprende patrones y los aplica a casos nuevos.'**
  String get assessmentOptionTwo;

  /// No description provided for @assessmentOptionThree.
  ///
  /// In es, this message translates to:
  /// **'Busca todas sus respuestas en Internet.'**
  String get assessmentOptionThree;

  /// No description provided for @assessmentCorrect.
  ///
  /// In es, this message translates to:
  /// **'Exacto. Un modelo aprende patrones para trabajar con situaciones nuevas.'**
  String get assessmentCorrect;

  /// No description provided for @assessmentTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Casi. Volvé a leer la explicación y probá otra vez.'**
  String get assessmentTryAgain;

  /// No description provided for @completeMission.
  ///
  /// In es, this message translates to:
  /// **'MISIÓN COMPLETADA'**
  String get completeMission;

  /// No description provided for @lessonLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la lección.'**
  String get lessonLoadError;

  /// No description provided for @missionCompleteError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar la misión.'**
  String get missionCompleteError;

  /// No description provided for @progressTitle.
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get progressTitle;

  /// No description provided for @congratulations.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente trabajo!'**
  String get congratulations;

  /// No description provided for @missionCompletedMessage.
  ///
  /// In es, this message translates to:
  /// **'Completaste la Misión 001.'**
  String get missionCompletedMessage;

  /// No description provided for @xpEarned.
  ///
  /// In es, this message translates to:
  /// **'+{xp} XP'**
  String xpEarned(int xp);

  /// No description provided for @nextMission.
  ///
  /// In es, this message translates to:
  /// **'Misión 002'**
  String get nextMission;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @levelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get levelLabel;

  /// No description provided for @levelValue.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level}'**
  String levelValue(int level);

  /// No description provided for @streakLabel.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get streakLabel;

  /// No description provided for @streakValue.
  ///
  /// In es, this message translates to:
  /// **'{days} día'**
  String streakValue(int days);

  /// No description provided for @completedMissions.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Todavía no completaste misiones.} =1{Completaste 1 misión.} other{Completaste {count} misiones.}}'**
  String completedMissions(int count);

  /// No description provided for @backToMission.
  ///
  /// In es, this message translates to:
  /// **'CONTINUAR MI MISIÓN'**
  String get backToMission;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
