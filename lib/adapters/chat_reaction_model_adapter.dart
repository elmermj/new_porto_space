import 'package:chatview/chatview.dart';
import 'package:hive/hive.dart';
import 'package:new_porto_space/utils/type_id.dart';

class ChatReactionModelAdapter extends TypeAdapter<Reaction> {
  @override
  final typeId = TypeID.chatReactionModel;

  @override
  Reaction read(BinaryReader reader) {
    return Reaction(
      reactions: reader.read(),
      reactedUserIds: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Reaction obj) {
    writer
     ..write(obj.reactions)
     ..write(obj.reactedUserIds);
  }

}