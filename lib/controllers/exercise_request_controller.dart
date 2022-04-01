import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/controllers/workout_request_controller.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/screens/workout_page.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/course.dart';

Exercise getExerciseObject(
    dynamic exerciseDoc, DocumentReference workoutRef, List<String> viewers) {
  // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
  // reps,sets,targetedMuscles,timeHours,timeMinutes,
  // timeSeconds,userId,weightKg,viewers

  var exerciseName = exerciseDoc.get(kNameField);

  var rawRPE = exerciseDoc.get(kRpeField);
  int rpe = rawRPE;

  var rawDistanceKm = exerciseDoc.get(kDistanceKmField);
  double distanceKm = 0;
  if (rawDistanceKm.runtimeType == double) {
    distanceKm = rawDistanceKm;
  } else if (rawDistanceKm.runtimeType == int) {
    distanceKm = double.parse(rawDistanceKm.toString());
  }

  var rawPercentageOfExertion = exerciseDoc.get(kPercentageOfExertionField);
  double percentageOfExertion = 0;
  if (rawPercentageOfExertion.runtimeType == double) {
    percentageOfExertion = rawPercentageOfExertion;
  } else if (rawPercentageOfExertion.runtimeType == int) {
    percentageOfExertion = double.parse(rawPercentageOfExertion.toString());
  }

  var rawReps = exerciseDoc.get(kRepsField);
  int reps = rawReps;

  var rawSets = exerciseDoc.get(kSetsField);
  int sets = rawSets;

  var targetedMuscleGroup = exerciseDoc.get(kTargetedMuscleGroupField);

  var muscles = exerciseDoc.get(kTargetedMusclesField);
  List<Muscle> targetedMuscles = [];
  for (var muscle in muscles) {
    String muscleName = muscle[kMuscleNameField];
    MuscleGroup muscleGroup =
        MuscleGroup.values[muscle[kMuscleGroupIndexField]];

    Muscle muscleObj = Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
    targetedMuscles.add(muscleObj);
  }

  var rawTimeHours = exerciseDoc.get(kTimeHoursField);
  int timeHours = int.parse(rawTimeHours.toString());

  var rawTimeMinutes = exerciseDoc.get(kTimeMinutesField);
  int timeMinutes = int.parse(rawTimeMinutes.toString());

  var rawTimeSeconds = exerciseDoc.get(kTimeSecondsField);
  int timeSeconds = int.parse(rawTimeSeconds.toString());

  var rawWeightKg = exerciseDoc.get(kWeightKgField);
  double weightKg = 0;
  if (rawWeightKg.runtimeType == double) {
    weightKg = rawWeightKg;
  } else if (rawWeightKg.runtimeType == int) {
    weightKg = double.parse(rawWeightKg.toString());
  }

  var exerciseRef = exerciseDoc;
  DocumentReference referenceToExercise = exerciseRef.reference;

  var exerciseObject = Exercise(
    parentWorkoutReference: workoutRef,
    exerciseReference: referenceToExercise,
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
    viewers: viewers,
  );

  return exerciseObject;
}

Future<List<Exercise>> getExercises(Workout workout) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  List<Exercise> ownedExercises = [];
  List<Exercise> viewingExercises = [];

  await _firestore
      .collection(kExercisesCollection)
      .where(kParentWorkoutField, isEqualTo: workout.workoutReference)
      .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
      .get()
      .then((snapshot1Owned) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshot1Owned.docs;
    for (var exercise in docs) {
      var exerciseObject = getExerciseObject(exercise, workout.workoutReference,
          workout.viewers != null ? workout.viewers! : []);
      ownedExercises.add(exerciseObject);
    }
  });

  await _firestore
      .collection(kExercisesCollection)
      .where(kParentWorkoutField, isEqualTo: workout.workoutReference)
      .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
      .get()
      .then((snapshot2Viewing) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshot2Viewing.docs;
    for (var exercise in docs) {
      var exerciseObject = getExerciseObject(exercise, workout.workoutReference,
          workout.viewers != null ? workout.viewers! : []);
      exerciseObject.viewer = true;
      viewingExercises.add(exerciseObject);
    }
  });

  List<Exercise> exerciseObjects = ownedExercises + viewingExercises;
  return exerciseObjects;
}

Future deleteExercise(String exerciseId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // delete from database
  await _firestore.collection(kExercisesCollection).doc(exerciseId).delete();
}

void deleteOwnedExercise(
    BuildContext context,
    String exerciseRefId,
    String workoutRefId,
    Workout parentWorkoutObject,
    Course grandparentCourseObject) async {
  await deleteExercise(exerciseRefId).then((value) async {
    await removeExerciseFromWorkout(workoutRefId, exerciseRefId);
  }).then((voidVal) {
    // Dismiss Dialog
    Navigator.pop(context);
    // Pop from Workout Page
    Navigator.pop(context);
    // Push back into the Workout Page and re-trigger the Future Builder in
    // order to ensure that the Exercise has been removed from the view
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          parentCourseObject: grandparentCourseObject,
          workoutObject: parentWorkoutObject,
        ),
      ),
    );
  });
}

void removeViewerFromExercise(String exerciseRefId, String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kExercisesCollection).doc(exerciseRefId).update({
    kViewersField: FieldValue.arrayRemove([userId])
  });
}

Future<QuerySnapshot<Map<String, dynamic>>> getExercisesFromParentRef(
    DocumentReference<Object?> workoutRef) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return await _firestore
      .collection(kExercisesCollection)
      .where(kParentWorkoutField, isEqualTo: workoutRef)
      .get();
}
