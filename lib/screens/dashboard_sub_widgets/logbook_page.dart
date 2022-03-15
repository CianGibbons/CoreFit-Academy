import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/screens/logged_workouts_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/valid_workout_selected_provider.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';
import 'package:corefit_academy/screens/log_exercise_page.dart';

class LogBook extends StatefulWidget {
  const LogBook({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<LogBook> createState() => _LogBookState();
}

class _LogBookState extends State<LogBook> {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    //TODO: SHOW ALL USER LOGS
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LogsPage();
                    }));
                  },
                  child: const Text(kSeeLogbookAction),
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
                  child: Text(_showCourseDdlBool ? kCancel : kAddLogAction),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data.runtimeType == List<Course>) {
                      List<Course> courses = snapshot.data as List<Course>;
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
                              const Text(kSelectCourseToLogFromInstruction),
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
                                        if (course.id == selectedCourseValue) {
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
                                        setState(() {
                                          selectedCourse = null;
                                          _showWorkoutDdlBool = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        selectedCourse = null;
                                        _showWorkoutDdlBool = false;
                                      });
                                    }
                                  });
                                },
                                items: courseDropdownItems,
                              ),
                              if (_showCourseDdlBool && selectedCourse != null)
                                FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data;
                                        if (data.runtimeType == List<Workout>) {
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
                                                        DropdownMenuItem<int>(
                                                          value: value.id,
                                                          child:
                                                              Text(value.name),
                                                        ))
                                                    .toList();
                                            return Visibility(
                                              visible: _showWorkoutDdlBool,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                      kSelectWorkoutToLogFromInstruction),
                                                  DropdownButton<int>(
                                                    value: selectedWorkoutValue,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedWorkoutValue =
                                                            val!;
                                                        if (selectedWorkoutValue !=
                                                            0) {
                                                          Workout? selected;
                                                          for (var workout
                                                              in workouts) {
                                                            if (workout.id ==
                                                                selectedWorkoutValue) {
                                                              selected =
                                                                  workout;
                                                              break;
                                                            }
                                                          }
                                                          if (selected !=
                                                              null) {
                                                            setState(() {
                                                              selectedWorkout =
                                                                  selected;
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            selectedWorkout =
                                                                null;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    items: workoutDropdownItems,
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                                kErrorNoWorkoutsFoundString);
                                          }
                                        }
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
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
                        return const Text(kErrorNoCoursesFoundString);
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  future: getCourses(),
                ),
                if (selectedCourse != null)
                  Text(kSelectedCourse + selectedCourse!.name),
                if (selectedWorkout != null)
                  Text(kSelectedWorkout + selectedWorkout!.name),
                if (selectedWorkout != null &&
                    selectedWorkout!.exercises!.isEmpty)
                  const Text(
                    kErrorSelectedWorkoutNoExercisesString,
                    style: kErrorMessageStyle,
                  ),
                if (selectedWorkout != null &&
                    selectedCourse != null &&
                    selectedWorkout!.exercises!.isNotEmpty)
                  CustomElevatedButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            kLogExerciseActionButton,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(FontAwesomeIcons.pencilAlt, size: 20.0),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      if (selectedCourse != null && selectedWorkout != null) {
                        var exerciseData = await getExercises(selectedWorkout!);
                        if (exerciseData.runtimeType == List<Exercise>) {
                          List<Exercise> exercises = exerciseData;
                          int currentIndex = 0;
                          context.read<DurationSelectedProvider>().setValue(
                              Duration(
                                  hours: exercises[currentIndex].timeHours,
                                  minutes: exercises[currentIndex].timeMinutes,
                                  seconds:
                                      exercises[currentIndex].timeSeconds));
                          var workoutLogReference = await _firestore
                              .collection(kLogWorkoutCollection)
                              .add({
                            kCourseNameField: selectedCourse!.name,
                            kWorkoutNameField: selectedWorkout!.name,
                            kNameField: selectedWorkout!.name,
                            kWorkoutLogIdField:
                                _firebase.currentUser!.uid.toString() +
                                    DateTime.now().toIso8601String(),
                            kUserIdField: _firebase.currentUser!.uid,
                            kExerciseLogsField: [],
                            kCreatedAtField: DateTime.now()
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LogExercisePage(
                              targetExercises: exercises,
                              currentIndex: currentIndex,
                              workoutLogReference: workoutLogReference,
                            );
                          }));
                        }
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Course>> getCourses() async {
    List<Course> ownedCourses = [];
    List<Course> viewingCourses = [];
    await _firestore
        .collection(kCoursesCollection)
        .where(kUserIdField, isEqualTo: widget.user.uid)
        .get()
        .then((snapshotOwnedCourses) {
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
    });

    await _firestore
        .collection(kCoursesCollection)
        .where(kViewersField, arrayContains: widget.user.uid)
        .get()
        .then((snapshotViewingCourses) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          snapshotViewingCourses.docs;
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
    });

    List<Course> courseObjects = ownedCourses + viewingCourses;

    return courseObjects;
  }

  Future<List<Workout>> getWorkouts(Course course) async {
    List<Workout> ownedWorkouts = [];
    List<Workout> viewingWorkouts = [];
    await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField, isEqualTo: selectedCourse!.courseReference)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .get()
        .then((snapshotOwnedWorkouts) {
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
            value = current.replaceAll(kExercisesCollection + "/", "");
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
    });

    await _firestore
        .collection(kWorkoutsCollection)
        .where(kParentCourseField, isEqualTo: selectedCourse!.courseReference)
        .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
        .get()
        .then((snapshotViewedWorkouts) {
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
            value = current.replaceAll(kExercisesCollection + "/", "");
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
    });

    List<Workout> courseObjects = ownedWorkouts + viewingWorkouts;
    return courseObjects;
  }

  Future<List<Exercise>> getExercises(Workout workout) async {
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
        // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
        // reps,sets,targetedMuscles,timeHours,timeMinutes,
        // timeSeconds,userId,weightKg,viewers

        var exerciseName = exercise.get(kNameField);

        var rawRPE = exercise.get(kRpeField);
        int rpe = rawRPE;

        var rawDistanceKm = exercise.get(kDistanceKmField);
        double distanceKm = 0;
        if (rawDistanceKm.runtimeType == double) {
          distanceKm = rawDistanceKm;
        } else if (rawDistanceKm.runtimeType == int) {
          distanceKm = double.parse(rawDistanceKm.toString());
        }

        var rawPercentageOfExertion = exercise.get(kPercentageOfExertionField);
        double percentageOfExertion = 0;
        if (rawPercentageOfExertion.runtimeType == double) {
          percentageOfExertion = rawPercentageOfExertion;
        } else if (rawPercentageOfExertion.runtimeType == int) {
          percentageOfExertion =
              double.parse(rawPercentageOfExertion.toString());
        }

        var rawReps = exercise.get(kRepsField);
        int reps = rawReps;

        var rawSets = exercise.get(kSetsField);
        int sets = rawSets;

        var targetedMuscleGroup = exercise.get(kTargetedMuscleGroupField);

        var muscles = exercise.get(kTargetedMusclesField);
        List<Muscle> targetedMuscles = [];
        for (var muscle in muscles) {
          String muscleName = muscle[kMuscleNameField];
          MuscleGroup muscleGroup =
              MuscleGroup.values[muscle[kMuscleGroupIndexField]];

          Muscle muscleObj =
              Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
          targetedMuscles.add(muscleObj);
        }

        var rawTimeHours = exercise.get(kTimeHoursField);
        int timeHours = int.parse(rawTimeHours.toString());

        var rawTimeMinutes = exercise.get(kTimeMinutesField);
        int timeMinutes = int.parse(rawTimeMinutes.toString());

        var rawTimeSeconds = exercise.get(kTimeSecondsField);
        int timeSeconds = int.parse(rawTimeSeconds.toString());

        var rawWeightKg = exercise.get(kWeightKgField);
        double weightKg = 0;
        if (rawWeightKg.runtimeType == double) {
          weightKg = rawWeightKg;
        } else if (rawWeightKg.runtimeType == int) {
          weightKg = double.parse(rawWeightKg.toString());
        }

        var exerciseRef = exercise;
        DocumentReference referenceToExercise = exerciseRef.reference;

        var exerciseObject = Exercise(
          parentWorkoutReference: workout.workoutReference,
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
          viewers: workout.viewers,
        );
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
        // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
        // reps,sets,targetedMuscles,timeHours,timeMinutes,
        // timeSeconds,userId,weightKg,viewers

        var exerciseName = exercise.get(kNameField);

        var rawRPE = exercise.get(kRpeField);
        int rpe = rawRPE;

        var rawDistanceKm = exercise.get(kDistanceKmField);
        double distanceKm = 0;
        if (rawDistanceKm.runtimeType == double) {
          distanceKm = rawDistanceKm;
        } else if (rawDistanceKm.runtimeType == int) {
          distanceKm = double.parse(rawDistanceKm.toString());
        }

        var rawPercentageOfExertion = exercise.get(kPercentageOfExertionField);
        double percentageOfExertion = 0;
        if (rawPercentageOfExertion.runtimeType == double) {
          percentageOfExertion = rawPercentageOfExertion;
        } else if (rawPercentageOfExertion.runtimeType == int) {
          percentageOfExertion =
              double.parse(rawPercentageOfExertion.toString());
        }

        var rawReps = exercise.get(kRepsField);
        int reps = rawReps;

        var rawSets = exercise.get(kSetsField);
        int sets = rawSets;

        var targetedMuscleGroup = exercise.get(kTargetedMuscleGroupField);

        var muscles = exercise.get(kTargetedMusclesField);
        List<Muscle> targetedMuscles = [];
        for (var muscle in muscles) {
          String muscleName = muscle[kMuscleNameField];
          MuscleGroup muscleGroup =
              MuscleGroup.values[muscle[kMuscleGroupIndexField]];

          Muscle muscleObj =
              Muscle(muscleName: muscleName, muscleGroup: muscleGroup);
          targetedMuscles.add(muscleObj);
        }

        var rawTimeHours = exercise.get(kTimeHoursField);
        int timeHours = int.parse(rawTimeHours.toString());

        var rawTimeMinutes = exercise.get(kTimeMinutesField);
        int timeMinutes = int.parse(rawTimeMinutes.toString());

        var rawTimeSeconds = exercise.get(kTimeSecondsField);
        int timeSeconds = int.parse(rawTimeSeconds.toString());

        var rawWeightKg = exercise.get(kWeightKgField);
        double weightKg = 0;
        if (rawWeightKg.runtimeType == double) {
          weightKg = rawWeightKg;
        } else if (rawWeightKg.runtimeType == int) {
          weightKg = double.parse(rawWeightKg.toString());
        }

        var exerciseRef = exercise;
        DocumentReference referenceToExercise = exerciseRef.reference;

        var exerciseObject = Exercise(
          parentWorkoutReference: workout.workoutReference,
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
          viewers: workout.viewers,
        );

        viewingExercises.add(exerciseObject);
      }
    });

    List<Exercise> exerciseObjects = ownedExercises + viewingExercises;
    return exerciseObjects;
  }
}
