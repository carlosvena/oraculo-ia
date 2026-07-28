package com.carlosvena.oraculoia

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget de pantalla de inicio: muestra la racha, una frase del día y un
 * acceso directo para continuar la misión. Los datos los escribe el lado
 * Flutter (ver lib/src/core/widget/home_widget_service.dart) y acá solo
 * los leemos y los pintamos.
 */
class OraculoWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.oraculo_widget_layout).apply {
                setTextViewText(
                    R.id.widget_streak,
                    widgetData.getString("widget_streak", "Sin racha todavía"),
                )
                setTextViewText(
                    R.id.widget_quote,
                    widgetData.getString("widget_quote", "Abrí la app para empezar tu recorrido."),
                )
                setTextViewText(
                    R.id.widget_mission_title,
                    widgetData.getString("widget_mission_title", "CONTINUAR MI MISIÓN"),
                )

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
