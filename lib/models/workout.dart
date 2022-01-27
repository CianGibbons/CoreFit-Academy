import 'package:corefit_academy/models/exercise.dart';

class Workout {
  // Name, List of Exercises, Expected Time for Completion,
  // List of Targeted Muscles
  String name;
  List<Exercise>? exercises;
  List<String>? targetedMuscles;

  Workout({required this.name, this.exercises, this.targetedMuscles});

  void addExercise(Exercise newExercise) {
    exercises!.add(newExercise);
  }

  void removeExercise(Exercise exerciseToBeRemoved) {
    exercises!.remove(exerciseToBeRemoved);
  }

  void addTargetedMuscle(String newTargetedMuscle) {
    targetedMuscles!.add(newTargetedMuscle);
  }

  void removeTargetedMuscle(String targetedMuscleToBeRemoved) {
    targetedMuscles!.remove(targetedMuscleToBeRemoved);
  }
}
