import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/course_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key, required this.user}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('courses')
                      .where('userId', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot1) {
                    List<CourseDisplay> ownedCourseWidgets = [];
                    if (snapshot1.hasData) {
                      final courses1 = snapshot1.data!.docs;
                      List<Course> courseObjects1 = [];
                      for (var course1 in courses1) {
                        var courseName1 = course1.get('name');

                        // // print(course1.data());
                        // // print(course1.get('workouts'));
                        // List<DocumentReference<Map<String, dynamic>>>
                        //     workoutsDynamic1 = course1.get('workouts');
                        //
                        // List<DocumentReference> workoutsList1 = [];
                        // for (DocumentReference workout1 in workoutsDynamic1) {
                        //   workoutsList1.add(workout1);
                        // }

                        List workoutsDynamic1 = course1.get('workouts');

                        var courseRef1 = course1;
                        DocumentReference referenceToCourse1 =
                            courseRef1.reference;

                        var courseObject1 = Course(
                          name: courseName1,
                          // workouts: workoutsList1,
                          numWorkouts: workoutsDynamic1.length,
                          courseReference: referenceToCourse1,
                        );
                        courseObjects1.add(courseObject1);
                      }
                      for (var courseObject1 in courseObjects1) {
                        var courseWidget1 = CourseDisplay(
                          courseObject: courseObject1,
                          viewer: false,
                        );

                        ownedCourseWidgets.add(courseWidget1);
                      }

                      return Column(
                        children: ownedCourseWidgets,
                      );
                    }
                    return Container();
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('courses')
                      .where('viewers', arrayContains: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<CourseDisplay> ownedCourseWidgets = [];
                    if (snapshot.hasData) {
                      final courses = snapshot.data!.docs;
                      List<Course> courseObjects = [];
                      for (var course in courses) {
                        var courseName = course.get('name');
                        // // print(course.data());
                        // // print(course.get('workouts'));
                        // List<DocumentReference<Map<String, dynamic>>>
                        //     workoutsDynamic = course.get('workouts');
                        //
                        // List<DocumentReference> workoutsList = [];
                        // for (DocumentReference workout in workoutsDynamic) {
                        //   workoutsList.add(workout);
                        // }
                        List workoutsDynamic = course.get('workouts');

                        var courseRef = course;
                        DocumentReference referenceToCourse =
                            courseRef.reference;

                        var courseObject = Course(
                          name: courseName,
                          // workouts: workoutsList,
                          numWorkouts: workoutsDynamic.length,
                          courseReference: referenceToCourse,
                        );
                        courseObjects.add(courseObject);
                      }
                      for (var courseObject in courseObjects) {
                        var courseWidget = CourseDisplay(
                          courseObject: courseObject,
                          viewer: true,
                        );
                        ownedCourseWidgets.add(courseWidget);
                      }
                      return Column(
                        children: ownedCourseWidgets,
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
