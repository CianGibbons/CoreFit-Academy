import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout_log.dart';
import 'package:corefit_academy/components/workout_log_display.dart';
import 'package:corefit_academy/controllers/workout_log_request_controller.dart';

class LoggedWorkoutsPage extends StatelessWidget {
  const LoggedWorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logged Workouts"),
      ),
      body: FutureBuilder(
        future: getWorkoutLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data.runtimeType == List<WorkoutLog>) {
            List<WorkoutLog> workoutLogs = snapshot.data as List<WorkoutLog>;
            List<Widget> workoutLogDisplay = [];
            if (workoutLogs.isNotEmpty) {
              for (var workoutLog in workoutLogs) {
                var display = WorkoutLogDisplay(workoutLog: workoutLog);
                workoutLogDisplay.add(display);
              }

              return ListView(
                children: workoutLogDisplay,
              );
            } else {
              return Center(
                child: Text(
                  "No Logged Workout were found!",
                  textAlign: TextAlign.center,
                  style: kErrorMessageStyle.copyWith(fontSize: 20),
                ),
              );
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
