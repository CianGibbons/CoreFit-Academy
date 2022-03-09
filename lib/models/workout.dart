import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  DocumentReference workoutReference;
  String name;
  int numExercises;
  List<String>? viewers = [];
  List<String>? exercises;
  List<String>? targetedMuscles;

  Workout({
    required this.name,
    required this.workoutReference,
    this.exercises,
    this.viewers,
    this.targetedMuscles,
    this.numExercises = 0,
  });

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, workoutReference: $workoutReference, exercises: $exercises," +
        " targetedMuscles: $targetedMuscles, numExercises: $numExercises, viewers: $viewers }";
  }
}
