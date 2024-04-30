import 'package:hive/hive.dart';
import 'package:new_porto_space/models/chat_room_model.dart';
import 'package:new_porto_space/utils/type_id.dart';

class ChatRoomModelAdapter extends TypeAdapter<ChatRoomModel>{
  @override
  final typeId = TypeID.chatRoomModel;

  @override
  ChatRoomModel read(BinaryReader reader) {
    return ChatRoomModel(
      roomId: reader.read(),
      previewMessage: reader.read(),
      lastSent: reader.read(),
      lastSenderEmail: reader.read(),
      unreadCount: reader.read(),
      lastSenderName: reader.read(),
      remoteName: reader.read(),
      remoteEmail: reader.read(),
      remoteDeviceToken: reader.read(),
      profImageUrls: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomModel obj) {
    writer
      ..write(obj.roomId)
      ..write(obj.previewMessage)
      ..write(obj.lastSent)
      ..write(obj.lastSenderEmail)
      ..write(obj.unreadCount)
      ..write(obj.lastSenderName)
      ..write(obj.remoteName)
      ..write(obj.remoteEmail)
      ..write(obj.remoteDeviceToken)
      ..write(obj.profImageUrls);
  }
}