import 'package:chatview/chatview.dart';
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
  String? lastSenderId;
  @HiveField(4)
  List<Message>? messages;
  @HiveField(5)
  String? lastSenderName;
  @HiveField(6)
  String? remoteName;
  @HiveField(7)
  List<String>? profImageUrls;
  @HiveField(8)
  List<String>? participantsEmails;

  ChatRoomModel({
    this.roomId,
    this.previewMessage,
    this.lastSent,
    this.lastSenderId,
    this.messages,
    this.lastSenderName,
    this.remoteName,
    this.profImageUrls
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    previewMessage = json['previewMessage'];
    lastSent = json['lastSent'];
    lastSenderId = json['lastSenderId'];
    lastSenderName = json['lastSenderName'];
    remoteName = json['remoteName'];
    profImageUrls = json['profImageUrl'];
    if (json['messages']!= null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }
}