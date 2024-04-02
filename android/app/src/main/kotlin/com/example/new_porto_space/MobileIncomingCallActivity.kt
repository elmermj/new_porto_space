import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MobileIncomingCallActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val channelName = intent.getStringExtra("channelName") ?: ""
        val requesterName = intent.getStringExtra("requesterName") ?: ""
        val fallbackToken = intent.getStringExtra("fallbackToken") ?: ""

        val initialRoute = "/incoming_call?channelName=$channelName&requesterName=$requesterName&fallbackToken=$fallbackToken"
        flutterEngine?.navigationChannel?.pushRoute(initialRoute)
    }
}
