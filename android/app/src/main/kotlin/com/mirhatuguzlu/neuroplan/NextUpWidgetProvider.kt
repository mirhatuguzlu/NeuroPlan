package com.mirhatuguzlu.neuroplan

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * Ana ekran widget'ı: "Sıradaki: X · 14:30 · 15 dk sonra".
 * Veriyi ve metin kalıplarını (ARB'den) uygulama yazar; göreli süre burada hesaplanır,
 * tazeleme zamanlarını uygulama `HomeWidget.scheduleWidgetUpdates` ile kurar.
 */
class NextUpWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val now = System.currentTimeMillis()
        val items = try {
            JSONArray(widgetData.getString("next_items", "[]"))
        } catch (e: Exception) {
            JSONArray()
        }
        var title: String? = null
        var detail = ""
        for (i in 0 until items.length()) {
            val item = items.getJSONObject(i)
            val start = item.getLong("start")
            if (start < now - 60_000) continue
            title = item.getString("title")
            detail = item.getString("clock") + " · " + relative(widgetData, start, now)
            break
        }
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.next_up_widget).apply {
                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
                if (title == null) {
                    setTextViewText(R.id.widget_title, widgetData.getString("label_none", ""))
                    setViewVisibility(R.id.widget_detail, View.GONE)
                } else {
                    setTextViewText(
                        R.id.widget_title,
                        String.format(widgetData.getString("fmt_next", "%1\$s")!!, title),
                    )
                    setTextViewText(R.id.widget_detail, detail)
                    setViewVisibility(R.id.widget_detail, View.VISIBLE)
                }
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun relative(d: SharedPreferences, start: Long, now: Long): String {
        val minutes = ((start - now + 59_999) / 60_000).toInt()
        if (minutes <= 0) return d.getString("label_now", "")!!
        val h = minutes / 60
        val m = minutes % 60
        val duration = when {
            h == 0 -> String.format(d.getString("fmt_min", "%1\$d")!!, m)
            m == 0 -> String.format(d.getString("fmt_h", "%1\$d")!!, h)
            else -> String.format(d.getString("fmt_hm", "%1\$d %2\$d")!!, h, m)
        }
        return String.format(d.getString("fmt_in", "%1\$s")!!, duration)
    }
}
