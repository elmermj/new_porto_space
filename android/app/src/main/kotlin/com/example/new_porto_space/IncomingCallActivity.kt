import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragment

class IncomingCallActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val body = intent.getStringExtra("body")
        val channelName = intent.getStringExtra("channelName")
        val requesterName = intent.getStringExtra("requesterName")
        val fallbackToken = intent.getStringExtra("fallbackToken")

        if (savedInstanceState == null) {
            val args = Bundle().apply {
                putString("body", body)
                putString("channelName", channelName)
                putString("requesterName", requesterName)
                putString("fallbackToken", fallbackToken)
            }
            flutterEngine?.let {
                it.navigationChannel.pushRoute("/incoming_call?body=$body&channelName=$channelName&requesterName=$requesterName&fallbackToken=$fallbackToken")
            }
        }
    }

}
