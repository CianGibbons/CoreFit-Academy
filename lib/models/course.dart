import 'package:corefit_academy/models/workout.dart';

class Course {
  String name;
  List<Workout>? workouts;

  Course({required this.name, this.workouts});

  void addWorkout(Workout newWorkout) {
    workouts!.add(newWorkout);
  }

  void removeWorkout(Workout workoutToBeRemoved) {
    workouts!.remove(workoutToBeRemoved);
  }
}
