import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final int typeId = 101; // Unique identifier for this type adapter

  @override
  Timestamp read(BinaryReader reader) {
    final secondsSinceEpoch = reader.readInt();
    final nanoseconds = reader.readInt();
    return Timestamp(secondsSinceEpoch, nanoseconds);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.seconds);
    writer.writeInt(obj.nanoseconds);
  }
}
