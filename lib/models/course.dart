import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  DocumentReference courseReference;
  String name;
  int numWorkouts;
  int numViewers;
  List<DocumentReference>? workouts = [];

  Course(
      {required this.name,
      required this.courseReference,
      this.workouts,
      this.numViewers = 0,
      this.numWorkouts = 0});
}
