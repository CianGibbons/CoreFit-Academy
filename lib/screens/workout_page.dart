import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:corefit_academy/widgets/create_exercise_widget.dart';
import 'package:corefit_academy/components/exercise_display.dart';

class WorkoutPage extends StatelessWidget {
  WorkoutPage({Key? key, required this.workoutObject, this.viewer = false})
      : super(key: key);
  bool viewer;
  final Workout workoutObject;

  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseDisplay> workoutsLoaded = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutObject.name),
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
                    StreamBuilder(
                      stream: _firestore
                          .collection('exercises')
                          .where('parentWorkout',
                              isEqualTo: workoutObject.workoutReference)
                          .where('userId',
                              isEqualTo: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        List<ExerciseDisplay> ownedExerciseWidgets = [];
                        List<Exercise> exerciseObjects = [];
                        if (snapshot.hasData) {
                          final exercises = snapshot.data!.docs;
                          for (var exercise in exercises) {
                            // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
                            // reps,sets,targetedMuscles,timeHours,timeMinutes,
                            // timeSeconds,userId,weightKg,viewers

                            var exerciseName = exercise.get('name');

                            var rawRPE = exercise.get('RPE');
                            int rpe = rawRPE;

                            var rawDistanceKm = exercise.get('distanceKm');
                            double distanceKm = 0;
                            if (rawDistanceKm.runtimeType == double) {
                              distanceKm = rawDistanceKm;
                            } else if (rawDistanceKm.runtimeType == int) {
                              distanceKm =
                                  double.parse(rawDistanceKm.toString());
                            }

                            // var parentWorkoutReference = workoutObject.workoutReference;

                            var rawPercentageOfExertion =
                                exercise.get('percentageOfExertion');
                            double percentageOfExertion = 0;
                            if (rawPercentageOfExertion.runtimeType == double) {
                              percentageOfExertion = rawPercentageOfExertion;
                            } else if (rawPercentageOfExertion.runtimeType ==
                                int) {
                              percentageOfExertion = double.parse(
                                  rawPercentageOfExertion.toString());
                            }

                            var rawReps = exercise.get('reps');
                            int reps = rawReps;

                            var rawSets = exercise.get('sets');
                            int sets = rawSets;

                            var muscles = exercise.get('targetedMuscles');
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var rawTimeHours = exercise.get('timeHours');
                            int timeHours = int.parse(rawTimeHours.toString());

                            var rawTimeMinutes = exercise.get('timeMinutes');
                            int timeMinutes =
                                int.parse(rawTimeMinutes.toString());

                            var rawTimeSeconds = exercise.get('timeSeconds');
                            int timeSeconds =
                                int.parse(rawTimeSeconds.toString());

                            var rawWeightKg = exercise.get('weightKg');
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
                              targetedMuscles: targetedMuscles,
                            );

                            exerciseObjects.add(exerciseObject);
                          }
                          for (var exerciseObject in exerciseObjects) {
                            ownedExerciseWidgets.add(ExerciseDisplay(
                              viewer: true,
                              exerciseObject: exerciseObject,
                            ));
                          }
                        }
                        return Column(
                          children: ownedExerciseWidgets,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: _firestore
                          .collection('exercises')
                          .where('parentWorkout',
                              isEqualTo: workoutObject.workoutReference)
                          .where('viewers',
                              arrayContains: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        List<ExerciseDisplay> viewerExerciseWidgets = [];
                        List<Exercise> exerciseObjects = [];
                        if (snapshot.hasData) {
                          final exercises = snapshot.data!.docs;
                          for (var exercise in exercises) {
                            // name,RPE,distanceKm,parentWorkout,percentageOfExertion,
                            // reps,sets,targetedMuscles,timeHours,timeMinutes,
                            // timeSeconds,userId,weightKg,viewers

                            var exerciseName = exercise.get('name');

                            var rawRPE = exercise.get('RPE');
                            int rpe = rawRPE;

                            var rawDistanceKm = exercise.get('distanceKm');
                            double distanceKm = 0;
                            if (rawDistanceKm.runtimeType == double) {
                              distanceKm = rawDistanceKm;
                            } else if (rawDistanceKm.runtimeType == int) {
                              distanceKm =
                                  double.parse(rawDistanceKm.toString());
                            }

                            // var parentWorkoutReference = workoutObject.workoutReference;

                            var rawPercentageOfExertion =
                                exercise.get('percentageOfExertion');
                            double percentageOfExertion = 0;
                            if (rawPercentageOfExertion.runtimeType == double) {
                              percentageOfExertion = rawPercentageOfExertion;
                            } else if (rawPercentageOfExertion.runtimeType ==
                                int) {
                              percentageOfExertion = double.parse(
                                  rawPercentageOfExertion.toString());
                            }

                            var rawReps = exercise.get('reps');
                            int reps = rawReps;

                            var rawSets = exercise.get('sets');
                            int sets = rawSets;

                            var muscles = exercise.get('targetedMuscles');
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var rawTimeHours = exercise.get('timeHours');
                            int timeHours = int.parse(rawTimeHours.toString());

                            var rawTimeMinutes = exercise.get('timeMinutes');
                            int timeMinutes =
                                int.parse(rawTimeMinutes.toString());

                            var rawTimeSeconds = exercise.get('timeSeconds');
                            int timeSeconds =
                                int.parse(rawTimeSeconds.toString());

                            var rawWeightKg = exercise.get('weightKg');
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
                              targetedMuscles: targetedMuscles,
                            );

                            exerciseObjects.add(exerciseObject);
                          }
                          for (var exerciseObject in exerciseObjects) {
                            viewerExerciseWidgets.add(ExerciseDisplay(
                              viewer: true,
                              exerciseObject: exerciseObject,
                            ));
                          }
                        }
                        return Column(
                          children: viewerExerciseWidgets,
                        );
                      },
                    ),
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
    if (!viewer) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) =>
                  //Using a Wrap in order to dynamically fit the modal sheet to the content
                  Wrap(children: [
                    CreateExercisePage(
                      workoutObject: workoutObject,
                    )
                  ]));
        },
      );
    } else {
      return Container();
    }
  }
}
