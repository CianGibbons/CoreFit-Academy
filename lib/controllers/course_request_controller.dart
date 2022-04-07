import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:corefit_academy/components/workout_display.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/screens/navigator.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/validators/validate_email.dart';
import 'package:corefit_academy/utilities/validators/validate_string.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/controllers/exercise_request_controller.dart';
import 'package:corefit_academy/controllers/workout_request_controller.dart';

void createCourse(String courseName) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  await _firestore.collection(kCoursesCollection).add({
    kCreatedAtField: DateTime.now(),
    kUserIdField: _firebase.currentUser!.uid,
    kNameField: courseName,
    kWorkoutsField: [],
    kViewersField: [],
  });
}

Course getCourseObject(dynamic courseDoc) {
  var courseName = courseDoc.get(kNameField);

  List workoutsDynamic = courseDoc.get(kWorkoutsField);
  List<String>? workoutStrings = [];

  var workoutsIterator = workoutsDynamic.iterator;
  while (workoutsIterator.moveNext()) {
    var current = workoutsIterator.current;
    if (current.runtimeType == String) {
      String value = current;
      value = value.replaceAll(kWorkoutsField + "/", "");
      workoutStrings.add(value);
    } else {
      DocumentReference currentRef = current;
      workoutStrings.add(currentRef.id);
    }
  }

  List viewersDynamic = courseDoc.get(kViewersField);
  List<String>? viewerStrings = [];
  var viewersIterator = viewersDynamic.iterator;
  while (viewersIterator.moveNext()) {
    var current = viewersIterator.current;
    if (current.runtimeType == String) {
      String value = current;
      value = value.replaceAll(kViewersField + "/", "");
      viewerStrings.add(value);
    } else {
      DocumentReference currentRef = current;
      viewerStrings.add(currentRef.id);
    }
  }

  var courseRef = courseDoc;
  DocumentReference referenceToCourse1 = courseRef.reference;

  var courseObject = Course(
    name: courseName,
    viewers: viewerStrings,
    numViewers: viewersDynamic.length,
    numWorkouts: workoutsDynamic.length,
    workouts: workoutStrings,
    courseReference: referenceToCourse1,
  );
  return courseObject;
}

Future<List<Course>> getCourses() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  List<Course> ownedCourses = [];
  List<Course> viewingCourses = [];
  await _firestore
      .collection(kCoursesCollection)
      .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
      .get()
      .then((snapshotOwnedCourses) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotOwnedCourses.docs;
    for (var course in docs) {
      var courseObject = getCourseObject(course);
      ownedCourses.add(courseObject);
    }
  });

  await _firestore
      .collection(kCoursesCollection)
      .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
      .get()
      .then((snapshotViewingCourses) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        snapshotViewingCourses.docs;
    for (var course in docs) {
      var courseObject = getCourseObject(course);
      courseObject.viewer = true;
      viewingCourses.add(courseObject);
    }
  });

  List<Course> courseObjects = ownedCourses + viewingCourses;

  return courseObjects;
}

void deleteCourse(courseId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kCoursesCollection).doc(courseId).delete();
}

void deleteOwnedCourse(
    BuildContext context, DocumentReference courseReference) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  //Get all workouts within this course
  await _firestore
      .collection(kWorkoutsCollection)
      .where(kParentCourseField, isEqualTo: courseReference)
      .get()
      .then((value) async {
    //    For each workout get the exercises within
    for (var workout in value.docs) {
      await _firestore
          .collection(kExercisesCollection)
          .where(kParentWorkoutField, isEqualTo: workout.reference)
          .get()
          .then((value) async {
        for (var exercise in value.docs) {
          //deleting each exercise within the current workout
          deleteExercise(exercise.reference.id);
        }
      });
      //After exercises are deleted, delete workout
      deleteWorkout(workout.reference.id);
    }
    // back to courses page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NavigationController(user: _firebase.currentUser!),
      ),
    );

    //delete the course
    deleteCourse(courseReference.id);
  });
}

