import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineStatus {
  Timestamp? time;
  String? title;
  List<Reaction>? reactions;
  List<Comment>? comments;

  TimelineStatus({
    required this.time,
    required this.title,
    this.reactions,
    this.comments,
  });
}

class TimelinePost {
  Timestamp? time;
  String? content;
  List<String>? imageUrls;
  List<Reaction>? reactions;
  List<Comment>? comments;

  TimelinePost({
    required this.time,
    required this.content,
    this.imageUrls,
    this.reactions,
    this.comments,
  });
}

class TimelineShare {
  Timestamp? time;
  DocumentReference? postDocumentRef;
  List<Reaction>? reactions;
  List<Comment>? comments;

  TimelineShare({
    required this.time,
    required this.postDocumentRef,
    this.reactions,
    this.comments,
  });
}

class TimelineLocation {
  String? lat;
  String? long;
  String? placeName;
  List<Reaction>? reactions;
  List<Comment>? comments;

  TimelineLocation({
    required this.lat,
    required this.long,
    required this.placeName,
    this.reactions,
    this.comments,
  });
}

class Reaction {
  int? reactionCode;
  String? userID;
  String? userName;

  Reaction({
    required this.reactionCode,
    required this.userID,
    required this.userName,
  });
}

class Comment {
  String? comment;
  String? userID;
  String? userName;
  Timestamp? time;
  List<Reaction>? reactions;

  Comment({
    required this.comment,
    required this.userID,
    required this.userName,
    required this.time,
    required this.reactions,
  });
}
