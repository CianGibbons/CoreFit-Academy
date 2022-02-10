import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/workout_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/widgets/create_workout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/validate_email.dart';
import 'package:corefit_academy/utilities/constants.dart';

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

  // List<WorkoutDisplay> workoutsLoaded = [];
  List<WorkoutDisplay> ownedWorkoutsMaster = [];
  List<WorkoutDisplay> viewerWorkoutsMaster = [];

  final _addViewerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: _firestore
                          .collection(kWorkoutsCollection)
                          .where(kParentCourseField,
                              isEqualTo: widget.courseObject.courseReference)
                          .where(kUserIdField,
                              isEqualTo: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<WorkoutDisplay> ownedWorkoutWidgets = [];
                        List<Workout> workoutObjects = [];
                        if (snapshot.hasData) {
                          final workouts = snapshot.data!.docs;

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
                                value = current.replaceAll("exercises/", "");
                                exerciseStrings.add(value);
                              } else {
                                DocumentReference currentRef = current;
                                exerciseStrings.add(currentRef.id);
                              }
                            }

                            var muscles = workout.get(kTargetedMusclesField);
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var workoutRef = workout;
                            DocumentReference referenceToWorkout =
                                workoutRef.reference;

                            var workoutObject = Workout(
                              workoutReference: referenceToWorkout,
                              name: workoutName,
                              exercises: exerciseStrings,
                              numExercises: exerciseStrings.length,
                              targetedMuscles: targetedMuscles,
                            );

                            workoutObjects.add(workoutObject);
                          }

                          for (var workoutObject in workoutObjects) {
                            ownedWorkoutWidgets.add(WorkoutDisplay(
                              workoutObject: workoutObject,
                              viewer: false,
                            ));
                          }
                        }
                        ownedWorkoutsMaster = ownedWorkoutWidgets;
                        return Column(
                          children: ownedWorkoutWidgets,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: _firestore
                          .collection(kWorkoutsCollection)
                          .where(kParentCourseField,
                              isEqualTo: widget.courseObject.courseReference)
                          .where(kViewersField,
                              arrayContains: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<WorkoutDisplay> viewerWorkoutWidgets = [];
                        List<Workout> workoutObjects = [];
                        if (snapshot.hasData) {
                          final workouts = snapshot.data!.docs;

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
                                value = current.replaceAll("exercises/", "");
                                exerciseStrings.add(value);
                              } else {
                                DocumentReference currentRef = current;
                                exerciseStrings.add(currentRef.id);
                              }
                            }

                            var muscles = workout.get(kTargetedMusclesField);
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var workoutRef = workout;
                            DocumentReference referenceToWorkout =
                                workoutRef.reference;

                            var workoutObject = Workout(
                              workoutReference: referenceToWorkout,
                              name: workoutName,
                              exercises: exerciseStrings,
                              numExercises: exerciseStrings.length,
                              targetedMuscles: targetedMuscles,
                            );

                            workoutObjects.add(workoutObject);
                          }

                          for (var workoutObject in workoutObjects) {
                            viewerWorkoutWidgets.add(WorkoutDisplay(
                              workoutObject: workoutObject,
                              viewer: true,
                            ));
                          }
                        }
                        viewerWorkoutsMaster = viewerWorkoutWidgets;
                        return Column(
                          children: viewerWorkoutWidgets,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
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
          );
        },
      );
    } else {
      return Container();
    }
  }

  TextEditingController textEditingController = TextEditingController();
  String _valueText = "";
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
                controller: textEditingController,
                paddingAll: 0.0,
                iconData: FontAwesomeIcons.userPlus,
                inputLabel: kEmailOfFriendString,
                obscureText: false,
                onSaved: (input) => _valueText = input!,
                textInputType: TextInputType.emailAddress,
                activeColor: Theme.of(context).colorScheme.primary,
                errorText: context.watch<ErrorMessageStringProvider>().value,
              ),
              actions: <Widget>[
                CustomElevatedButton(
                  onPressed: () async {
                    if (_addViewerFormKey.currentState!.validate() &&
                        textEditingController.text.isNotEmpty) {
                      DocumentReference<Map<String, dynamic>> reference =
                          _firestore
                              .collection(kUsersCollection)
                              .doc(textEditingController.text.toLowerCase());

                      var userSnaps = await reference.snapshots();
                      var user = await userSnaps.first;

                      if (user.exists) {
                        // if there is a user found then we continue

                        var userId = user.get(kUserIdField);
                        // The Array in firestore will not store duplicates so
                        // this will not be an issue
                        //Add the user to the course
                        _firestore
                            .collection(kCoursesCollection)
                            .doc(widget.courseObject.courseReference.id)
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
                              for (var workoutDisplay in ownedWorkoutsMaster) {
                                var iterator = workoutDisplay
                                    .workoutObject.exercises!.iterator;
                                while (iterator.moveNext()) {
                                  allExercises.add(iterator.current);
                                }
                              }
                              for (var workoutDisplay in viewerWorkoutsMaster) {
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
                      textEditingController.clear();
                    });
                  },
                  child: const Text(kAddFriend),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      textEditingController.clear();
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

  void handleMenuBarClick(String value) {
    //TODO: Implement Viewers, Delete Course, Clone Course, Remove Course
    switch (value) {
      case kAddFriendsToCourseAction:
        _displayAddViewerToCourseDialog(context);
        break;
      case kCloneCourseAction:
        break;
      case kDeleteCourseAction:
        break;
      case kRemoveCourseAction:
        break;
    }
  }
}
