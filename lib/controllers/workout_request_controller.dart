import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/screens/course_page.dart';
import 'package:corefit_academy/controllers/course_request_controller.dart';
import 'package:corefit_academy/controllers/exercise_request_controller.dart';

Workout getWorkoutObject(dynamic workoutDoc, List<String> viewers) {
  var workoutName = workoutDoc.get(kNameField);

  List exerciseDynamic = List.empty();
  exerciseDynamic = workoutDoc.get(kExercisesField);

  List<String>? exerciseStrings = [];
  var exercisesIterator = exerciseDynamic.iterator;
  while (exercisesIterator.moveNext()) {
    var current = exercisesIterator.current;
    if (current.runtimeType == String) {
      String value = current;
      value = current.replaceAll(kExercisesCollection + "/", "");
      exerciseStrings.add(value);
    } else {
      DocumentReference currentRef = current;
      exerciseStrings.add(currentRef.id);
    }
  }

  var workoutRef = workoutDoc;
  DocumentReference referenceToWorkout = workoutRef.reference;

  var workoutObject = Workout(
    workoutReference: referenceToWorkout,
    name: workoutName,
    exercises: exerciseStrings,
    numExercises: exerciseStrings.length,
    viewers: viewers,
  );

  return workoutObject;
}

Future<List<Workout>> getWorkouts(Course course) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  List<Workout> ownedWorkouts = [];
  List<Workout> viewingWorkouts = [];
  await _firestore
      .collection(kWorkoutsCollection)
      .where(kParentCourseField, isEqualTo: course.courseReference)
      .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
      .get()
      .then((snapshotOwnedWorkouts) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotOwnedWorkouts.docs;
    for (var workout in docs) {
      var workoutObject = getWorkoutObject(
          workout, course.viewers != null ? course.viewers! : []);
      ownedWorkouts.add(workoutObject);
    }
  });

  await _firestore
      .collection(kWorkoutsCollection)
      .where(kParentCourseField, isEqualTo: course.courseReference)
      .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
      .get()
      .then((snapshotViewedWorkouts) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotViewedWorkouts.docs;
    for (var workout in docs) {
      var workoutObject = getWorkoutObject(
          workout, course.viewers != null ? course.viewers! : []);
      workoutObject.viewer = true;
      viewingWorkouts.add(workoutObject);
    }
  });

  List<Workout> courseObjects = ownedWorkouts + viewingWorkouts;
  return courseObjects;
}

void deleteWorkout(workoutId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Delete the workout
  await _firestore.collection(kWorkoutsCollection).doc(workoutId).delete();
}

Future<QuerySnapshot<Map<String, dynamic>>> getWorkoutsFromParentRef(
    DocumentReference<Object?> courseRef) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return await _firestore
      .collection(kWorkoutsCollection)
      .where(kParentCourseField, isEqualTo: courseRef)
      .get();
}

void removeViewerFromWorkout(String workoutRefId, String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kWorkoutsCollection).doc(workoutRefId).update({
    kViewersField: FieldValue.arrayRemove([userId])
  });
}

void deleteOwnedWorkout(BuildContext context, Workout workoutObject,
    Course parentCourseObject, bool viewer) async {
  await getExercisesFromParentRef(workoutObject.workoutReference)
      .then((value) async {
    for (var exercise in value.docs) {
      //For each exercise delete from database
      deleteExercise(exercise.reference.id);
    }
  }).then((value) async {
    //After exercises are deleted, delete workout
    deleteWorkout(workoutObject.workoutReference.id);
  }).then((value) async {
    //  After workout is deleted remove workout from its parent course workouts list
    removeWorkoutFromCourse(parentCourseObject.courseReference!.id,
        workoutObject.workoutReference.id);
  });
  // Need to go back to the Course Page and ensure that the Workout is Removed
  // Pop out of dialog
  Navigator.pop(context);
  // Pop out of Workout Page
  Navigator.pop(context);
  // Pop out of course Page to the course list page
  Navigator.pop(context);
  // Push the Course Page, this calls the FutureBuilder which ensures deleted
  // Workout will be gone
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CoursePage(
        viewer: viewer,
        courseObject: parentCourseObject,
      ),
    ),
  );
}

void showDeleteOwnedWorkoutDialog(BuildContext context, Workout workoutObject,
    Course parentCourseObject, bool viewer) async {
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            child: AlertDialog(
          title: const Text(kDeleteWorkoutAction),
          actions: <Widget>[
            CustomElevatedButton(
              onPressed: () {
                deleteOwnedWorkout(
                    context, workoutObject, parentCourseObject, viewer);
              },
              child: const Text(kDelete),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(kCancel),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
      });
}

Future removeExerciseFromWorkout(
    String workoutRefId, String exerciseRefId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kWorkoutsCollection).doc(workoutRefId).update({
    kExercisesField:
        FieldValue.arrayRemove([kExercisesCollection + "/" + exerciseRefId])
  });
}
