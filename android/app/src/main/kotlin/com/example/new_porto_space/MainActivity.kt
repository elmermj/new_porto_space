package com.example.new_porto_space

import IncomingCallActivity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "incoming_call_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "incoming_call_channel").setMethodCallHandler { call, result ->
            if (call.method == "startIncomingCallActivity") {
                val body = call.argument<String>("body")
                val channelName = call.argument<String>("channelName")
                val requesterName = call.argument<String>("requesterName")
                val fallbackToken = call.argument<String>("fallbackToken")
                startIncomingCallActivity(body, channelName, requesterName, fallbackToken)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startIncomingCallActivity(
        body: String?,
        channelName: String?,
        requesterName: String?,
        fallbackToken: String?
    ) {
        val intent = Intent(applicationContext, IncomingCallActivity::class.java)
        intent.putExtra("body", body)
        intent.putExtra("channelName", channelName)
        intent.putExtra("requesterName", requesterName)
        intent.putExtra("fallbackToken", fallbackToken)
        startActivity(intent)
    }
}