import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  DocumentReference courseReference;
  String name;
  int numWorkouts;
  int numViewers;
  List<String>? viewers = [];
  List<String>? workouts = [];

  Course({
    required this.name,
    required this.courseReference,
    this.workouts,
    this.viewers,
    this.numViewers = 0,
    this.numWorkouts = 0,
  });

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, courseReference: $courseReference, numWorkouts: $numWorkouts," +
        " workouts: $workouts, numViewers: $numViewers, viewers: $viewers }";
  }
}
