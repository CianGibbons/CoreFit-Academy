import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:corefit_academy/components/day_representation.dart';

import '../../components/muscle_group_representation.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key, required this.user}) : super(key: key);
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                //TODO: Monitor Workout Progress and Record Data -> Visualise this Data
                //TODO: Implement the use of Location Data to monitor exercises routes -> Visual Representation
                //TODO: Set Goals for each Week/Month/Year -> Different Types of Goals - Muscle Build-up, Weight Gain/Loss, Distance for a Run, etc
                buildWorkoutsLoggedThisWeekWidget(),
                FutureBuilder(
                    future: _getNumberOfExercisesLoggedPerMuscleGroup(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      List<Widget> muscleGroupRepresentation = [];
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        var map = snapshot.data;
                        for (var key in map.keys) {
                          muscleGroupRepresentation
                              .add(MuscleGroupRepresentation(
                            muscleGroupName: key,
                            value: map[key],
                          ));
                        }
                      }
                      //No Data Returned Yet
                      return Column(
                        children: muscleGroupRepresentation,
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getNumberOfExercisesLoggedPerMuscleGroup() async {
    Map map = Map();
    await _firestore
        .collection(kLogExerciseCollection)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .get()
        .then((snapshot) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
      List<String> muscleGroupsPresent = [];
      for (var exerciseLog in docs) {
        var muscleGroupDyn = exerciseLog.get(kTargetedMuscleGroupField);
        String muscleGroup = muscleGroupDyn;
        muscleGroupsPresent.add(muscleGroup);
      }
      muscleGroupsPresent
          .forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));

      for (var muscleGroup in kTargetMuscleGroupsNames) {
        if (!map.keys.contains(muscleGroup)) {
          map[muscleGroup] = 0;
        }
      }

      return map;
    });

    for (var muscleGroup in kTargetMuscleGroupsNames) {
      if (!map.keys.contains(muscleGroup)) {
        map[muscleGroup] = 0;
      }
    }
    return map;
  }

  FutureBuilder<List<int>> buildWorkoutsLoggedThisWeekWidget() {
    return FutureBuilder(
      future: _getDaysOfCurrentWeekWorkouts(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data.runtimeType == List<int>) {
          List<int> days = snapshot.data;
          List<Widget> daysRepresentation = [];

          var d = DateTime.now();
          var weekDay = d.weekday;

          for (var i = 1; i <= 7; i++) {
            if (i <= weekDay) {
              if (days.contains(i)) {
                daysRepresentation.add(DayRepresentation(
                  workoutPresent: true,
                  dayValue: i,
                  dayReached: true,
                ));
              } else {
                daysRepresentation.add(DayRepresentation(
                  workoutPresent: false,
                  dayValue: i,
                  dayReached: true,
                ));
              }
            } else {
              daysRepresentation.add(DayRepresentation(
                workoutPresent: false,
                dayValue: i,
                dayReached: false,
              ));
            }
          }
          return Column(
            children: [
              const Text(
                "Workouts Logged This Week:",
                style: kTitleStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: daysRepresentation,
              ),
            ],
          );
        }
        //No Logged Workouts Found
        return Text(
          kErrorNoWorkoutLoggedThisWeek,
          style: kTitleStyle.copyWith(color: Colors.red),
        );
      },
    );
  }

  Future<List<int>> _getDaysOfCurrentWeekWorkouts() async {
    List<int> daysWithWorkout = [];
    //Get the first day of the week at 12am
    var d = DateTime.now();
    var weekDay = d.weekday;
    var firstDayOfWeek = d.subtract(Duration(days: weekDay));
    firstDayOfWeek = firstDayOfWeek.subtract(Duration(
        hours: firstDayOfWeek.hour,
        minutes: firstDayOfWeek.minute,
        seconds: firstDayOfWeek.second,
        milliseconds: firstDayOfWeek.millisecond,
        microseconds: firstDayOfWeek.microsecond));

    //Getting all WorkoutLog objects within this current Week
    await _firestore
        .collection(kLogWorkoutCollection)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .orderBy(kCreatedAtField)
        .where(kCreatedAtField, isGreaterThan: firstDayOfWeek)
        .get()
        .then((snapshot) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;
      for (var workoutLog in docs) {
        var createdAt = workoutLog.get(kCreatedAtField);
        Timestamp ts = createdAt;
        DateTime date =
            DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);

        // Weekday value is 1-7 depending on Day Workout was done
        // 1-7 for Monday to Sunday

        //If this day this week already has this day then continue
        //No need to take note of multiple workouts in one day for the purpose of this.
        if (!daysWithWorkout.contains(date.weekday)) {
          //Workout Day logged
          daysWithWorkout.add(date.weekday);
        }
      }
    });

    return daysWithWorkout;
  }
}
