import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/models/workout_log.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/screens/logged_workouts_page.dart';
import 'package:corefit_academy/controllers/exercise_log_request_controller.dart';

import '../models/exercise_log.dart';

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

Future<List<WorkoutLog>> getWorkoutLogs() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  var snapshotWorkoutLogs = await _firestore
      .collection(kLogWorkoutCollection)
      .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
      .get();
  List<WorkoutLog> workoutLogs = [];

  if (snapshotWorkoutLogs.docs.isNotEmpty) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotWorkoutLogs.docs;

    for (var workoutLog in docs) {
      var workoutLogRef = workoutLog.reference;
      var workoutLogName = workoutLog.get(kNameField);
      var workoutLogTime = workoutLog.get(kCreatedAtField);
      Timestamp ts = workoutLogTime;
      DateTime workoutLogDate =
          DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);

      List workoutLogExercisesDynamic = List.empty();

      workoutLogExercisesDynamic = workoutLog.get(kExerciseLogsField);

      List<String>? workoutLogExerciseStrings = [];

      var workoutLogExercisesIterator = workoutLogExercisesDynamic.iterator;
      while (workoutLogExercisesIterator.moveNext()) {
        var current = workoutLogExercisesIterator.current;
        if (current.runtimeType == String) {
          String value = current;
          value = current.replaceAll(kExerciseLogsField + "/", "");
          workoutLogExerciseStrings.add(value);
        } else {
          DocumentReference currentRef = current;
          workoutLogExerciseStrings.add(currentRef.id);
        }
      }
      var workoutName = workoutLog.get(kWorkoutNameField);
      var courseName = workoutLog.get(kCourseNameField);
      WorkoutLog workoutLogObj = WorkoutLog(
        name: workoutLogName,
        createdAt: workoutLogDate,
        workoutName: workoutName,
        courseName: courseName,
        exercises: workoutLogExerciseStrings,
        workoutLogRef: workoutLogRef,
      );
      if (workoutLogObj.exercises!.isEmpty) {
        await _firestore
            .collection(kLogWorkoutCollection)
            .doc(workoutLogObj.workoutLogRef.id)
            .delete();
      } else {
        workoutLogs.add(workoutLogObj);
      }
    }
  }

  return workoutLogs;
}

void deleteWorkoutLog(String workoutLogRefId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore
      .collection(kLogWorkoutCollection)
      .doc(workoutLogRefId)
      .delete();
}

void deleteWorkoutLogForUser(
    BuildContext context, WorkoutLog workoutLog) async {
  await getExerciseLogsSnapshotFromWorkoutLog(workoutLog).then((value) async {
    for (var exerciseLog in value.docs) {
      deleteExerciseLog(exerciseLog.reference.id);
    }
    deleteWorkoutLog(workoutLog.workoutLogRef.id);
  });
  //Pop from Logged Exercise Page to Logged Workout Page
  Navigator.pop(context);
  //Pop from Logged Workout Page to Logbook Page
  Navigator.pop(context);
  //Push Back to LogsPage in order to rebuild the FutureBuilder
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return const LoggedWorkoutsPage();
  }));
}

void showDeleteWorkoutLogDialog(
    BuildContext context, WorkoutLog workoutLog) async {
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            child: AlertDialog(
          title: const Text(kDeleteWorkoutLogAction),
          actions: <Widget>[
            CustomElevatedButton(
              onPressed: () {
                deleteWorkoutLogForUser(context, workoutLog);
              },
              child: const Text(kDelete),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(kCancel),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
      });
}

Future<void> removeExerciseLogFromWorkoutLog(ExerciseLog exerciseLog) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore
      .collection(kLogWorkoutCollection)
      .doc(exerciseLog.parentWorkoutLogRef.id)
      .update({
    kExerciseLogsField: FieldValue.arrayRemove([exerciseLog.exerciseLogRef])
  });
}
