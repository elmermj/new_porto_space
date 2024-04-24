import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';
import 'package:new_porto_space/utils/execute.dart';

class OnReportAccount extends Execute {

  final String remoteUserName;
  final String remoteUserUID;
  final String reason;
  final DocumentReference? reference;

  OnReportAccount({
    required this.remoteUserName,
    required this.remoteUserUID,
    required this.reason,
    this.reference,
    super.instance = 'OnReportAccount'
  });

  @override
  execute() async {
    logYellow(instance);
    final FirebaseFirestore store = FirebaseFirestore.instance;
    final userUID = FirebaseAuth.instance.currentUser!.uid;

    // final bool isExist = await store.collection('reported').doc(remoteUserUID).get().then((value) => value.exists);

    await store.collection('reported').doc(remoteUserUID).collection('reports').add({
      'userUID': userUID,
      'userName': userData.value.name!,
      'time': Timestamp.now(),
      'reason': reason,
      'reference': reference,
    });

    //snack bar
    showSnackBar(
      title: 'User Reported', 
      message: "You have reported $remoteUserName", 
      duration: const Duration(milliseconds: 800)
    );

  }

}