import 'package:cloud_firestore/cloud_firestore.dart';

import 'muscle.dart';

class ExerciseLog {
  String name;
  int? sets;
  int? reps;
  int timeHours;
  int timeMinutes;
  int timeSeconds;
  double? distanceKM;
  double? weightKG;
  int? rpe;
  double? percentageOfExertion;
  String targetedMuscleGroup;
  List<Muscle>? targetedMuscles;

  int? targetSets;
  int? targetReps;
  int targetTimeHours;
  int targetTimeMinutes;
  int targetTimeSeconds;
  double? targetDistanceKM;
  double? targetWeightKG;
  int? targetRpe;
  double? targetPercentageOfExertion;
  DocumentReference exerciseRef;
  DateTime createdAt;

  ExerciseLog({
    required this.createdAt,
    required this.exerciseRef,
    required this.name,
    required this.sets,
    required this.reps,
    required this.timeHours,
    required this.timeMinutes,
    required this.timeSeconds,
    required this.distanceKM,
    required this.weightKG,
    required this.rpe,
    required this.percentageOfExertion,
    required this.targetedMuscleGroup,
    required this.targetedMuscles,
    required this.targetSets,
    required this.targetReps,
    required this.targetTimeHours,
    required this.targetTimeMinutes,
    required this.targetTimeSeconds,
    required this.targetDistanceKM,
    required this.targetWeightKG,
    required this.targetRpe,
    required this.targetPercentageOfExertion,
  });

  Duration getTotalTime() {
    return Duration(
        hours: timeHours, minutes: timeMinutes, seconds: timeSeconds);
  }

  Duration getTotalTargetTime() {
    return Duration(
      hours: targetTimeHours,
      minutes: targetTimeMinutes,
      seconds: targetTimeSeconds,
    );
  }

  @override
  String toString() {
    return super.toString() + " --> { name: $name, }";
  }
}
