import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/custom_number_picker.dart';
import 'package:corefit_academy/components/custom_number_picker_double.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';

class LogExercisePage extends StatefulWidget {
  const LogExercisePage(
      {Key? key,
      required this.targetExercises,
      required this.currentIndex,
      required this.workoutLogReference})
      : super(key: key);

  final List<Exercise> targetExercises;
  final DocumentReference workoutLogReference;
  final int currentIndex;

  @override
  State<LogExercisePage> createState() => _LogExercisePageState();
}

class _LogExercisePageState extends State<LogExercisePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  late int currentSetsValue = widget.targetExercises[widget.currentIndex].sets!;
  late int currentRepsValue = widget.targetExercises[widget.currentIndex].reps!;
  late int currentRPEValue = widget.targetExercises[widget.currentIndex].rpe!;
  late double currentDistanceValue =
      widget.targetExercises[widget.currentIndex].distanceKM!;
  late double currentWeightValue =
      widget.targetExercises[widget.currentIndex].weightKG!;
  late double currentPercentageOfExertionValue =
      widget.targetExercises[widget.currentIndex].percentageOfExertion!;
  late String currentTargetedMuscleGroup =
      widget.targetExercises[widget.currentIndex].targetedMuscleGroup;

  late List<Muscle> currentTargetedMuscles =
      widget.targetExercises[widget.currentIndex].targetedMuscles!;
  late List<Muscle> potentialTargetedMuscles = kMusclesList[0];

  @override
  Widget build(BuildContext context) {
    final _createExerciseFormKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(kLogExerciseTitle),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuBarClick,
            itemBuilder: (BuildContext context) {
              Set<String> activeMenuItems = {kSkipExerciseLogAction};

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
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Form(
                  key: _createExerciseFormKey,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.targetExercises[widget.currentIndex].name,
                            style: kTitleStyle.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      CustomNumberPickerHorizontal(
                        fieldName: kSetsNameFieldLabel,
                        initialValue: currentSetsValue,
                        itemWidth: 60,
                        sendCurrentValue: (int value) {
                          currentSetsValue = value;
                        },
                      ),
                      CustomNumberPickerHorizontal(
                        fieldName: kRepsNameFieldLabel,
                        initialValue: currentRepsValue,
                        itemWidth: 60,
                        sendCurrentValue: (int value) {
                          currentRepsValue = value;
                        },
                      ),
                      CustomNumberPickerHorizontal(
                        fieldName: kREPNameFieldLabel,
                        initialValue: currentRPEValue,
                        maxValue: 10,
                        minValue: 1,
                        itemWidth: 60,
                        sendCurrentValue: (int value) {
                          currentRPEValue = value;
                        },
                      ),
                      CustomNumberPickerDoubleHorizontal(
                        fieldName: kDistanceKMNameFieldLabel,
                        initialValue: currentDistanceValue,
                        maxValue: 200000,
                        step: 200,
                        itemWidth: 60,
                        fontSize: 14.0,
                        sendCurrentValue: (double value) {
                          currentDistanceValue = value;
                        },
                      ),
                      CustomNumberPickerDoubleHorizontal(
                        fieldName: kWeightKGNameFieldLabel,
                        initialValue: currentWeightValue,
                        maxValue: 200.0,
                        step: 0.5,
                        itemWidth: 60,
                        sendCurrentValue: (double value) {
                          currentWeightValue = value;
                        },
                      ),
                      CustomNumberPickerDoubleHorizontal(
                        fieldName: kPercentageOfExertionNameFieldLabel,
                        initialValue: currentPercentageOfExertionValue,
                        maxValue: 100,
                        step: 1,
                        itemWidth: 60,
                        sendCurrentValue: (double value) {
                          currentPercentageOfExertionValue = value;
                        },
                      ),
                      Text(
                        currentTargetedMuscleGroup,
                      ),
                      Text(
                        currentTargetedMuscles.toString(),
                      ),
                      Text(
                        context
                            .read<DurationSelectedProvider>()
                            .value
                            .toString(),
                      ),
                      CustomElevatedButton(
                        onPressed: handleSetTimeClick,
                        child: const Text(kSetTimeAction),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          List<Map> currentListOfMuscles = [];
          for (Muscle targetedMuscle in currentTargetedMuscles) {
            currentListOfMuscles.add({
              kMuscleNameField: targetedMuscle.muscleName,
              kMuscleGroupIndexField: targetedMuscle.muscleGroup.index,
            });
          }

          Duration timeForExercise =
              context.read<DurationSelectedProvider>().value;
          int hours = timeForExercise.inHours;
          int minutes = timeForExercise.inMinutes - (hours * 60);
          int seconds =
              timeForExercise.inSeconds - ((hours * 60 * 60) + (minutes * 60));

          _firestore.collection(kLogExerciseCollection).add({
            kCreatedAtField: DateTime.now(),
            kExerciseReferenceField:
                widget.targetExercises[widget.currentIndex].exerciseReference,
            kUserIdField: _firebase.currentUser!.uid,
            kNameField: widget.targetExercises[widget.currentIndex].name,
            kTargetedMuscleGroupField: currentTargetedMuscleGroup,
            kTargetedMusclesField: currentListOfMuscles,
            kRpeField: currentRPEValue,
            kDistanceKmField: currentDistanceValue,
            kPercentageOfExertionField: currentPercentageOfExertionValue,
            kRepsField: currentRepsValue,
            kSetsField: currentSetsValue,
            kTimeHoursField: hours,
            kTimeMinutesField: minutes,
            kTimeSecondsField: seconds,
            kWeightKgField: currentWeightValue,
            kTargetRpeField: widget.targetExercises[widget.currentIndex].rpe,
            kTargetDistanceKmField:
                widget.targetExercises[widget.currentIndex].distanceKM,
            kTargetPercentageOfExertionField: widget
                .targetExercises[widget.currentIndex].percentageOfExertion,
            kTargetRepsField: widget.targetExercises[widget.currentIndex].reps,
            kTargetSetsField: widget.targetExercises[widget.currentIndex].sets,
            kTargetTimeHoursField:
                widget.targetExercises[widget.currentIndex].timeHours,
            kTargetTimeMinutesField:
                widget.targetExercises[widget.currentIndex].timeMinutes,
            kTargetTimeSecondsField:
                widget.targetExercises[widget.currentIndex].timeSeconds,
            kTargetWeightKgField:
                widget.targetExercises[widget.currentIndex].weightKG,
            kWorkoutLogField: widget.workoutLogReference,
          }).then((value) {
            _firestore
                .collection(kLogWorkoutCollection)
                .doc(widget.workoutLogReference.id)
                .update({
              kExerciseLogsField: FieldValue.arrayUnion([value])
            });
          });
          Navigator.pop(context);
          if (widget.targetExercises.length > widget.currentIndex + 1) {
            var hours =
                widget.targetExercises[widget.currentIndex + 1].timeHours;
            var minutes =
                widget.targetExercises[widget.currentIndex + 1].timeMinutes;
            var seconds =
                widget.targetExercises[widget.currentIndex + 1].timeSeconds;
            context.read<DurationSelectedProvider>().setValue(
                Duration(hours: hours, minutes: minutes, seconds: seconds));
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LogExercisePage(
                targetExercises: widget.targetExercises,
                currentIndex: widget.currentIndex + 1,
                workoutLogReference: widget.workoutLogReference,
              );
            }));
          }
        },
      ),
    );
  }

  void handleSetTimeClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Duration? resultingDuration = await showDurationPicker(
      context: context,
      initialTime: context.read<DurationSelectedProvider>().value,
      baseUnit: BaseUnit.second,
    );
    // Updating the Duration Value Provider so that it is set to the resulting Duration
    context.read<DurationSelectedProvider>().setValue(resultingDuration!);
    // Setting State to ensure that the duration value is updated on the Modal Sheet
    setState(() {});
  }

  void _skipExerciseLog() {
    Navigator.pop(context);
    if (widget.targetExercises.length > widget.currentIndex + 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LogExercisePage(
          targetExercises: widget.targetExercises,
          currentIndex: widget.currentIndex + 1,
          workoutLogReference: widget.workoutLogReference,
        );
      }));
    }
  }

  void handleMenuBarClick(String value) {
    //TODO: Implement Clone Course, Remove Course
    switch (value) {
      case kSkipExerciseLogAction:
        _skipExerciseLog();
        break;
    }
  }
}
