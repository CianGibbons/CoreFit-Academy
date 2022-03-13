import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutLog {
  String name;
  DateTime createdAt;
  List<String>? exercises;
  String workoutName;
  String courseName;
  DocumentReference workoutLogRef;

  WorkoutLog({
    required this.workoutLogRef,
    required this.name,
    required this.exercises,
    required this.createdAt,
    required this.courseName,
    required this.workoutName,
  });

  @override
  String toString() {
    return super.toString() +
        " --> { name: $name, exercises: $exercises," +
        " createdAt: $createdAt }";
  }
}
