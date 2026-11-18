package com.mirhatuguzlu.neuroplan

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.dexterous.flutterlocalnotifications.ForegroundService

/**
 * Kaçış uyarısı (DECISIONS D35): 10 sn geri sayan heads-up bildirimi; süre dolunca aynı
 * kimlikle "Odak bozuldu" bildirimi, kalıcı odak bildirimi kapanır, Rahatsız Etmeyin geri
 * yüklenir. Süreç düzeyindedir: uygulama son uygulamalardan süpürülüp Flutter motoru ölse de
 * ön plan servisi süreci canlı tuttuğu sürece süre dolunca çalışır.
 */
object FocusAlert {
    private const val ALERT_ID = 901
    private val handler = Handler(Looper.getMainLooper())
    private var pending: Runnable? = null

    fun show(
        context: Context,
        deadlineMs: Long,
        channelId: String,
        title: String,
        body: String,
        brokenTitle: String,
        brokenBody: String,
    ) {
        cancel(context)
        val app = context.applicationContext
        notify(
            app,
            builder(app, channelId, title, body)
                .setUsesChronometer(true)
                .setChronometerCountDown(true)
                .setWhen(deadlineMs)
                .setShowWhen(true)
                .setVibrate(longArrayOf(0, 400, 200, 400))
                .build(),
        )
        val broken = Runnable {
            pending = null
            notify(app, builder(app, channelId, brokenTitle, brokenBody).build())
            app.stopService(Intent(app, ForegroundService::class.java))
            Dnd.restore(app)
        }
        pending = broken
        handler.postDelayed(broken, (deadlineMs - System.currentTimeMillis()).coerceAtLeast(0))
    }

    fun cancel(context: Context) {
        pending?.let(handler::removeCallbacks)
        pending = null
        NotificationManagerCompat.from(context).cancel(ALERT_ID)
    }

    private fun builder(context: Context, channelId: String, title: String, body: String) =
        NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setContentIntent(launch(context))

    private fun launch(context: Context): PendingIntent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: return null
        return PendingIntent.getActivity(
            context,
            ALERT_ID,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
    }

    private fun notify(context: Context, notification: android.app.Notification) {
        val manager = context.getSystemService(NotificationManager::class.java)
        // Bildirim izni yoksa sessizce geçilir; kural yine Dart tarafında işler.
        if (!manager.areNotificationsEnabled()) return
        try {
            NotificationManagerCompat.from(context).notify(ALERT_ID, notification)
        } catch (_: SecurityException) {
        }
    }
}

/** Odakta Rahatsız Etmeyin; önceki filtre burada saklanır ki Dart ölse de geri yüklensin. */
object Dnd {
    private const val PREFS = "neuroplan_focus"
    private const val KEY = "dnd_prev"

    fun enable(context: Context): Boolean {
        val manager = context.getSystemService(NotificationManager::class.java)
        if (!manager.isNotificationPolicyAccessGranted) return false
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        if (!prefs.contains(KEY)) {
            prefs.edit().putInt(KEY, manager.currentInterruptionFilter).apply()
        }
        manager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
        return true
    }

    fun restore(context: Context) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        if (!prefs.contains(KEY)) return
        val previous = prefs.getInt(KEY, NotificationManager.INTERRUPTION_FILTER_ALL)
        prefs.edit().remove(KEY).apply()
        val manager = context.getSystemService(NotificationManager::class.java)
        if (!manager.isNotificationPolicyAccessGranted) return
        manager.setInterruptionFilter(
            if (previous == NotificationManager.INTERRUPTION_FILTER_UNKNOWN) {
                NotificationManager.INTERRUPTION_FILTER_ALL
            } else {
                previous
            },
        )
    }
}
