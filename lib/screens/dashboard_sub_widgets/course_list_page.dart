import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/course_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseListPage extends StatelessWidget {
  CourseListPage({Key? key, required this.user}) : super(key: key);
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
                      .collection(kCoursesCollection)
                      .where(kUserIdField, isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot1) {
                    List<CourseDisplay> ownedCourseWidgets = [];
                    if (snapshot1.hasData) {
                      final courses1 = snapshot1.data!.docs;
                      List<Course> courseObjects1 = [];
                      for (var course1 in courses1) {
                        var courseName1 = course1.get(kNameField);

                        List workoutsDynamic1 = course1.get(kWorkoutsField);
                        List<String>? workoutStrings = [];

                        var workoutsIterator = workoutsDynamic1.iterator;
                        while (workoutsIterator.moveNext()) {
                          var current = workoutsIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = value.replaceAll(kWorkoutsField + "/", "");
                            workoutStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            workoutStrings.add(currentRef.id);
                          }
                        }

                        List viewersDynamic1 = course1.get(kViewersField);

                        var courseRef1 = course1;
                        DocumentReference referenceToCourse1 =
                            courseRef1.reference;

                        var courseObject1 = Course(
                          name: courseName1,
                          numViewers: viewersDynamic1.length,
                          numWorkouts: workoutsDynamic1.length,
                          workouts: workoutStrings,
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
                      .collection(kCoursesCollection)
                      .where(kViewersField, arrayContains: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<CourseDisplay> ownedCourseWidgets = [];
                    if (snapshot.hasData) {
                      final courses = snapshot.data!.docs;
                      List<Course> courseObjects = [];
                      for (var course in courses) {
                        var courseName = course.get(kNameField);

                        List workoutsDynamic = course.get(kWorkoutsField);
                        List<String>? workoutStrings = [];

                        var workoutsIterator = workoutsDynamic.iterator;
                        while (workoutsIterator.moveNext()) {
                          var current = workoutsIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = value.replaceAll(kWorkoutsField + "/", "");
                            workoutStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            workoutStrings.add(currentRef.id);
                          }
                        }

                        List viewersDynamic = course.get(kViewersField);

                        var courseRef = course;
                        DocumentReference referenceToCourse =
                            courseRef.reference;

                        var courseObject = Course(
                          name: courseName,
                          numViewers: viewersDynamic.length,
                          numWorkouts: workoutsDynamic.length,
                          workouts: workoutStrings,
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
