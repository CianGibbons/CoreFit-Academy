import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/models/exercise_log.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/models/workout_log.dart';

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

ExerciseLog getExerciseLogObject(dynamic exerciseLog, WorkoutLog workoutLog) {
  var exerciseLogRef = exerciseLog.reference;
  var exerciseRef = exerciseLog.get(kExerciseReferenceField);
  var exerciseName = exerciseLog.get(kNameField);

  var rawSets = exerciseLog.get(kSetsField);
  int sets = rawSets;
  var rawReps = exerciseLog.get(kRepsField);
  int reps = rawReps;

  var exerciseLogTimestamp = exerciseLog.get(kCreatedAtField);
  Timestamp ts = exerciseLogTimestamp;
  DateTime exerciseLogDate =
      DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);

  var rawTimeHours = exerciseLog.get(kTimeHoursField);
  int timeHours = int.parse(rawTimeHours.toString());
  var rawTimeMinutes = exerciseLog.get(kTimeMinutesField);
  int timeMinutes = int.parse(rawTimeMinutes.toString());
  var rawTimeSeconds = exerciseLog.get(kTimeSecondsField);
  int timeSeconds = int.parse(rawTimeSeconds.toString());

  var rawWeightKg = exerciseLog.get(kWeightKgField);
  double weightKg = 0;
  if (rawWeightKg.runtimeType == double) {
    weightKg = rawWeightKg;
  } else if (rawWeightKg.runtimeType == int) {
    weightKg = double.parse(rawWeightKg.toString());
  }

  var rawDistanceKm = exerciseLog.get(kDistanceKmField);
  double distanceKm = 0;
  if (rawDistanceKm.runtimeType == double) {
    distanceKm = rawDistanceKm;
  } else if (rawDistanceKm.runtimeType == int) {
    distanceKm = double.parse(rawDistanceKm.toString());
  }

  var rawRPE = exerciseLog.get(kRpeField);
  int rpe = rawRPE;

  var rawPercentageOfExertion = exerciseLog.get(kPercentageOfExertionField);
  double percentageOfExertion = 0;
  if (rawPercentageOfExertion.runtimeType == double) {
    percentageOfExertion = rawPercentageOfExertion;
  } else if (rawPercentageOfExertion.runtimeType == int) {
    percentageOfExertion = double.parse(rawPercentageOfExertion.toString());
  }

  var targetedMuscleGroup = exerciseLog.get(kTargetedMuscleGroupField);

  var muscles = exerciseLog.get(kTargetedMusclesField);
  List<Muscle> targetedMuscles = [];
  for (var muscle in muscles) {
    String muscleName = muscle[kMuscleNameField];
    MuscleGroup muscleGroup =
        MuscleGroup.values[muscle[kMuscleGroupIndexField]];

    Muscle muscleObj = Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
    targetedMuscles.add(muscleObj);
  }

  var rawTargetSets = exerciseLog.get(kTargetSetsField);
  int targetSets = rawTargetSets;
  var rawTargetReps = exerciseLog.get(kTargetRepsField);
  int targetReps = rawTargetReps;

  var rawTargetTimeHours = exerciseLog.get(kTargetTimeHoursField);
  int targetTimeHours = int.parse(rawTargetTimeHours.toString());
  var rawTargetTimeMinutes = exerciseLog.get(kTargetTimeMinutesField);
  int targetTimeMinutes = int.parse(rawTargetTimeMinutes.toString());
  var rawTargetTimeSeconds = exerciseLog.get(kTargetTimeSecondsField);
  int targetTimeSeconds = int.parse(rawTargetTimeSeconds.toString());

  var rawTargetDistanceKm = exerciseLog.get(kTargetDistanceKmField);
  double targetDistanceKm = 0;
  if (rawTargetDistanceKm.runtimeType == double) {
    targetDistanceKm = rawTargetDistanceKm;
  } else if (rawTargetDistanceKm.runtimeType == int) {
    targetDistanceKm = double.parse(rawTargetDistanceKm.toString());
  }

  var rawTargetWeightKg = exerciseLog.get(kTargetWeightKgField);
  double targetWeightKg = 0;
  if (rawWeightKg.runtimeType == double) {
    targetWeightKg = rawTargetWeightKg;
  } else if (rawTargetWeightKg.runtimeType == int) {
    targetWeightKg = double.parse(rawTargetWeightKg.toString());
  }

  var rawTargetRPE = exerciseLog.get(kTargetRpeField);
  int targetRpe = rawTargetRPE;

  var rawTargetPercentageOfExertion =
      exerciseLog.get(kTargetPercentageOfExertionField);
  double targetPercentageOfExertion = 0;
  if (rawTargetPercentageOfExertion.runtimeType == double) {
    targetPercentageOfExertion = rawTargetPercentageOfExertion;
  } else if (rawTargetPercentageOfExertion.runtimeType == int) {
    targetPercentageOfExertion =
        double.parse(rawTargetPercentageOfExertion.toString());
  }

  ExerciseLog exerciseLogObj = ExerciseLog(
    parentWorkoutLogRef: workoutLog.workoutLogRef,
    createdAt: exerciseLogDate,
    exerciseLogRef: exerciseLogRef,
    exerciseRef: exerciseRef,
    name: exerciseName,
    sets: sets,
    reps: reps,
    timeHours: timeHours,
    timeMinutes: timeMinutes,
    timeSeconds: timeSeconds,
    distanceKM: distanceKm,
    weightKG: weightKg,
    rpe: rpe,
    percentageOfExertion: percentageOfExertion,
    targetedMuscleGroup: targetedMuscleGroup,
    targetedMuscles: targetedMuscles,
    targetSets: targetSets,
    targetReps: targetReps,
    targetTimeHours: targetTimeHours,
    targetTimeMinutes: targetTimeMinutes,
    targetTimeSeconds: targetTimeSeconds,
    targetDistanceKM: targetDistanceKm,
    targetWeightKG: targetWeightKg,
    targetRpe: targetRpe,
    targetPercentageOfExertion: targetPercentageOfExertion,
  );

  return exerciseLogObj;
}

Future<QuerySnapshot<Map<String, dynamic>>>
    getExerciseLogsSnapshotFromWorkoutLog(WorkoutLog workoutLog) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return await _firestore
      .collection(kLogExerciseCollection)
      .where(kWorkoutLogField, isEqualTo: workoutLog.workoutLogRef)
      .get();
}

Future<List<ExerciseLog>> getExerciseLogs(WorkoutLog workoutLog) async {
  var snapshotExerciseLogs =
      await getExerciseLogsSnapshotFromWorkoutLog(workoutLog);

  List<ExerciseLog> exerciseLogs = [];
  if (snapshotExerciseLogs.docs.isNotEmpty) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotExerciseLogs.docs;

    for (var exerciseLog in docs) {
      ExerciseLog exerciseLogObj =
          getExerciseLogObject(exerciseLog, workoutLog);
      exerciseLogs.add(exerciseLogObj);
    }
  }

  return exerciseLogs;
}

void deleteExerciseLog(String exerciseLogRefId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore
      .collection(kLogExerciseCollection)
      .doc(exerciseLogRefId)
      .delete();
}
