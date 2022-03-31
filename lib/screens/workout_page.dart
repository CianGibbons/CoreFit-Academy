import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/widgets/create_exercise_widget.dart';
import 'package:corefit_academy/components/exercise_display.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/controllers/exercise_request_controller.dart';
import 'package:corefit_academy/controllers/workout_request_controller.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage(
      {Key? key,
      required this.parentCourseObject,
      required this.workoutObject,
      this.viewer = false})
      : super(key: key);
  final bool viewer;
  final Workout workoutObject;
  final Course parentCourseObject;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseDisplay> exercisesLoaded = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.viewer
          ? AppBar(title: Text(widget.workoutObject.name))
          : AppBar(
              title: Text(widget.workoutObject.name),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: handleMenuBarClick,
                  itemBuilder: (BuildContext context) {
                    Set<String> activeMenuItems = {kDeleteWorkoutAction};
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
                    FutureBuilder(
                        future: getExercises(widget.workoutObject),
                        builder: (builder, snapshot) {
                          List<Exercise> exerciseObjects = [];
                          exercisesLoaded = [];
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              var data = snapshot.data;
                              if (data.runtimeType == List<Exercise>) {
                                exerciseObjects = data as List<Exercise>;
                                for (var exerciseObject in exerciseObjects) {
                                  ExerciseDisplay current = ExerciseDisplay(
                                    viewer: exerciseObject.viewer,
                                    exerciseObject: exerciseObject,
                                    parentWorkoutObject: widget.workoutObject,
                                    grandparentCourseObject:
                                        widget.parentCourseObject,
                                  );
                                  exercisesLoaded.add(current);
                                }

                                if (exercisesLoaded.isNotEmpty) {
                                  return Column(children: exercisesLoaded);
                                }

                                if (exercisesLoaded.isEmpty) {
                                  return Center(
                                    child: Text(
                                      kErrorNoExercisesFoundString,
                                      textAlign: TextAlign.center,
                                      style: kErrorMessageStyle.copyWith(
                                          fontSize: 20.0),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                          return const CircularProgressIndicator();
                        }),
                  ],
                ),
              ),
            ],
          ),
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
              builder: (context) {
                // Using a Wrap in order to dynamically fit the modal sheet
                // to the content
                return Wrap(
                  children: [
                    CreateExercisePage(
                      workoutObject: widget.workoutObject,
                    )
                  ],
                );
              }).whenComplete(() {
            // Resetting the Error message to null and the time picker to null
            // and 0 after modal sheet is dismissed.
            context.read<ErrorMessageStringProvider>().setValue(null);
            context
                .read<DurationSelectedProvider>()
                .setValue(const Duration(hours: 0, minutes: 0, seconds: 0));
            //Ensure new Exercise is added by re-triggering the FutureBuilder
            setState(() {});
          });
        },
      );
    } else {
      return Container();
    }
  }

  void handleMenuBarClick(String value) {
    switch (value) {
      case kDeleteWorkoutAction:
        showDeleteOwnedWorkoutDialog(context, widget.workoutObject,
            widget.parentCourseObject, widget.viewer);
        break;
    }
  }
}
