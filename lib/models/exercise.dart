import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:units_converter/units_converter.dart';
import 'package:corefit_academy/models/muscle.dart';

class Exercise {
  DocumentReference exerciseReference;
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

  Exercise({
    required this.name,
    required this.exerciseReference,
    this.sets,
    this.reps,
    this.distanceKM,
    this.weightKG,
    this.rpe,
    this.percentageOfExertion,
    this.targetedMuscles,
    this.targetedMuscleGroup = "Unknown",
    this.timeHours = 0,
    this.timeMinutes = 0,
    this.timeSeconds = 0,
  });

  Unit? getDistanceInMiles() {
    if (distanceKM != null) {
      var km = Length()..convert(LENGTH.kilometers, distanceKM);
      var unit = km.miles;
      return unit;
    }
    return null;
  }

  Unit? getWeightInPounds() {
    if (weightKG != null) {
      var kg = Mass()..convert(MASS.kilograms, weightKG);
      var unit = kg.pounds;
      return unit;
    }
    return null;
  }

  Duration getTotalTime() {
    return Duration(
        hours: timeHours, minutes: timeMinutes, seconds: timeSeconds);
  }

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, exerciseReference: $exerciseReference, sets: $sets," +
        " reps: $reps, timeHours: $timeHours, timeMinutes: $timeMinutes, " +
        "timeSeconds: $timeSeconds, distanceKM: $distanceKM, weightKG: $weightKG," +
        " rpe: $rpe, percentageOfExertion: $percentageOfExertion, " +
        "targetedMuscleGroup: $targetedMuscleGroup, " +
        "targetedMuscles: $targetedMuscles }";
  }
}
