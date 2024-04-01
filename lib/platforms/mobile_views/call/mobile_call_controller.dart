import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';

class MobileCallController extends GetxController {
  late final RtcEngine engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;
  Set<int> remoteUid = {};
  late TextEditingController controller;
  bool isUseFlutterTexture = false;
  bool isUseAndroidSurfaceView = false;
  ChannelProfileType channelProfileType = ChannelProfileType.channelProfileCommunication1v1;
  late final RtcEngineEventHandler rtcEngineEventHandler;
  String? channelName;
  String? requesterName;
  String? fallbackToken;
  RxString roomToken = ''.obs;
  RxBool localUserJoin = false.obs;

  MobileCallController({this.channelName, this.requesterName, this.fallbackToken}){
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    logYellow("iniiiiit");
    controller = TextEditingController(text: channelName);
    dynamic args = Get.arguments;
    channelName = args[0];
    requesterName = args[1];
    fallbackToken = args[2];

    initEngine();
  }

  @override
  void onClose() {
    super.onClose();
    _dispose();
  }

  Future<void> _dispose() async {
    engine.unregisterEventHandler(rtcEngineEventHandler);
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> initEngine() async {
    engine = createAgoraRtcEngine();
    logYellow(engine.toString());
    await engine.initialize(RtcEngineContext(
      appId: APIURL.getAgoraAppID(),
    ));
    rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logRed('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logGreen('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        isJoined = true;
        update();
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logGreen('[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUid.add(rUid);
        update();
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logPink('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        remoteUid.removeWhere((element) => element == rUid);
        update();
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logRed('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        isJoined = false;
        remoteUid.clear();
        update();
      },
      onRemoteVideoStateChanged: (
          RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed) {
        logCyan('[onRemoteVideoStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
      },
    );

    engine.registerEventHandler(rtcEngineEventHandler);

    await engine.enableVideo();
    await engine.startPreview();
  }

  Future<void> joinChannel(String channelId, String token, int uid) async {
    await engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    openCamera = true;
    muteCamera = false;
    muteAllRemoteVideo = false;
    update();
  }

  Future<void> onSwitchCamera() async {
    await engine.switchCamera();
    switchCamera = !switchCamera;
    update();
  }

  Future<void> openOrCloseCamera() async {
    await engine.enableLocalVideo(!openCamera);
    openCamera = !openCamera;
    update();
  }
  
  Future<void> muteLocalVideoStream() async {
    await engine.muteLocalVideoStream(!muteCamera);
    muteCamera = !muteCamera;
    update();
  }

  Future<void> muteAllRemoteVideoStreams() async {
    await engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo);
    muteAllRemoteVideo = !muteAllRemoteVideo;
    update();
  }
}