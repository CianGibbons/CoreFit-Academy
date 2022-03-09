import 'package:corefit_academy/utilities/constants.dart';

class Muscle {
  String muscleName;
  MuscleGroup muscleGroup;

  String get muscleGroupName {
    return kTargetMuscleGroupsNames[muscleGroup.index];
  }

  Muscle({required this.muscleName, required this.muscleGroup});

  @override
  String toString() => muscleName;
}
