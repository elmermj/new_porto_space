import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ChatRoomModel extends HiveObject {
  @HiveField(0)
  String? roomId;
  @HiveField(1)
  String? previewMessage;
  @HiveField(2)
  DateTime? lastSent;
  @HiveField(3)
  String? lastSenderEmail;
  @HiveField(4)
  int? unreadCount;
  @HiveField(5)
  String? lastSenderName;
  @HiveField(6)
  String? remoteName;
  @HiveField(7)
  String? remoteEmail;
  @HiveField(8)
  String? remoteDeviceToken;
  @HiveField(9)
  List<String>? profImageUrls;

  ChatRoomModel({
    this.roomId,
    this.previewMessage,
    this.lastSent,
    this.lastSenderEmail,
    this.unreadCount,
    this.lastSenderName,
    this.remoteName,
    this.remoteEmail,
    this.remoteDeviceToken,
    this.profImageUrls,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    previewMessage = json['previewMessage'];
    lastSent = json['lastSent'];
    lastSenderEmail = json['lastSenderId'];
    lastSenderName = json['lastSenderName'];
    remoteName = json['remoteName'];
    profImageUrls = json['profImageUrl'];
    unreadCount = json['unreadCount'];
    remoteEmail = json['remoteEmail'];
    remoteDeviceToken = json['remoteDeviceToken'];
  }
}