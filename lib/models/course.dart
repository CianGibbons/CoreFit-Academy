import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  DocumentReference? courseReference;
  String name;
  int numWorkouts;
  int numViewers;
  List<String>? viewers = [];
  List<String>? workouts = [];
  int itemId = -1;
  bool viewer;

  Course({
    required this.name,
    this.courseReference,
    this.workouts,
    this.viewers,
    this.numViewers = 0,
    this.numWorkouts = 0,
    this.viewer = false,
  });

  String get value {
    return name;
  }

  set id(val) {
    itemId = val;
  }

  int get id {
    return itemId;
  }

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, courseReference: $courseReference, numWorkouts: $numWorkouts," +
        " workouts: $workouts, numViewers: $numViewers, viewers: $viewers }";
  }
}
