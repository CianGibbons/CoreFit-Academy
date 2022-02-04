import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  DocumentReference courseReference;
  String name;
  int numWorkouts;
  List<DocumentReference>? workouts = [];

  Course(
      {required this.name,
      required this.courseReference,
      this.workouts,
      this.numWorkouts = 0});
}
