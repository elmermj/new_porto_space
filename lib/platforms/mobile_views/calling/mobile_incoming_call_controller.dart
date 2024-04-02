import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/platforms/mobile_views/call/use_cases/cancel_call.dart';
import 'package:new_porto_space/platforms/mobile_views/home/mobile_home_view.dart';

class MobileIncomingCallController extends GetxController {
  
  String? channelName;
  String? requesterName;
  String? fallbackToken;
  bool? isBackground;
  bool _isPlaying = false;
  late dynamic delayed;
  RxInt repeatCount = 0.obs; 
  AudioPlayer audioPlayer = AudioPlayer();

  MobileIncomingCallController({this.channelName, this.requesterName, this.fallbackToken, this.isBackground}){
    onInit();
  }

  @override
  onInit() async {
    super.onInit();
    logYellow("MobileIncomingCallController init");
    final arguments = Get.arguments;
    channelName = arguments[0];
    requesterName = arguments[1];
    fallbackToken = arguments[2];
    isBackground = arguments[3];
    logPink(channelName!);
    logPink(requesterName!);
    logPink(fallbackToken!);
    playAudio();
  }

  Future<void> playAudio() async {
    _isPlaying = true;
    for (;repeatCount.value < 120; repeatCount.value++) {
      await audioPlayer.play(
        AssetSource('sounds/incoming_call_bell.wav'),
        volume: 1.0,
      );
      logGreen('REPEATED ::: ${repeatCount+1} TIMES');
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!_isPlaying) break;
    }
  }

  void stopAudio() {
    _isPlaying = false;
    audioPlayer.stop();
  }

  @override
  Future<void> onClose() async {
    repeatCount.value = 120;
    logYellow("MobileIncomingCallController close");
    stopAudio();
    CancelCall(
      remoteDeviceToken: fallbackToken!, 
      channelName: channelName!
    );
    if(isBackground == true){
      Get.offAll(()=>MobileHomeView());
    }else{
      Get.back();
    }
    super.onClose();
  }
}