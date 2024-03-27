import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/secret_url.dart';

class MobileVideoCallViewController extends GetxController {
    late final RtcEngine _engine;

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
  late RtcEngine engine;
  final String channelName;
  final String remoteUID;
  final String localUID;
  RxString roomToken = ''.obs;
  RxBool localUserJoin = false.obs;

  MobileVideoCallViewController({required this.channelName, required this.remoteUID, required this.localUID});

  @override
  void onInit() {
    super.onInit();
    controller = TextEditingController(text: channelName);

    _initEngine();
  }

  @override
  void onClose() {
    super.onClose();
    _dispose();
  }

  Future<void> _dispose() async {
    _engine.unregisterEventHandler(rtcEngineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
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

    _engine.registerEventHandler(rtcEngineEventHandler);

    await _engine.enableVideo();
    await _engine.startPreview();
  }

  Future<void> joinChannel(String channelId, String token, int uid) async {
    await _engine.joinChannel(
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
    await _engine.leaveChannel();
    openCamera = true;
    muteCamera = false;
    muteAllRemoteVideo = false;
    update();
  }

  Future<void> onSwitchCamera() async {
    await _engine.switchCamera();
    switchCamera = !switchCamera;
    update();
  }

  Future<void> openOrCloseCamera() async {
    await _engine.enableLocalVideo(!openCamera);
    openCamera = !openCamera;
    update();
  }
  
  Future<void> muteLocalVideoStream() async {
    await _engine.muteLocalVideoStream(!muteCamera);
    muteCamera = !muteCamera;
    update();
  }

  Future<void> muteAllRemoteVideoStreams() async {
    await _engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo);
    muteAllRemoteVideo = !muteAllRemoteVideo;
    update();
  }
}