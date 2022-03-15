import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  DocumentReference workoutReference;
  String name;
  int numExercises;
  List<String>? viewers = [];
  List<String>? exercises;
  int itemId = -1;

  set id(val) {
    itemId = val;
  }

  int get id {
    return itemId;
  }

  Workout({
    required this.name,
    required this.workoutReference,
    this.exercises,
    this.viewers,
    this.numExercises = 0,
  });

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, workoutReference: $workoutReference, exercises: $exercises," +
        " numExercises: $numExercises, viewers: $viewers }";
  }
}
