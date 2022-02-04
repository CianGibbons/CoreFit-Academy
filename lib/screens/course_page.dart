import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/workout_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/widgets/create_workout_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key, required this.courseObject, this.viewer = false})
      : super(key: key);

  final Course courseObject;
  final bool viewer;
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WorkoutDisplay> workoutsLoaded = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseObject.name),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Add Friends To Course', 'Delete Course', 'Clone Course'}
                  .map((String choice) {
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
                    StreamBuilder(
                      stream: _firestore
                          .collection('workouts')
                          .where('parentCourse',
                              isEqualTo: widget.courseObject.courseReference)
                          .where('userId',
                              isEqualTo: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<WorkoutDisplay> ownedWorkoutWidgets = [];
                        List<Workout> workoutObjects = [];
                        if (snapshot.hasData) {
                          final workouts = snapshot.data!.docs;

                          for (var workout in workouts) {
                            var workoutName = workout.get('name');

                            List exerciseDynamic = List.empty();
                            exerciseDynamic = workout.get('exercises');
                            // List<DocumentReference> exerciseList = [];
                            // for (DocumentReference exercise
                            //     in exerciseDynamic) {
                            //   exerciseList.add(exercise);
                            // }

                            var muscles = workout.get('targetedMuscles');
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var workoutRef = workout;
                            DocumentReference referenceToWorkout =
                                workoutRef.reference;

                            var workoutObject = Workout(
                              workoutReference: referenceToWorkout,
                              name: workoutName,
                              numExercises: exerciseDynamic.length,
                              targetedMuscles: targetedMuscles,
                            );

                            workoutObjects.add(workoutObject);
                          }

                          for (var workoutObject in workoutObjects) {
                            ownedWorkoutWidgets.add(WorkoutDisplay(
                              workoutObject: workoutObject,
                              viewer: false,
                            ));
                          }
                        }
                        for (var workoutWidget in ownedWorkoutWidgets) {
                          if (workoutsLoaded.contains(workoutWidget)) {
                            ownedWorkoutWidgets.remove(workoutWidget);
                          }
                        }
                        return Column(
                          children: ownedWorkoutWidgets,
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: _firestore
                          .collection('workouts')
                          .where('parentCourse',
                              isEqualTo: widget.courseObject.courseReference)
                          .where('viewers',
                              arrayContains: _firebase.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        List<WorkoutDisplay> viewerWorkoutWidgets = [];
                        List<Workout> workoutObjects = [];
                        if (snapshot.hasData) {
                          final workouts = snapshot.data!.docs;

                          for (var workout in workouts) {
                            var workoutName = workout.get('name');

                            List exerciseDynamic = List.empty();
                            exerciseDynamic = workout.get('exercises');
                            List<DocumentReference> exerciseList = [];
                            for (DocumentReference exercise
                                in exerciseDynamic) {
                              exerciseList.add(exercise);
                            }

                            var muscles = workout.get('targetedMuscles');
                            List<String> targetedMuscles =
                                List<String>.from(muscles);

                            var workoutRef = workout;
                            DocumentReference referenceToWorkout =
                                workoutRef.reference;

                            var workoutObject = Workout(
                              workoutReference: referenceToWorkout,
                              name: workoutName,
                              exercises: exerciseList,
                              numExercises: exerciseList.length,
                              targetedMuscles: targetedMuscles,
                            );

                            workoutObjects.add(workoutObject);
                          }

                          for (var workoutObject in workoutObjects) {
                            viewerWorkoutWidgets.add(WorkoutDisplay(
                              workoutObject: workoutObject,
                              viewer: true,
                            ));
                          }
                        }
                        for (var workoutWidget in viewerWorkoutWidgets) {
                          if (workoutsLoaded.contains(workoutWidget)) {
                            viewerWorkoutWidgets.remove(workoutWidget);
                          }
                        }
                        return Column(
                          children: viewerWorkoutWidgets,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
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
              builder: (context) =>
                  //Using a Wrap in order to dynamically fit the modal sheet to the content
                  Wrap(children: [
                    CreateWorkoutPage(
                      courseObject: widget.courseObject,
                    )
                  ]));
        },
      );
    } else {
      return Container();
    }
  }
}

void handleClick(String value) {
  switch (value) {
    case 'Logout':
      break;
    case 'Settings':
      break;
  }
}
