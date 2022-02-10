import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  DocumentReference workoutReference;
  String name;
  int numExercises;
  List<String>? exercises;
  List<String>? targetedMuscles;

  Workout({
    required this.name,
    required this.workoutReference,
    this.exercises,
    this.targetedMuscles,
    this.numExercises = 0,
  });
}
