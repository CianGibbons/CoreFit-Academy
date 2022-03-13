import 'package:corefit_academy/models/exercise_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseLogDisplay extends StatelessWidget {
  const ExerciseLogDisplay({Key? key, required this.exerciseLog})
      : super(key: key);
  final ExerciseLog exerciseLog;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              exerciseLog.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text("Logged at " +
                DateFormat('dd/MM/yyyy – kk:mm:ss')
                    .format(exerciseLog.createdAt)),
            Text(
              "Sets: ${exerciseLog.sets}\t(Expected: ${exerciseLog.targetSets})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Reps: ${exerciseLog.reps}\t(Expected: ${exerciseLog.targetReps})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Distance (KM): ${exerciseLog.distanceKM}\t(Expected: ${exerciseLog.targetDistanceKM})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Weight (KG): ${exerciseLog.weightKG.toString()}\t(Expected: ${exerciseLog.targetWeightKG})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "RPE: ${exerciseLog.rpe}\t(Expected: ${exerciseLog.targetRpe})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Percentage of Exertion: ${exerciseLog.percentageOfExertion}%\t(Expected: ${exerciseLog.targetPercentageOfExertion}%)",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Time: ${exerciseLog.getTotalTime()}\t(Expected: ${exerciseLog.getTotalTargetTime()})",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Targeted Muscle Group: " + exerciseLog.targetedMuscleGroup,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              "Targeted Muscles:\n\t\t\t\t\t\t" +
                  exerciseLog.targetedMuscles!.join('\n\t\t\t\t\t\t'),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
