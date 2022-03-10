import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/screens/log_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/widgets/create_course_widget.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/dashboard_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/course_list_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/settings_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/logbook_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/providers/valid_workout_selected_provider.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  Course? selectedCourse;
  Workout? selectedWorkout;

  int _selectedIndex = 0;
  String testString = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      DashboardPage(
        user: widget.user,
      ),
      CourseListPage(
        user: widget.user,
      ),
      LogBook(
        user: widget.user,
        sendData: (Course course, Workout workout) {
          selectedCourse = course;
          selectedWorkout = workout;
        },
      ),
      SettingsPage(
        user: widget.user,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _getFAB(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: kHomePageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.running,
            ),
            label: kCoursePageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            label: kLogbookPageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: kSettingsPageName,
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getFAB() {
    // Courses
    if (_selectedIndex == 1) {
      return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            context.read<ValidWorkoutSelectedBoolProvider>().setValue(false);
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) =>
                    //Using a Wrap in order to dynamically fit the modal sheet to the content
                    Wrap(children: [CreateCoursePage()])).whenComplete(() {
              context.read<ErrorMessageStringProvider>().setValue(null);
            });
          });
    }
    //Logbook
    else if (_selectedIndex == 2) {
      if (context.watch<ValidWorkoutSelectedBoolProvider>().value!) {
        return FloatingActionButton(
          child: const Icon(FontAwesomeIcons.pencilAlt),
          onPressed: () async {
            if (selectedCourse != null && selectedWorkout != null) {
              var exerciseData = await getExercises(selectedWorkout!);

              if (exerciseData.runtimeType == List<Exercise>) {
                List<Exercise> exercises = exerciseData as List<Exercise>;
                int currentIndex = 0;
                context.read<DurationSelectedProvider>().setValue(Duration(
                    hours: exercises[currentIndex].timeHours,
                    minutes: exercises[currentIndex].timeMinutes,
                    seconds: exercises[currentIndex].timeSeconds));
                var workoutLogReference =
                    await _firestore.collection(kLogWorkoutCollection).add({
                  kWorkoutLogIdField: _firebase.currentUser!.uid.toString() +
                      DateTime.now().toIso8601String(),
                  kExercisesField: []
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LogExercisePage(
                    targetExercises: exercises,
                    currentIndex: currentIndex,
                    workoutLogReference: workoutLogReference,
                  );
                }));
              }
            }
          },
        );
      }
      return Container();
    } else {
      return Container();
    }
  }

  void _onItemTapped(int index) {
    context.read<ValidWorkoutSelectedBoolProvider>().setValue(false);
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<dynamic> getExercises(Workout workout) async {
    var snapshot1Owned = await _firestore
        .collection(kExercisesCollection)
        .where(kParentWorkoutField, isEqualTo: workout.workoutReference)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .get();
    var snapshot2Viewing = await _firestore
        .collection(kExercisesCollection)
        .where(kParentWorkoutField, isEqualTo: workout.workoutReference)
        .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
        .get();

    List<Exercise> ownedExercises = [];
    List<Exercise> viewingExercises = [];

    if (snapshot1Owned.docs.isNotEmpty) {
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
    }
    if (snapshot2Viewing.docs.isNotEmpty) {
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
    }

    List<Exercise> exerciseObjects = ownedExercises + viewingExercises;
    return exerciseObjects;
  }
}
