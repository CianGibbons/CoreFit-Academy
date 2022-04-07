import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/controllers/course_request_controller.dart';
import 'package:corefit_academy/controllers/workout_request_controller.dart';
import 'package:corefit_academy/controllers/exercise_request_controller.dart';
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
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';
import 'package:corefit_academy/screens/log_exercise_page.dart';
import 'package:corefit_academy/controllers/workout_log_request_controller.dart';

class LogBook extends StatefulWidget {
  const LogBook({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<LogBook> createState() => _LogBookState();
}

class _LogBookState extends State<LogBook> {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoggedWorkoutsPage();
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
                            kLogWorkoutActionButton,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(FontAwesomeIcons.pencil, size: 20.0),
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
                          var workoutLogReference = await addWorkoutLog(
                              selectedCourse!, selectedWorkout!);
                          var hours = exercises[currentIndex].timeHours;
                          var minutes = exercises[currentIndex].timeMinutes;
                          var seconds = exercises[currentIndex].timeSeconds;
                          context.read<DurationSelectedProvider>().setValue(
                              Duration(
                                  hours: hours,
                                  minutes: minutes,
                                  seconds: seconds));
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
}