void showDeleteOwnedCourseDialog(
    BuildContext context, Course courseObject) async {
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            child: AlertDialog(
          title: const Text(kDeleteCourseAction),
          actions: <Widget>[
            CustomElevatedButton(
              onPressed: () {
                deleteOwnedCourse(context, courseObject.courseReference!);
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

void removeViewedCourse(BuildContext context, Course courseObject) async {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  var userId = _firebase.currentUser!.uid;
  await getWorkoutsFromParentRef(courseObject.courseReference!)
      .then((value) async {
    for (var workout in value.docs) {
      await getExercisesFromParentRef(workout.reference).then((value) async {
        for (var exercise in value.docs) {
          removeViewerFromExercise(exercise.reference.id, userId);
        }
      });
      removeViewerFromWorkout(workout.reference.id, userId);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NavigationController(user: _firebase.currentUser!),
      ),
    );

    removeViewerFromCourse(courseObject.courseReference!.id, userId);
  });
}

void removeViewerFromCourse(String courseRefId, String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kCoursesCollection).doc(courseRefId).update({
    kViewersField: FieldValue.arrayRemove([userId])
  });
}

void showRemoveViewedCourseDialog(
    BuildContext context, Course courseObject) async {
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            child: AlertDialog(
          title: const Text(kRemoveCourseAction),
          actions: <Widget>[
            CustomElevatedButton(
              onPressed: () {
                removeViewedCourse(context, courseObject);
              },
              child: const Text(kRemove),
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

void cloneCourse(
    BuildContext context, String newCourseName, Course courseObject) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  _firestore.collection(kCoursesCollection).add({
    kCreatedAtField: DateTime.now(),
    kUserIdField: _firebase.currentUser!.uid,
    kNameField: newCourseName,
    kWorkoutsField: [],
    kViewersField: [],
  }).then((courseID) async {
    for (var workoutRef in courseObject.workouts!) {
      await _firestore
          .collection(kWorkoutsCollection)
          .doc(workoutRef)
          .get()
          .then((workout) async {
        var workoutName = workout.get(kNameField);

        List exerciseDynamic = List.empty();
        exerciseDynamic = workout.get(kExercisesField);

        List<String>? exerciseStrings = [];
        var exercisesIterator = exerciseDynamic.iterator;
        while (exercisesIterator.moveNext()) {
          var current = exercisesIterator.current;
          if (current.runtimeType == String) {
            String value1 = current;
            value1 = current.replaceAll(kExercisesCollection + "/", "");
            exerciseStrings.add(value1);
          } else {
            DocumentReference currentRef = current;
            exerciseStrings.add(currentRef.id);
          }
        }

        DocumentReference? currentWorkout;

        _firestore.collection(kWorkoutsCollection).add({
          kCreatedAtField: DateTime.now(),
          kUserIdField: _firebase.currentUser!.uid,
          kNameField: workoutName,
          kExercisesField: [],
          kViewersField: [],
          kParentCourseField: courseID,
        }).then((workoutID) {
          currentWorkout = workoutID;
          List idList = [];
          idList.add(kWorkoutsCollection + '/' + workoutID.id);
          _firestore
              .collection(kCoursesCollection)
              .doc(courseID.id)
              .update({kWorkoutsField: FieldValue.arrayUnion(idList)});
        }).then((voidVal) async {
          for (var exerciseID in exerciseStrings) {
            _firestore
                .collection(kExercisesCollection)
                .doc(exerciseID)
                .get()
                .then((exerciseSnapshot) async {
              var exerciseName = exerciseSnapshot.get(kNameField);

              var rawRPE = exerciseSnapshot.get(kRpeField);
              int rpe = rawRPE;

              var rawDistanceKm = exerciseSnapshot.get(kDistanceKmField);
              double distanceKm = 0;
              if (rawDistanceKm.runtimeType == double) {
                distanceKm = rawDistanceKm;
              } else if (rawDistanceKm.runtimeType == int) {
                distanceKm = double.parse(rawDistanceKm.toString());
              }

              var rawPercentageOfExertion =
                  exerciseSnapshot.get(kPercentageOfExertionField);
              double percentageOfExertion = 0;
              if (rawPercentageOfExertion.runtimeType == double) {
                percentageOfExertion = rawPercentageOfExertion;
              } else if (rawPercentageOfExertion.runtimeType == int) {
                percentageOfExertion =
                    double.parse(rawPercentageOfExertion.toString());
              }

              var rawReps = exerciseSnapshot.get(kRepsField);
              int reps = rawReps;

              var rawSets = exerciseSnapshot.get(kSetsField);
              int sets = rawSets;

              var targetedMuscleGroup =
                  exerciseSnapshot.get(kTargetedMuscleGroupField);

              var muscles = exerciseSnapshot.get(kTargetedMusclesField);
              List<Muscle> targetedMuscles = [];
              for (var muscle in muscles) {
                String muscleName = muscle[kMuscleNameField];
                MuscleGroup muscleGroup =
                    MuscleGroup.values[muscle[kMuscleGroupIndexField]];
                Muscle muscleObj =
                    Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
                targetedMuscles.add(muscleObj);
              }

              List<Map> listOfMuscles = [];
              for (Muscle targetedMuscle in targetedMuscles) {
                listOfMuscles.add({
                  kMuscleNameField: targetedMuscle.muscleName,
                  kMuscleGroupIndexField: targetedMuscle.muscleGroup.index,
                });
              }

              var rawTimeHours = exerciseSnapshot.get(kTimeHoursField);
              int timeHours = int.parse(rawTimeHours.toString());

              var rawTimeMinutes = exerciseSnapshot.get(kTimeMinutesField);
              int timeMinutes = int.parse(rawTimeMinutes.toString());

              var rawTimeSeconds = exerciseSnapshot.get(kTimeSecondsField);
              int timeSeconds = int.parse(rawTimeSeconds.toString());

              var rawWeightKg = exerciseSnapshot.get(kWeightKgField);
              double weightKg = 0;
              if (rawWeightKg.runtimeType == double) {
                weightKg = rawWeightKg;
              } else if (rawWeightKg.runtimeType == int) {
                weightKg = double.parse(rawWeightKg.toString());
              }

              await _firestore.collection(kExercisesCollection).add({
                kCreatedAtField: DateTime.now(),
                kUserIdField: _firebase.currentUser!.uid,
                kNameField: exerciseName,
                kViewersField: [],
                kTargetedMuscleGroupField: targetedMuscleGroup,
                kTargetedMusclesField: listOfMuscles,
                kParentWorkoutField: currentWorkout,
                kRpeField: rpe,
                kDistanceKmField: distanceKm,
                kPercentageOfExertionField: percentageOfExertion,
                kRepsField: reps,
                kSetsField: sets,
                kTimeHoursField: timeHours,
                kTimeMinutesField: timeMinutes,
                kTimeSecondsField: timeSeconds,
                kWeightKgField: weightKg,
              }).then((value) {
                //Add exercise to the workouts list of exercises
                List idList = [];
                idList.add(kExercisesCollection + '/' + value.id);
                _firestore
                    .collection(kWorkoutsCollection)
                    .doc(currentWorkout!.id)
                    .update({kExercisesField: FieldValue.arrayUnion(idList)});
              });
            });
          }
        });
      });
    }
  });
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationController(user: _firebase.currentUser!),
    ),
  );
}

void showCloneCourseDialog(
    BuildContext context,
    Course courseObject,
    TextEditingController cloneCourseTextEditingController,
    GlobalKey<FormState> cloneCourseFormKey) async {
  context.read<ErrorMessageStringProvider>().setValue(null);
  cloneCourseTextEditingController.clear();

  return showDialog(
      context: context,
      builder: (context) {
        return Form(
            key: cloneCourseFormKey,
            child: AlertDialog(
              title: const Text(kCloneCourseAction),
              content: CustomTextFormField(
                validator: validateString,
                controller: cloneCourseTextEditingController,
                paddingAll: 0.0,
                iconData: FontAwesomeIcons.copy,
                inputLabel: kNewCourseNameString,
                obscureText: false,
                textInputType: TextInputType.text,
                activeColor: Theme.of(context).colorScheme.primary,
                errorText: context.watch<ErrorMessageStringProvider>().value,
              ),
              actions: <Widget>[
                CustomElevatedButton(
                  onPressed: () {
                    if (cloneCourseFormKey.currentState!.validate() &&
                        cloneCourseTextEditingController.text.isNotEmpty) {
                      cloneCourse(context,
                          cloneCourseTextEditingController.text, courseObject);
                    }
                  },
                  child: const Text(kCloneCourseAction),
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

Future<void> displayAddViewerToCourseDialog(
    BuildContext context,
    Course courseObject,
    List<WorkoutDisplay> workoutsLoaded,
    TextEditingController addViewerTextEditingController,
    GlobalKey<FormState> addViewerFormKey) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ensuring that should an Alert get dismissed by tapping outside it previously,
  // the Alert will not show the old error message.
  context.read<ErrorMessageStringProvider>().setValue(null);
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: addViewerFormKey,
          child: AlertDialog(
            title: const Text(kAddFriendsToCourseAction),
            content: CustomTextFormField(
              validator: validateEmail,
              controller: addViewerTextEditingController,
              paddingAll: 0.0,
              iconData: FontAwesomeIcons.userPlus,
              inputLabel: kEmailOfFriendString,
              obscureText: false,
              textInputType: TextInputType.emailAddress,
              activeColor: Theme.of(context).colorScheme.primary,
              errorText: context.watch<ErrorMessageStringProvider>().value,
            ),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () async {
                  if (addViewerFormKey.currentState!.validate() &&
                      addViewerTextEditingController.text.isNotEmpty) {
                    DocumentReference<Map<String, dynamic>> reference =
                        _firestore.collection(kUsersCollection).doc(
                            addViewerTextEditingController.text.toLowerCase());

                    var userSnaps = reference.snapshots();
                    var user = await userSnaps.first;

                    if (user.exists) {
                      // if there is a user found then we continue

                      var userId = user.get(kUserIdField);
                      // The Array in firestore will not store duplicates so
                      // this will not be an issue
                      //Add the user to the course
                      _firestore
                          .collection(kCoursesCollection)
                          .doc(courseObject.courseReference!.id)
                          .update({
                        kViewersField: FieldValue.arrayUnion([userId])
                      }).then((value) async {
                        //Add the user to the workouts within the course
                        for (var workout in courseObject.workouts!) {
                          _firestore
                              .collection(kWorkoutsCollection)
                              .doc(workout)
                              .update({
                            kViewersField: FieldValue.arrayUnion([userId])
                          }).then((value) {
                            //Add the User to the Exercises within each of the workouts
                            List<String> allExercises = [];
                            for (var workoutDisplay in workoutsLoaded) {
                              var iterator = workoutDisplay
                                  .workoutObject.exercises!.iterator;
                              while (iterator.moveNext()) {
                                allExercises.add(iterator.current);
                              }
                            }
                            for (String exerciseID in allExercises) {
                              _firestore
                                  .collection(kExercisesCollection)
                                  .doc(exerciseID)
                                  .update({
                                kViewersField: FieldValue.arrayUnion([userId])
                              });
                            }
                          });
                        }
                        courseObject.viewers!.add(userId);
                      });

                      Navigator.pop(context);
                    } else {
                      // Set the Error Message to User not found
                      // This also notifies any widget that a change has been made
                      // these widgets will then rebuild due to the update in this value
                      // ie. the text field will show that the User was not found in this case.
                      context
                          .read<ErrorMessageStringProvider>()
                          .setValue(kErrorUserNotFound);

                      // print(context.read<ErrorMessageStringProvider>().value);
                    }
                  }
                  addViewerTextEditingController.clear();
                },
                child: const Text(kAddFriend),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              CustomElevatedButton(
                onPressed: () {
                  addViewerTextEditingController.clear();
                  context.read<ErrorMessageStringProvider>().setValue(null);
                  Navigator.pop(context);
                },
                child: const Text(kCancel),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      });
}

void removeWorkoutFromCourse(String courseRefId, String workoutRefId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection(kCoursesCollection).doc(courseRefId).update({
    kWorkoutsField:
        FieldValue.arrayRemove([kWorkoutsCollection + "/" + workoutRefId]),
  });
}
