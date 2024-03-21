import 'package:hive/hive.dart';
import 'package:new_porto_space/models/message_model.dart';

@HiveType(typeId: 2)
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

class ChatRoomModelAdapter extends TypeAdapter<ChatRoomModel>{
  @override
  final typeId = 0;

  @override
  ChatRoomModel read(BinaryReader reader) {
    return ChatRoomModel(
      roomId: reader.read(),
      previewMessage: reader.read(),
      lastSent: reader.read(),
      lastSenderId: reader.read(),
      messages: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomModel obj) {
    writer
      ..write(obj.roomId)
      ..write(obj.previewMessage)
      ..write(obj.lastSent)
      ..write(obj.lastSenderId)
      ..write(obj.messages);
  }
}