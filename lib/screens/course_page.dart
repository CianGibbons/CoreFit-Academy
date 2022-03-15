import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/workout_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/utilities/validators/validate_string.dart';
import 'package:corefit_academy/widgets/create_workout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/validators/validate_email.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/muscle.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key, required this.courseObject, this.viewer = false})
      : super(key: key);

  final Course courseObject;
  final bool viewer;
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WorkoutDisplay> workoutsLoaded = [];
  final _addViewerFormKey = GlobalKey<FormState>();
  final _cloneCourseFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var stream1Owned = _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField,
            isEqualTo: widget.courseObject.courseReference)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .snapshots();
    var stream2Viewing = _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField,
            isEqualTo: widget.courseObject.courseReference)
        .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseObject.name),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuBarClick,
            itemBuilder: (BuildContext context) {
              Set<String> activeMenuItems = {};
              Set<String> menuItemsOwner = {
                kAddFriendsToCourseAction,
                kDeleteCourseAction,
                kCloneCourseAction,
              };
              Set<String> menuItemsViewer = {
                kAddFriendsToCourseAction,
                kRemoveCourseAction,
                kCloneCourseAction
              };
              if (widget.viewer) {
                activeMenuItems = menuItemsViewer;
              } else {
                activeMenuItems = menuItemsOwner;
              }

              return activeMenuItems.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                StreamBuilder2(
                  streams: Tuple2(stream1Owned, stream2Viewing),
                  builder: (context,
                      Tuple2<AsyncSnapshot<dynamic>, AsyncSnapshot<dynamic>>
                          snapshots) {
                    List<WorkoutDisplay> ownedWorkoutWidgets = [];
                    List<WorkoutDisplay> viewerWorkoutWidgets = [];

                    List<Workout> workoutObjects = [];
                    if (snapshots.item1.hasData) {
                      final workouts = snapshots.item1.data!.docs;

                      for (var workout in workouts) {
                        var workoutName = workout.get(kNameField);

                        List exerciseDynamic = List.empty();
                        exerciseDynamic = workout.get(kExercisesField);

                        List<String>? exerciseStrings = [];
                        var exercisesIterator = exerciseDynamic.iterator;
                        while (exercisesIterator.moveNext()) {
                          var current = exercisesIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = current.replaceAll(
                                kExercisesCollection + "/", "");
                            exerciseStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            exerciseStrings.add(currentRef.id);
                          }
                        }

                        var workoutRef = workout;
                        DocumentReference referenceToWorkout =
                            workoutRef.reference;

                        var workoutObject = Workout(
                          workoutReference: referenceToWorkout,
                          name: workoutName,
                          exercises: exerciseStrings,
                          numExercises: exerciseStrings.length,
                          viewers: widget.courseObject.viewers,
                        );

                        workoutObjects.add(workoutObject);
                      }

                      for (var workoutObject in workoutObjects) {
                        ownedWorkoutWidgets.add(WorkoutDisplay(
                          parentCourseObject: widget.courseObject,
                          workoutObject: workoutObject,
                          viewer: false,
                        ));
                      }
                    }
                    workoutObjects = [];
                    if (snapshots.item2.hasData) {
                      final workouts = snapshots.item2.data!.docs;

                      for (var workout in workouts) {
                        var workoutName = workout.get(kNameField);

                        List exerciseDynamic = List.empty();
                        exerciseDynamic = workout.get(kExercisesField);

                        List<String>? exerciseStrings = [];
                        var exercisesIterator = exerciseDynamic.iterator;
                        while (exercisesIterator.moveNext()) {
                          var current = exercisesIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = current.replaceAll(
                                kExercisesCollection + "/", "");
                            exerciseStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            exerciseStrings.add(currentRef.id);
                          }
                        }

                        var workoutRef = workout;
                        DocumentReference referenceToWorkout =
                            workoutRef.reference;

                        var workoutObject = Workout(
                          workoutReference: referenceToWorkout,
                          name: workoutName,
                          exercises: exerciseStrings,
                          numExercises: exerciseStrings.length,
                          viewers: widget.courseObject.viewers,
                        );

                        workoutObjects.add(workoutObject);
                      }

                      for (var workoutObject in workoutObjects) {
                        viewerWorkoutWidgets.add(WorkoutDisplay(
                          parentCourseObject: widget.courseObject,
                          workoutObject: workoutObject,
                          viewer: true,
                        ));
                      }
                    }
                    workoutsLoaded = ownedWorkoutWidgets + viewerWorkoutWidgets;
                    if (workoutsLoaded.isNotEmpty &&
                        snapshots.item1.connectionState ==
                            ConnectionState.active &&
                        snapshots.item2.connectionState ==
                            ConnectionState.active) {
                      return Column(children: workoutsLoaded);
                    }
                    if (workoutsLoaded.isEmpty &&
                        (snapshots.item1.connectionState ==
                                ConnectionState.active ||
                            snapshots.item2.connectionState ==
                                ConnectionState.active)) {
                      return Text(
                        kErrorNoWorkoutsFoundString,
                        textAlign: TextAlign.center,
                        style: kErrorMessageStyle.copyWith(fontSize: 20.0),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: _getFAB(context),
    );
  }

  Widget _getFAB(BuildContext context) {
    if (!widget.viewer) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) =>
                //Using a Wrap in order to dynamically fit the modal sheet to the content
                Wrap(
              children: [
                CreateWorkoutPage(
                  courseObject: widget.courseObject,
                )
              ],
            ),
          ).whenComplete(() {
            context.read<ErrorMessageStringProvider>().setValue(null);
          });
        },
      );
    } else {
      return Container();
    }
  }

  TextEditingController addViewerTextEditingController =
      TextEditingController();
  TextEditingController cloneCourseTextEditingController =
      TextEditingController();

  Future<void> _displayAddViewerToCourseDialog(BuildContext context) async {
    // Ensuring that should an Alert get dismissed by tapping outside it previously,
    // the Alert will not show the old error message.
    context.read<ErrorMessageStringProvider>().setValue(null);
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _addViewerFormKey,
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
                    if (_addViewerFormKey.currentState!.validate() &&
                        addViewerTextEditingController.text.isNotEmpty) {
                      DocumentReference<Map<String, dynamic>> reference =
                          _firestore.collection(kUsersCollection).doc(
                              addViewerTextEditingController.text
                                  .toLowerCase());

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
                            .doc(widget.courseObject.courseReference!.id)
                            .update({
                          kViewersField: FieldValue.arrayUnion([userId])
                        }).then((value) async {
                          //Add the user to the workouts within the course
                          for (var workout in widget.courseObject.workouts!) {
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
                          widget.courseObject.viewers!.add(userId);
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
                    setState(() {
                      addViewerTextEditingController.clear();
                    });
                  },
                  child: const Text(kAddFriend),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      addViewerTextEditingController.clear();
                      context.read<ErrorMessageStringProvider>().setValue(null);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(kCancel),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        });
  }

  void _deleteOwnedCourse() async {
    //Get all workouts within this course
    await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField,
            isEqualTo: widget.courseObject.courseReference)
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
            //For each exercise delete from database
            await _firestore
                .collection(kExercisesCollection)
                .doc(exercise.reference.id)
                .delete();
          }
        });
        //After exercises are deleted, delete workout
        await _firestore
            .collection(kWorkoutsCollection)
            .doc(workout.reference.id)
            .delete();
      }
      //pop back to courses page
      Navigator.pop(context);
      //delete the course
      await _firestore
          .collection(kCoursesCollection)
          .doc(widget.courseObject.courseReference!.id)
          .delete();
    });
  }

  void _removeViewedCourse() async {
    var userId = _firebase.currentUser!.uid;
    await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField,
            isEqualTo: widget.courseObject.courseReference)
        .get()
        .then((value) async {
      for (var workout in value.docs) {
        await _firestore
            .collection(kExercisesCollection)
            .where(kParentWorkoutField, isEqualTo: workout.reference)
            .get()
            .then((value) async {
          for (var exercise in value.docs) {
            await _firestore
                .collection(kExercisesCollection)
                .doc(exercise.reference.id)
                .update({
              kViewersField: FieldValue.arrayRemove([userId])
            });
          }
        });
        await _firestore
            .collection(kWorkoutsCollection)
            .doc(workout.reference.id)
            .update({
          kViewersField: FieldValue.arrayRemove([userId])
        });
      }
      Navigator.pop(context);
      await _firestore
          .collection(kCoursesCollection)
          .doc(widget.courseObject.courseReference!.id)
          .update({
        kViewersField: FieldValue.arrayRemove([userId])
      });
    });
  }

  void _cloneCourse(String newCourseName) async {
    _firestore.collection(kCoursesCollection).add({
      kCreatedAtField: DateTime.now(),
      kUserIdField: _firebase.currentUser!.uid,
      kNameField: newCourseName,
      kWorkoutsField: [],
      kViewersField: [],
    }).then((courseID) async {
      for (var workoutRef in widget.courseObject.workouts!) {
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
    Navigator.pop(context);
  }

  void _showDeleteOwnedCourseDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              child: AlertDialog(
            title: const Text(kDeleteCourseAction),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    _deleteOwnedCourse();
                    Navigator.pop(context);
                  });
                },
                child: const Text(kDelete),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text(kCancel),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ));
        });
  }

  void _showRemoveViewedCourseDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              child: AlertDialog(
            title: const Text(kRemoveCourseAction),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    _removeViewedCourse();
                    Navigator.pop(context);
                  });
                },
                child: const Text(kRemove),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text(kCancel),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ));
        });
  }

  void _showCloneCourseDialog() async {
    context.read<ErrorMessageStringProvider>().setValue(null);
    cloneCourseTextEditingController.clear();
    //  _cloneCourseFormKey
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: _cloneCourseFormKey,
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
                      setState(() {
                        if (_cloneCourseFormKey.currentState!.validate() &&
                            cloneCourseTextEditingController.text.isNotEmpty) {
                          _cloneCourse(cloneCourseTextEditingController.text);
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: const Text(kCloneCourseAction),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(kCancel),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ));
        });
  }

  void handleMenuBarClick(String value) {
    switch (value) {
      case kAddFriendsToCourseAction:
        _displayAddViewerToCourseDialog(context);
        break;
      case kCloneCourseAction:
        _showCloneCourseDialog();
        break;
      case kDeleteCourseAction:
        _showDeleteOwnedCourseDialog();
        break;
      case kRemoveCourseAction:
        _showRemoveViewedCourseDialog();
        break;
    }
  }
}
