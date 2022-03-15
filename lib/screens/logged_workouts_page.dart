import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout_log.dart';
import 'package:corefit_academy/components/workout_log_display.dart';

class LogsPage extends StatelessWidget {
  LogsPage({Key? key}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logged Workouts"),
      ),
      body: FutureBuilder(
        future: getWorkoutLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data.runtimeType == List<WorkoutLog>) {
            List<WorkoutLog> workoutLogs = snapshot.data as List<WorkoutLog>;
            List<Widget> workoutLogDisplay = [];
            if (workoutLogs.isNotEmpty) {
              for (var workoutLog in workoutLogs) {
                var display = WorkoutLogDisplay(workoutLog: workoutLog);
                workoutLogDisplay.add(display);
              }

              return ListView(
                children: workoutLogDisplay,
              );
            } else {
              return Center(
                child: Text(
                  "No Logged Workout were found!",
                  textAlign: TextAlign.center,
                  style: kErrorMessageStyle.copyWith(fontSize: 20),
                ),
              );
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<WorkoutLog>> getWorkoutLogs() async {
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
}
