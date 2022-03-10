import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/valid_workout_selected_provider.dart';

class LogBook extends StatefulWidget {
  const LogBook({Key? key, required this.user, this.sendData})
      : super(key: key);
  final User user;
  final LogbookCallback? sendData;

  @override
  State<LogBook> createState() => _LogBookState();
}

class _LogBookState extends State<LogBook> {
  //TODO: Update Provider Upon Selecting Course with no Workouts to False
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  List<Course> courseObjects = [];
  List<Workout> workoutObj = [];

  DropdownMenuItem<int> pleaseSelectItem =
      const DropdownMenuItem<int>(value: 0, child: Text(kPleaseSelectString));

  List<DropdownMenuItem<int>> courseDropdownItems = [];
  List<DropdownMenuItem<int>> workoutDropdownItems = [];

  int? selectedCourseValue;
  int? selectedWorkoutValue;
  Course? selectedCourse;
  Workout? selectedWorkout;

  bool _showCourseDdlBool = false;
  bool _showWorkoutDdlBool = false;
  @override
  Widget build(BuildContext context) {
    if (courseDropdownItems.isEmpty) {
      courseDropdownItems = [pleaseSelectItem];
      selectedCourseValue = courseDropdownItems[0].value;
    }
    if (workoutDropdownItems.isEmpty) {
      workoutDropdownItems = [pleaseSelectItem];
      selectedWorkoutValue = workoutDropdownItems[0].value;
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                //Get all Courses
                CustomElevatedButton(
                  onPressed: () {},
                  child: const Text("See Logbook"),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showCourseDdlBool = !_showCourseDdlBool;
                      if (!_showCourseDdlBool) {
                        selectedCourse = null;
                        selectedWorkout = null;
                        _showWorkoutDdlBool = false;
                        selectedCourseValue = 0;
                        selectedWorkoutValue = 0;
                        context
                            .read<ValidWorkoutSelectedBoolProvider>()
                            .setValue(false);
                      }
                    });
                  },
                  child: Text(_showCourseDdlBool ? "Cancel" : "Add Log"),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        if (data.runtimeType == List<Course>) {
                          List<Course> courses = data as List<Course>;
                          var i = 1;
                          for (var course in courses) {
                            course.id = i;
                            i++;
                          }
                          if (courses.isNotEmpty) {
                            courseDropdownItems = [pleaseSelectItem] +
                                courses
                                    .map<DropdownMenuItem<int>>(
                                        (value) => DropdownMenuItem<int>(
                                              value: value.id,
                                              child: Text(value.name),
                                            ))
                                    .toList();

                            return Visibility(
                              visible: _showCourseDdlBool,
                              child: Column(
                                children: [
                                  const Text(
                                      "Select a Course to Log a Workout From"),
                                  DropdownButton<int>(
                                    value: selectedCourseValue,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedWorkout = null;
                                        selectedCourseValue = val!;
                                        selectedWorkoutValue = 0;
                                        workoutDropdownItems = [];
                                        if (selectedCourseValue != 0) {
                                          Course? selected;
                                          for (var course in courses) {
                                            if (course.id ==
                                                selectedCourseValue) {
                                              selected = course;
                                              break;
                                            }
                                          }
                                          if (selected != null) {
                                            setState(() {
                                              selectedCourse = selected;
                                              _showWorkoutDdlBool = true;
                                            });
                                          } else {
                                            context
                                                .read<
                                                    ValidWorkoutSelectedBoolProvider>()
                                                .setValue(false);
                                            setState(() {
                                              selectedCourse = null;
                                              _showWorkoutDdlBool = false;
                                            });
                                          }
                                        } else {
                                          context
                                              .read<
                                                  ValidWorkoutSelectedBoolProvider>()
                                              .setValue(false);
                                          setState(() {
                                            selectedCourse = null;
                                            _showWorkoutDdlBool = false;
                                          });
                                        }
                                      });
                                    },
                                    items: courseDropdownItems,
                                  ),
                                  if (_showCourseDdlBool &&
                                      selectedCourse != null)
                                    FutureBuilder(
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            var data = snapshot.data;
                                            if (data.runtimeType ==
                                                List<Workout>) {
                                              List<Workout> workouts =
                                                  data as List<Workout>;

                                              var i = 1;
                                              for (var workout in workouts) {
                                                workout.id = i;
                                                i++;
                                              }

                                              if (workouts.isNotEmpty) {
                                                workoutDropdownItems = [
                                                      pleaseSelectItem
                                                    ] +
                                                    workouts
                                                        .map<
                                                            DropdownMenuItem<
                                                                int>>((value) =>
                                                            DropdownMenuItem<
                                                                int>(
                                                              value: value.id,
                                                              child: Text(
                                                                  value.name),
                                                            ))
                                                        .toList();
                                                return Visibility(
                                                  visible: _showWorkoutDdlBool,
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                          "Select a Workout to Log"),
                                                      DropdownButton<int>(
                                                        value:
                                                            selectedWorkoutValue,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            selectedWorkoutValue =
                                                                val!;
                                                            if (selectedWorkoutValue !=
                                                                0) {
                                                              Workout? selected;
                                                              for (var workout
                                                                  in workouts) {
                                                                if (workout
                                                                        .id ==
                                                                    selectedWorkoutValue) {
                                                                  selected =
                                                                      workout;
                                                                  break;
                                                                }
                                                              }
                                                              if (selected !=
                                                                  null) {
                                                                context
                                                                    .read<
                                                                        ValidWorkoutSelectedBoolProvider>()
                                                                    .setValue(
                                                                        true);
                                                                setState(() {
                                                                  selectedWorkout =
                                                                      selected;
                                                                });
                                                                widget.sendData!(
                                                                    selectedCourse!,
                                                                    selectedWorkout!);
                                                              } else {
                                                                //No Workout Selected Hide FAB
                                                                context
                                                                    .read<
                                                                        ValidWorkoutSelectedBoolProvider>()
                                                                    .setValue(
                                                                        false);
                                                              }
                                                            } else {
                                                              // Please Select is selected so hide the FAB
                                                              context
                                                                  .read<
                                                                      ValidWorkoutSelectedBoolProvider>()
                                                                  .setValue(
                                                                      false);
                                                              setState(() {
                                                                selectedWorkout =
                                                                    null;
                                                              });
                                                            }
                                                          });
                                                        },
                                                        items:
                                                            workoutDropdownItems,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                    "No Workout were found for this Course!");
                                              }
                                            }
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        }
                                        return Container();
                                      },
                                      future: getWorkouts(selectedCourse!),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return const Text(
                                "No Courses were found! Please Create a new Course");
                          }
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                    return Container();
                  },
                  future: getCourses(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Course>> getCourses() async {
    var snapshotOwnedCourses = await _firestore
        .collection(kCoursesCollection)
        .where(kUserIdField, isEqualTo: widget.user.uid)
        .get();
    var snapshotViewingCourses = await _firestore
        .collection(kCoursesCollection)
        .where(kViewersField, arrayContains: widget.user.uid)
        .get();
    List<Course> ownedCourses = [];
    List<Course> viewingCourses = [];
    if (snapshotOwnedCourses.docs.isNotEmpty) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotOwnedCourses.docs;
      for (var course in docs) {
        var courseName = course.get(kNameField);

        List workoutsDynamic = course.get(kWorkoutsField);
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

        List viewersDynamic = course.get(kViewersField);
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

        var courseRef = course;
        DocumentReference referenceToCourse1 = courseRef.reference;

        var courseObject = Course(
          name: courseName,
          viewers: viewerStrings,
          numViewers: viewersDynamic.length,
          numWorkouts: workoutsDynamic.length,
          workouts: workoutStrings,
          courseReference: referenceToCourse1,
        );
        ownedCourses.add(courseObject);
      }
    }
    if (snapshotViewingCourses.docs.isNotEmpty) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotOwnedCourses.docs;
      for (var course in docs) {
        var courseName = course.get(kNameField);

        List workoutsDynamic = course.get(kWorkoutsField);
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

        List viewersDynamic = course.get(kViewersField);
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

        var courseRef = course;
        DocumentReference referenceToCourse1 = courseRef.reference;

        var courseObject = Course(
          name: courseName,
          viewers: viewerStrings,
          numViewers: viewersDynamic.length,
          numWorkouts: workoutsDynamic.length,
          workouts: workoutStrings,
          courseReference: referenceToCourse1,
        );
        viewingCourses.add(courseObject);
      }
    }
    List<Course> courseObjects = ownedCourses + viewingCourses;
    return courseObjects;
  }

  Future<List<Workout>> getWorkouts(Course course) async {
    var snapshotOwnedWorkouts = await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField, isEqualTo: selectedCourse!.courseReference)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .get();
    var snapshotViewedWorkouts = await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField, isEqualTo: selectedCourse!.courseReference)
        .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
        .get();

    List<Workout> ownedWorkouts = [];
    List<Workout> viewingWorkouts = [];

    if (snapshotOwnedWorkouts.docs.isNotEmpty) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotOwnedWorkouts.docs;
      for (var workout in docs) {
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
        List<String> targetedMuscles = List<String>.from(muscles);

        var workoutRef = workout;
        DocumentReference referenceToWorkout = workoutRef.reference;

        var workoutObject = Workout(
          workoutReference: referenceToWorkout,
          name: workoutName,
          exercises: exerciseStrings,
          numExercises: exerciseStrings.length,
          targetedMuscles: targetedMuscles,
          viewers: course.viewers,
        );
        ownedWorkouts.add(workoutObject);
      }
    }
    if (snapshotViewedWorkouts.docs.isNotEmpty) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotViewedWorkouts.docs;
      for (var workout in docs) {
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
        List<String> targetedMuscles = List<String>.from(muscles);

        var workoutRef = workout;
        DocumentReference referenceToWorkout = workoutRef.reference;

        var workoutObject = Workout(
          workoutReference: referenceToWorkout,
          name: workoutName,
          exercises: exerciseStrings,
          numExercises: exerciseStrings.length,
          targetedMuscles: targetedMuscles,
          viewers: course.viewers,
        );
        viewingWorkouts.add(workoutObject);
      }
    }

    List<Workout> courseObjects = ownedWorkouts + viewingWorkouts;
    return courseObjects;
  }
}

typedef LogbookCallback = void Function(Course course, Workout workout);
