import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/models/exercise.dart';

Future<DocumentReference<Map<String, dynamic>>> addExerciseLog({
  required List<Exercise> targetExercises,
  required int currentIndex,
  required DocumentReference workoutLogReference,
  required String currentTargetedMuscleGroup,
  required List<Map> currentListOfMuscles,
  required int currentRPEValue,
  required double currentDistanceValue,
  required double currentPercentageOfExertionValue,
  required double currentWeightValue,
  required int currentRepsValue,
  required int currentSetsValue,
  required int hours,
  required int minutes,
  required int seconds,
}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  return await _firestore.collection(kLogExerciseCollection).add({
    kCreatedAtField: DateTime.now(),
    kExerciseReferenceField: targetExercises[currentIndex].exerciseReference,
    kUserIdField: _firebase.currentUser!.uid,
    kNameField: targetExercises[currentIndex].name,
    kTargetedMuscleGroupField: currentTargetedMuscleGroup,
    kTargetedMusclesField: currentListOfMuscles,
    kRpeField: currentRPEValue,
    kDistanceKmField: currentDistanceValue,
    kPercentageOfExertionField: currentPercentageOfExertionValue,
    kRepsField: currentRepsValue,
    kSetsField: currentSetsValue,
    kTimeHoursField: hours,
    kTimeMinutesField: minutes,
    kTimeSecondsField: seconds,
    kWeightKgField: currentWeightValue,
    kTargetRpeField: targetExercises[currentIndex].rpe,
    kTargetDistanceKmField: targetExercises[currentIndex].distanceKM,
    kTargetPercentageOfExertionField:
        targetExercises[currentIndex].percentageOfExertion,
    kTargetRepsField: targetExercises[currentIndex].reps,
    kTargetSetsField: targetExercises[currentIndex].sets,
    kTargetTimeHoursField: targetExercises[currentIndex].timeHours,
    kTargetTimeMinutesField: targetExercises[currentIndex].timeMinutes,
    kTargetTimeSecondsField: targetExercises[currentIndex].timeSeconds,
    kTargetWeightKgField: targetExercises[currentIndex].weightKG,
    kWorkoutLogField: workoutLogReference,
  });
}
