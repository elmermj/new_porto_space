import 'package:hive/hive.dart';
import 'package:new_porto_space/models/message_model.dart';

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
  List<MessageModel>? messages;

  ChatRoomModel({
    this.roomId,
    this.previewMessage,
    this.lastSent,
    this.lastSenderId,
    this.messages,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    previewMessage = json['previewMessage'];
    lastSent = json['lastSent'];
    lastSenderId = json['lastSenderId'];
    if (json['messages']!= null) {
      messages = <MessageModel>[];
      json['messages'].forEach((v) {
        messages!.add(MessageModel.fromJson(v));
      });
    }
  }
}