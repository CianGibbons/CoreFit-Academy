import 'package:corefit_academy/models/workout_log.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/exercise_log.dart';
import 'package:corefit_academy/components/exercise_log_display.dart';
import 'package:corefit_academy/controllers/exercise_log_request_controller.dart';
import 'package:corefit_academy/controllers/workout_log_request_controller.dart';

class ExerciseLogPage extends StatefulWidget {
  const ExerciseLogPage({Key? key, required this.workoutLog}) : super(key: key);

  final WorkoutLog workoutLog;

  @override
  State<ExerciseLogPage> createState() => _ExerciseLogPageState();
}

class _ExerciseLogPageState extends State<ExerciseLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutLog.workoutName),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuBarClick,
            itemBuilder: (BuildContext context) {
              Set<String> activeMenuItems = {kDeleteWorkoutLogAction};

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
      body: FutureBuilder(
          future: getExerciseLogs(widget.workoutLog),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data.runtimeType == List<ExerciseLog>) {
              List<ExerciseLog> exerciseLogs =
                  snapshot.data as List<ExerciseLog>;
              List<Widget> exerciseLogDisplay = [];
              if (exerciseLogs.isNotEmpty) {
                for (var exerciseLog in exerciseLogs) {
                  var display = ExerciseLogDisplay(exerciseLog: exerciseLog);
                  exerciseLogDisplay.add(display);
                }

                return ListView(
                  children: exerciseLogDisplay,
                );
              } else {
                return Center(
                  child: Text(
                    kErrorNoLoggedExercisesFoundString,
                    textAlign: TextAlign.center,
                    style: kErrorMessageStyle.copyWith(fontSize: 20),
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  void handleMenuBarClick(String value) {
    switch (value) {
      case kDeleteWorkoutLogAction:
        showDeleteWorkoutLogDialog(context, widget.workoutLog);
        break;
    }
  }
}
