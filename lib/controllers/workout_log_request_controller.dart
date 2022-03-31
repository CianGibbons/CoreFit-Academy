import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';

import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentReference<Map<String, dynamic>>> addWorkoutLog(
    Course course, Workout workout) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  return await _firestore.collection(kLogWorkoutCollection).add({
    kCourseNameField: course.name,
    kWorkoutNameField: workout.name,
    kNameField: workout.name,
    kWorkoutLogIdField: _firebase.currentUser!.uid.toString() +
        DateTime.now().toIso8601String(),
    kUserIdField: _firebase.currentUser!.uid,
    kExerciseLogsField: [],
    kCreatedAtField: DateTime.now()
  });
}

void addExerciseLogToWorkoutLog(String workoutLogRefId,
    DocumentReference<Map<String, dynamic>> exerciseLogRefId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore
      .collection(kLogWorkoutCollection)
      .doc(workoutLogRefId)
      .update({
    kExerciseLogsField: FieldValue.arrayUnion([exerciseLogRefId])
  });
}
