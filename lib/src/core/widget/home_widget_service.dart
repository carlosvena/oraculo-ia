import 'package:home_widget/home_widget.dart';

/// Actualiza el widget de pantalla de inicio de Android con la racha,
/// una frase del día y el título de la próxima misión. Si el usuario
/// nunca agregó el widget a su pantalla, estas llamadas simplemente no
/// tienen ningún efecto visible (no rompen nada).
Future<void> updateHomeWidget({
  required int streakDays,
  required String quote,
  required String missionTitle,
}) async {
  try {
    final streakText =
        streakDays <= 0
            ? 'Empezá hoy tu racha'
            : streakDays == 1
            ? '1 día seguido'
            : '$streakDays días seguidos';
    await HomeWidget.saveWidgetData<String>('widget_streak', streakText);
    await HomeWidget.saveWidgetData<String>('widget_quote', quote);
    await HomeWidget.saveWidgetData<String>(
      'widget_mission_title',
      missionTitle,
    );
    await HomeWidget.updateWidget(androidName: 'OraculoWidgetProvider');
  } catch (_) {
    // Si el widget no está agregado, o el dispositivo no lo soporta,
    // no queremos que esto rompa el resto de la app.
  }
}
