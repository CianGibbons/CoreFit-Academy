import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/models/exercise_log.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';

import 'package:corefit_academy/screens/logged_workouts_page.dart';

class ExerciseLogDisplay extends StatefulWidget {
  const ExerciseLogDisplay({Key? key, required this.exerciseLog})
      : super(key: key);
  final ExerciseLog exerciseLog;

  @override
  State<ExerciseLogDisplay> createState() => _ExerciseLogDisplayState();
}

class _ExerciseLogDisplayState extends State<ExerciseLogDisplay> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(1),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: _showDeleteOwnedExerciseLogDialog,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.exerciseLog.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text("Logged at " +
                  DateFormat('dd/MM/yyyy – kk:mm:ss')
                      .format(widget.exerciseLog.createdAt)),
              Text(
                "Sets: ${widget.exerciseLog.sets}\t(Expected: ${widget.exerciseLog.targetSets})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Reps: ${widget.exerciseLog.reps}\t(Expected: ${widget.exerciseLog.targetReps})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Distance (KM): ${widget.exerciseLog.distanceKM}\t(Expected: ${widget.exerciseLog.targetDistanceKM})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Weight (KG): ${widget.exerciseLog.weightKG.toString()}\t(Expected: ${widget.exerciseLog.targetWeightKG})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "RPE: ${widget.exerciseLog.rpe}\t(Expected: ${widget.exerciseLog.targetRpe})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Percentage of Exertion: ${widget.exerciseLog.percentageOfExertion}%\t(Expected: ${widget.exerciseLog.targetPercentageOfExertion}%)",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Time: ${widget.exerciseLog.getTotalTime()}\t(Expected: ${widget.exerciseLog.getTotalTargetTime()})",
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Targeted Muscle Group: " +
                    widget.exerciseLog.targetedMuscleGroup,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                "Targeted Muscles:\n\t\t\t\t\t\t" +
                    widget.exerciseLog.targetedMuscles!.join('\n\t\t\t\t\t\t'),
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteOwnedExerciseLog(context) async {
    await _firestore
        .collection(kLogWorkoutCollection)
        .doc(widget.exerciseLog.parentWorkoutLogRef.id)
        .update({
      kExerciseLogsField:
          FieldValue.arrayRemove([widget.exerciseLog.exerciseLogRef])
    }).then((value) async {
      print(widget.exerciseLog.exerciseLogRef);
      _firestore
          .collection(kLogExerciseCollection)
          .doc(widget.exerciseLog.exerciseLogRef.id)
          .delete();
    });
  }

  void _showDeleteOwnedExerciseLogDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              child: AlertDialog(
            title: const Text(kDeleteExerciseLogAction),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    _deleteOwnedExerciseLog(context);
                    //Pop the dialog
                    Navigator.pop(context);
                    //Pop out of Exercise logs page
                    Navigator.pop(context);
                    //Pop out of Workout Logs Page
                    Navigator.pop(context);
                    //Push the User back to the Workout Logs Page in order to re-render the Logs Page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LogsPage();
                    }));
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
}
