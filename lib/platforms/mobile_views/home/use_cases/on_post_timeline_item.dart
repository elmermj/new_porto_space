import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/enums/timeline.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnPostTimelineItem extends Execute{
  final String content;
  final int type;
  final TimelineStatus? status;
  final TimelinePost? post;
  final TimelineShare? share;
  final TimelineLocation? location;

  OnPostTimelineItem({
    required this.content,
    required this.type,
    this.status,
    this.post,
    this.share,
    this.location,
    super.instance = 'OnPostTimelineItem'
  });

  @override
  execute() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String email = FirebaseAuth.instance.currentUser!.email ?? "null";
    String docId = "${Timestamp.now()}_${email}_$type";
    switch(type){
      case 0:
        logYellow('OnPostTimelineItem TimelineStatus');
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('timeline').doc(
          docId
        ).set({
          'type': type,
          'title': status!.title,
          'time': Timestamp.now(),
        });
        break;
      case 1:
        logYellow('OnPostTimelineItem TimelinePost');
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('timeline').doc(
          docId
        ).set({
          'type': type,
          'content': post!.content,
          'imageUrls': post!.imageUrls,
          'time': Timestamp.now(),
        });
        break;
      case 2:
        logYellow('OnPostTimelineItem TimelineShare');
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('timeline').doc(
          docId
        ).set({
          'type': type,
          'postDocumentRef': share!.postDocumentRef,
          'time': Timestamp.now(),
        });
        break;
      case 3:
        logYellow('OnPostTimelineItem TimelineLocation');
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('timeline').doc(
          docId
        ).set({
          'type': type,
          'lat': location!.lat,
          'long': location!.long,
          'placeName': location!.placeName,
          'time': Timestamp.now(),
        });
        break;
      default:
        break;
    }
  }
}