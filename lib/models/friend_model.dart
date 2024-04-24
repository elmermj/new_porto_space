import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 201)
class FriendModel extends HiveObject {
  @HiveField(0)
  String friendUID;
  
  @HiveField(1)
  String friendName;
  
  @HiveField(2)
  String friendEmail;
  
  @HiveField(3)
  Timestamp dateBefriended;

  FriendModel({
    required this.friendUID, 
    required this.friendName,
    required this.friendEmail,
    required this.dateBefriended,
  });
  
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      friendUID: json['friendUID'],
      friendName: json['friendName'],
      friendEmail: json['friendEmail'],
      dateBefriended: json['dateBefriended'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendUID': friendUID,
      'friendName': friendName,
      'friendEmail': friendEmail,
      'dateBefriended': dateBefriended,
    };
  }
}
