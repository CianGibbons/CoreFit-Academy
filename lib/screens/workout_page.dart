import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/widgets/create_exercise_widget.dart';
import 'package:corefit_academy/components/exercise_display.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';
import 'package:corefit_academy/models/muscle.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage(
      {Key? key, required this.workoutObject, this.viewer = false})
      : super(key: key);
  final bool viewer;
  final Workout workoutObject;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseDisplay> exercisesLoaded = [];
  List<ExerciseDisplay> ownedExerciseWidgetsLoaded = [];
  List<ExerciseDisplay> viewedExerciseWidgetsLoaded = [];

  @override
  Widget build(BuildContext context) {
    var stream1Owned = _firestore
        .collection(kExercisesCollection)
        .where(kParentWorkoutField,
            isEqualTo: widget.workoutObject.workoutReference)
        .where(kUserIdField, isEqualTo: _firebase.currentUser!.uid)
        .snapshots();
    var stream2Viewing = _firestore
        .collection(kExercisesCollection)
        .where(kParentWorkoutField,
            isEqualTo: widget.workoutObject.workoutReference)
        .where(kViewersField, arrayContains: _firebase.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutObject.name),
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
                    StreamBuilder2(
                        streams: Tuple2(stream1Owned, stream2Viewing),
                        builder: (context,
                            Tuple2<AsyncSnapshot<dynamic>,
                                    AsyncSnapshot<dynamic>>
                                snapshots) {
                          List<ExerciseDisplay> ownedExerciseWidgets = [];
                          List<Exercise> exerciseObjects = [];
                          if (snapshots.item1.hasData) {
                            final exercises = snapshots.item1.data!.docs;
                            for (var exercise in exercises) {
                              // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
                              // reps,sets,targetedMuscles,timeHours,timeMinutes,
                              // timeSeconds,userId,weightKg,viewers

                              var exerciseName = exercise.get(kNameField);

                              var rawRPE = exercise.get(kRpeField);
                              int rpe = rawRPE;

                              var rawDistanceKm =
                                  exercise.get(kDistanceKmField);
                              double distanceKm = 0;
                              if (rawDistanceKm.runtimeType == double) {
                                distanceKm = rawDistanceKm;
                              } else if (rawDistanceKm.runtimeType == int) {
                                distanceKm =
                                    double.parse(rawDistanceKm.toString());
                              }

                              var rawPercentageOfExertion =
                                  exercise.get(kPercentageOfExertionField);
                              double percentageOfExertion = 0;
                              if (rawPercentageOfExertion.runtimeType ==
                                  double) {
                                percentageOfExertion = rawPercentageOfExertion;
                              } else if (rawPercentageOfExertion.runtimeType ==
                                  int) {
                                percentageOfExertion = double.parse(
                                    rawPercentageOfExertion.toString());
                              }

                              var rawReps = exercise.get(kRepsField);
                              int reps = rawReps;

                              var rawSets = exercise.get(kSetsField);
                              int sets = rawSets;

                              var targetedMuscleGroup =
                                  exercise.get(kTargetedMuscleGroupField);

                              var muscles = exercise.get(kTargetedMusclesField);
                              List<Muscle> targetedMuscles = [];
                              for (var muscle in muscles) {
                                String muscleName = muscle[kMuscleNameField];
                                MuscleGroup muscleGroup = MuscleGroup
                                    .values[muscle[kMuscleGroupIndexField]];

                                Muscle muscleObj = Muscle(
                                    muscleName: muscleName,
                                    muscleGroup: muscleGroup);
                                targetedMuscles.add(muscleObj);
                              }

                              var rawTimeHours = exercise.get(kTimeHoursField);
                              int timeHours =
                                  int.parse(rawTimeHours.toString());

                              var rawTimeMinutes =
                                  exercise.get(kTimeMinutesField);
                              int timeMinutes =
                                  int.parse(rawTimeMinutes.toString());

                              var rawTimeSeconds =
                                  exercise.get(kTimeSecondsField);
                              int timeSeconds =
                                  int.parse(rawTimeSeconds.toString());

                              var rawWeightKg = exercise.get(kWeightKgField);
                              double weightKg = 0;
                              if (rawWeightKg.runtimeType == double) {
                                weightKg = rawWeightKg;
                              } else if (rawWeightKg.runtimeType == int) {
                                weightKg = double.parse(rawWeightKg.toString());
                              }

                              var exerciseRef = exercise;
                              DocumentReference referenceToExercise =
                                  exerciseRef.reference;

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
                                viewers: widget.workoutObject.viewers,
                              );

                              exerciseObjects.add(exerciseObject);
                            }
                            for (var exerciseObject in exerciseObjects) {
                              ExerciseDisplay current = ExerciseDisplay(
                                viewer: false,
                                exerciseObject: exerciseObject,
                              );
                              ownedExerciseWidgets.add(current);
                            }
                            ownedExerciseWidgetsLoaded = ownedExerciseWidgets;
                            exercisesLoaded = viewedExerciseWidgetsLoaded +
                                ownedExerciseWidgetsLoaded;
                          }
                          List<ExerciseDisplay> viewerExerciseWidgets = [];
                          exerciseObjects = [];
                          if (snapshots.item2.hasData) {
                            final exercises = snapshots.item2.data!.docs;
                            for (var exercise in exercises) {
                              // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
                              // reps,sets,targetedMuscles,timeHours,timeMinutes,
                              // timeSeconds,userId,weightKg,viewers

                              var exerciseName = exercise.get(kNameField);

                              var rawRPE = exercise.get(kRpeField);
                              int rpe = rawRPE;

                              var rawDistanceKm =
                                  exercise.get(kDistanceKmField);
                              double distanceKm = 0;
                              if (rawDistanceKm.runtimeType == double) {
                                distanceKm = rawDistanceKm;
                              } else if (rawDistanceKm.runtimeType == int) {
                                distanceKm =
                                    double.parse(rawDistanceKm.toString());
                              }

                              var rawPercentageOfExertion =
                                  exercise.get(kPercentageOfExertionField);
                              double percentageOfExertion = 0;
                              if (rawPercentageOfExertion.runtimeType ==
                                  double) {
                                percentageOfExertion = rawPercentageOfExertion;
                              } else if (rawPercentageOfExertion.runtimeType ==
                                  int) {
                                percentageOfExertion = double.parse(
                                    rawPercentageOfExertion.toString());
                              }

                              var rawReps = exercise.get(kRepsField);
                              int reps = rawReps;

                              var rawSets = exercise.get(kSetsField);
                              int sets = rawSets;

                              var targetedMuscleGroup =
                                  exercise.get(kTargetedMuscleGroupField);

                              var muscles = exercise.get(kTargetedMusclesField);
                              List<Muscle> targetedMuscles = [];
                              for (var muscle in muscles) {
                                String muscleName = muscle[kMuscleNameField];
                                MuscleGroup muscleGroup = MuscleGroup
                                    .values[muscle[kMuscleGroupIndexField]];

                                Muscle muscleObj = Muscle(
                                    muscleName: muscleName,
                                    muscleGroup: muscleGroup);
                                targetedMuscles.add(muscleObj);
                              }

                              var rawTimeHours = exercise.get(kTimeHoursField);
                              int timeHours =
                                  int.parse(rawTimeHours.toString());

                              var rawTimeMinutes =
                                  exercise.get(kTimeMinutesField);
                              int timeMinutes =
                                  int.parse(rawTimeMinutes.toString());

                              var rawTimeSeconds =
                                  exercise.get(kTimeSecondsField);
                              int timeSeconds =
                                  int.parse(rawTimeSeconds.toString());

                              var rawWeightKg = exercise.get(kWeightKgField);
                              double weightKg = 0;
                              if (rawWeightKg.runtimeType == double) {
                                weightKg = rawWeightKg;
                              } else if (rawWeightKg.runtimeType == int) {
                                weightKg = double.parse(rawWeightKg.toString());
                              }

                              var exerciseRef = exercise;
                              DocumentReference referenceToExercise =
                                  exerciseRef.reference;

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
                                viewers: widget.workoutObject.viewers,
                              );

                              exerciseObjects.add(exerciseObject);
                            }
                            for (var exerciseObject in exerciseObjects) {
                              ExerciseDisplay current = ExerciseDisplay(
                                viewer: true,
                                exerciseObject: exerciseObject,
                              );
                              viewerExerciseWidgets.add(current);
                            }
                            viewedExerciseWidgetsLoaded = viewerExerciseWidgets;

                            exercisesLoaded = viewedExerciseWidgetsLoaded +
                                ownedExerciseWidgetsLoaded;
                          }
                          if (exercisesLoaded.isNotEmpty) {
                            return Column(
                              children: exercisesLoaded,
                            );
                          }
                          return Center(
                            child: Text(
                              kErrorNoExercisesFoundString,
                              textAlign: TextAlign.center,
                              style:
                                  kErrorMessageStyle.copyWith(fontSize: 20.0),
                            ),
                          );
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
            context.read<ErrorMessageStringProvider>().setValue(null);
            context
                .read<DurationSelectedProvider>()
                .setValue(const Duration(hours: 0, minutes: 0, seconds: 0));
          });
        },
      );
    } else {
      return Container();
    }
  }
}
