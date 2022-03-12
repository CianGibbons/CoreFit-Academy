import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  LogsPage({Key? key}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
      ),
    );
  }

  Future<dynamic> getLogs() async {
    var snapshotLogs = await _firestore
        .collection(kLogWorkoutCollection)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .get();
  }
}
