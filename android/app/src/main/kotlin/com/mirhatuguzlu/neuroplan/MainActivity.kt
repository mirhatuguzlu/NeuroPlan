package com.mirhatuguzlu.neuroplan

import android.Manifest
import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Odak oturumunun Android köprüsü (DECISIONS D33, D35). Dart'taki `AndroidFocusPlatform`
 * bu kanalları kullanır; iş kuralı burada yoktur, yalnız cihaz olayları ve sistem çağrıları.
 */
class MainActivity : FlutterActivity() {
    private var events: EventChannel.EventSink? = null
    private var receiver: BroadcastReceiver? = null
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "neuroplan/focus").setMethodCallHandler { call, result ->
            when (call.method) {
                "env" -> result.success(
                    BuildConfig.ENV.associate { it.substringBefore('=') to it.substringAfter('=') },
                )
                "deviceState" -> result.success(deviceState())
                "phonePermission" -> result.success(hasPhonePermission())
                "requestPhonePermission" ->
                    if (hasPhonePermission()) {
                        result.success(true)
                    } else {
                        permissionResult?.success(false)
                        permissionResult = result
                        requestPermissions(arrayOf(Manifest.permission.READ_PHONE_STATE), PHONE_REQUEST)
                    }
                "openNotificationSettings" -> {
                    startActivity(
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        } else {
                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                .setData(Uri.fromParts("package", packageName, null))
                        },
                    )
                    result.success(null)
                }
                "enableDnd" -> result.success(Dnd.enable(this))
                "restoreDnd" -> {
                    Dnd.restore(this)
                    result.success(null)
                }
                "escapeAlert" -> {
                    FocusAlert.show(
                        this,
                        call.argument<Number>("deadline")!!.toLong(),
                        call.argument("channel")!!,
                        call.argument("title")!!,
                        call.argument("body")!!,
                        call.argument("brokenTitle")!!,
                        call.argument("brokenBody")!!,
                    )
                    result.success(null)
                }
                "clearEscapeAlert" -> {
                    FocusAlert.cancel(this)
                    result.success(null)
                }
                // Uygulama sabitleme (D36): sistem onay ister; kullanıcı bir hareketle çıkabilir.
                "pin" -> {
                    try {
                        if (!isPinned()) startLockTask()
                    } catch (_: Exception) {
                    }
                    result.success(null)
                }
                "unpin" -> {
                    try {
                        if (isPinned()) stopLockTask()
                    } catch (_: Exception) {
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        EventChannel(messenger, "neuroplan/focus_events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
                    events = sink
                    register()
                }

                override fun onCancel(arguments: Any?) {
                    unregister()
                    events = null
                }
            },
        )
    }

    /** Bildirim paneli çekilince pencere odağı gider; uygulama arka plana geçmez. */
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        events?.success(if (hasFocus) "focus_gained" else "focus_lost")
    }

    override fun onDestroy() {
        unregister()
        super.onDestroy()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != PHONE_REQUEST) return
        permissionResult?.success(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
        permissionResult = null
        // İzin şimdi verildiyse arama olaylarının da gelmesi için alıcı yeniden kurulur.
        if (events != null) {
            unregister()
            register()
        }
    }

    private fun isPinned() =
        getSystemService(ActivityManager::class.java).lockTaskModeState !=
            ActivityManager.LOCK_TASK_MODE_NONE

    private fun hasPhonePermission() =
        ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) ==
            PackageManager.PERMISSION_GRANTED

    private fun deviceState(): Map<String, Any?> {
        val audio = getSystemService(AudioManager::class.java)
        val inCall = if (hasPhonePermission()) {
            try {
                @Suppress("DEPRECATION")
                getSystemService(TelephonyManager::class.java).callState !=
                    TelephonyManager.CALL_STATE_IDLE
            } catch (_: SecurityException) {
                null
            }
        } else {
            null
        }
        return mapOf(
            "interactive" to getSystemService(PowerManager::class.java).isInteractive,
            "locked" to getSystemService(KeyguardManager::class.java).isKeyguardLocked,
            "inCall" to inCall,
            // İzinsiz ipucu: telefon ya da internet araması ses modunu değiştirir.
            "audioCall" to (
                audio.mode == AudioManager.MODE_IN_CALL ||
                    audio.mode == AudioManager.MODE_IN_COMMUNICATION ||
                    audio.mode == AudioManager.MODE_RINGTONE
                ),
        )
    }

    private fun register() {
        if (receiver != null) return
        val r = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val event = when (intent.action) {
                    Intent.ACTION_SCREEN_OFF -> "screen_off"
                    Intent.ACTION_SCREEN_ON -> "screen_on"
                    Intent.ACTION_USER_PRESENT -> "unlocked"
                    TelephonyManager.ACTION_PHONE_STATE_CHANGED ->
                        when (intent.getStringExtra(TelephonyManager.EXTRA_STATE)) {
                            TelephonyManager.EXTRA_STATE_IDLE -> "call_idle"
                            null -> null
                            else -> "call_active"
                        }
                    else -> null
                }
                if (event != null) events?.success(event)
            }
        }
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_USER_PRESENT)
            // Yalnız READ_PHONE_STATE verildiyse teslim edilir.
            if (hasPhonePermission()) addAction(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
        }
        ContextCompat.registerReceiver(this, r, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
        receiver = r
    }

    private fun unregister() {
        receiver?.let { unregisterReceiver(it) }
        receiver = null
    }

    private companion object {
        const val PHONE_REQUEST = 7201
    }
}
