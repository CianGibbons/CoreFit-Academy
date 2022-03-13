import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/models/workout_log.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/exercise_log.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/components/exercise_log_display.dart';

class ExerciseLogPage extends StatelessWidget {
  ExerciseLogPage({Key? key, required this.workoutLog}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WorkoutLog workoutLog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutLog.workoutName),
      ),
      body: FutureBuilder(
          future: getExerciseLogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data.runtimeType == List<ExerciseLog>) {
              List<ExerciseLog> exerciseLogs =
                  snapshot.data as List<ExerciseLog>;
              List<Widget> exerciseLogDisplay = [];
              if (exerciseLogs.isNotEmpty) {
                for (var exerciseLog in exerciseLogs) {
                  var display = ExerciseLogDisplay(exerciseLog: exerciseLog);
                  exerciseLogDisplay.add(display);
                }

                return ListView(
                  children: exerciseLogDisplay,
                );
              } else {
                return Center(
                  child: Text(
                    "No Logged Exercises were found!",
                    textAlign: TextAlign.center,
                    style: kErrorMessageStyle.copyWith(fontSize: 20),
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Future<List<ExerciseLog>> getExerciseLogs() async {
    var snapshotExerciseLogs = await _firestore
        .collection(kLogExerciseCollection)
        .where(kWorkoutLogField, isEqualTo: workoutLog.workoutLogRef)
        .get();

    List<ExerciseLog> exerciseLogs = [];
    if (snapshotExerciseLogs.docs.isNotEmpty) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotExerciseLogs.docs;

      for (var exerciseLog in docs) {
        var exerciseRef = exerciseLog.reference;
        var exerciseName = exerciseLog.get(kNameField);

        var rawSets = exerciseLog.get(kSetsField);
        int sets = rawSets;
        var rawReps = exerciseLog.get(kRepsField);
        int reps = rawReps;

        var exerciseLogTimestamp = exerciseLog.get(kCreatedAtField);
        Timestamp ts = exerciseLogTimestamp;
        DateTime exerciseLogDate =
            DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);

        var rawTimeHours = exerciseLog.get(kTimeHoursField);
        int timeHours = int.parse(rawTimeHours.toString());
        var rawTimeMinutes = exerciseLog.get(kTimeMinutesField);
        int timeMinutes = int.parse(rawTimeMinutes.toString());
        var rawTimeSeconds = exerciseLog.get(kTimeSecondsField);
        int timeSeconds = int.parse(rawTimeSeconds.toString());

        var rawWeightKg = exerciseLog.get(kWeightKgField);
        double weightKg = 0;
        if (rawWeightKg.runtimeType == double) {
          weightKg = rawWeightKg;
        } else if (rawWeightKg.runtimeType == int) {
          weightKg = double.parse(rawWeightKg.toString());
        }

        var rawDistanceKm = exerciseLog.get(kDistanceKmField);
        double distanceKm = 0;
        if (rawDistanceKm.runtimeType == double) {
          distanceKm = rawDistanceKm;
        } else if (rawDistanceKm.runtimeType == int) {
          distanceKm = double.parse(rawDistanceKm.toString());
        }

        var rawRPE = exerciseLog.get(kRpeField);
        int rpe = rawRPE;

        var rawPercentageOfExertion =
            exerciseLog.get(kPercentageOfExertionField);
        double percentageOfExertion = 0;
        if (rawPercentageOfExertion.runtimeType == double) {
          percentageOfExertion = rawPercentageOfExertion;
        } else if (rawPercentageOfExertion.runtimeType == int) {
          percentageOfExertion =
              double.parse(rawPercentageOfExertion.toString());
        }

        var targetedMuscleGroup = exerciseLog.get(kTargetedMuscleGroupField);

        var muscles = exerciseLog.get(kTargetedMusclesField);
        List<Muscle> targetedMuscles = [];
        for (var muscle in muscles) {
          String muscleName = muscle[kMuscleNameField];
          MuscleGroup muscleGroup =
              MuscleGroup.values[muscle[kMuscleGroupIndexField]];

          Muscle muscleObj =
              Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
          targetedMuscles.add(muscleObj);
        }

        var rawTargetSets = exerciseLog.get(kTargetSetsField);
        int targetSets = rawTargetSets;
        var rawTargetReps = exerciseLog.get(kTargetRepsField);
        int targetReps = rawTargetReps;

        var rawTargetTimeHours = exerciseLog.get(kTargetTimeHoursField);
        int targetTimeHours = int.parse(rawTargetTimeHours.toString());
        var rawTargetTimeMinutes = exerciseLog.get(kTargetTimeMinutesField);
        int targetTimeMinutes = int.parse(rawTargetTimeMinutes.toString());
        var rawTargetTimeSeconds = exerciseLog.get(kTargetTimeSecondsField);
        int targetTimeSeconds = int.parse(rawTargetTimeSeconds.toString());

        var rawTargetDistanceKm = exerciseLog.get(kTargetDistanceKmField);
        double targetDistanceKm = 0;
        if (rawTargetDistanceKm.runtimeType == double) {
          targetDistanceKm = rawTargetDistanceKm;
        } else if (rawTargetDistanceKm.runtimeType == int) {
          targetDistanceKm = double.parse(rawTargetDistanceKm.toString());
        }

        var rawTargetWeightKg = exerciseLog.get(kTargetWeightKgField);
        double targetWeightKg = 0;
        if (rawWeightKg.runtimeType == double) {
          targetWeightKg = rawTargetWeightKg;
        } else if (rawTargetWeightKg.runtimeType == int) {
          targetWeightKg = double.parse(rawTargetWeightKg.toString());
        }

        var rawTargetRPE = exerciseLog.get(kTargetRpeField);
        int targetRpe = rawTargetRPE;

        var rawTargetPercentageOfExertion =
            exerciseLog.get(kTargetPercentageOfExertionField);
        double targetPercentageOfExertion = 0;
        if (rawTargetPercentageOfExertion.runtimeType == double) {
          targetPercentageOfExertion = rawTargetPercentageOfExertion;
        } else if (rawTargetPercentageOfExertion.runtimeType == int) {
          targetPercentageOfExertion =
              double.parse(rawTargetPercentageOfExertion.toString());
        }

        ExerciseLog exerciseLogObj = ExerciseLog(
          createdAt: exerciseLogDate,
          exerciseRef: exerciseRef,
          name: exerciseName,
          sets: sets,
          reps: reps,
          timeHours: timeHours,
          timeMinutes: timeMinutes,
          timeSeconds: timeSeconds,
          distanceKM: distanceKm,
          weightKG: weightKg,
          rpe: rpe,
          percentageOfExertion: percentageOfExertion,
          targetedMuscleGroup: targetedMuscleGroup,
          targetedMuscles: targetedMuscles,
          targetSets: targetSets,
          targetReps: targetReps,
          targetTimeHours: targetTimeHours,
          targetTimeMinutes: targetTimeMinutes,
          targetTimeSeconds: targetTimeSeconds,
          targetDistanceKM: targetDistanceKm,
          targetWeightKG: targetWeightKg,
          targetRpe: targetRpe,
          targetPercentageOfExertion: targetPercentageOfExertion,
        );
        exerciseLogs.add(exerciseLogObj);
      }
    }

    return exerciseLogs;
  }
}
