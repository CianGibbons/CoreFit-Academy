import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:units_converter/units_converter.dart';

class Exercise {
  DocumentReference exerciseReference;
  String name;
  int? sets;
  int? reps;
  int? timeHours;
  int? timeMinutes;
  int? timeSeconds;
  double? distanceKM;
  double? weightKG;
  int? rpe;
  double? percentageOfExertion;
  List<String>? targetedMuscles;

  Exercise(
      {required this.name,
      required this.exerciseReference,
      this.sets,
      this.reps,
      this.timeHours,
      this.timeMinutes,
      this.timeSeconds,
      this.distanceKM,
      this.weightKG,
      this.rpe,
      this.percentageOfExertion,
      this.targetedMuscles});

  Unit? getDistanceInMiles() {
    if (distanceKM != null) {
      var km = Length()..convert(LENGTH.kilometers, distanceKM);
      var unit = km.miles;
      return unit;
    }
  }

  Unit? getWeightInPounds() {
    if (weightKG != null) {
      var kg = Mass()..convert(MASS.kilograms, weightKG);
      var unit = kg.pounds;
      return unit;
    }
  }

  void addTargetedMuscle(String newTargetedMuscle) {
    targetedMuscles!.add(newTargetedMuscle);
  }

  void removeTargetedMuscle(String targetedMuscleToBeRemoved) {
    targetedMuscles!.remove(targetedMuscleToBeRemoved);
  }
}
