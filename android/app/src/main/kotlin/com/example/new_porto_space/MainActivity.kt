package com.example.new_porto_space

import MobileIncomingCallActivity
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.new_porto_space/incoming_call_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchIncomingCallActivity") {
                launchIncomingCallActivity(call.arguments as String)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchIncomingCallActivity(payload: String) {
        val json = JSONObject(payload)
        val channelName = json.getString("channelName")
        val requesterName = json.getString("requesterName")
        val fallbackToken = json.getString("fallbackToken")

        val intent = Intent(this, MobileIncomingCallActivity::class.java).apply {
            putExtra("channelName", channelName)
            putExtra("requesterName", requesterName)
            putExtra("fallbackToken", fallbackToken)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }
}