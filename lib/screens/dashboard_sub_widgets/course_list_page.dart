import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/course_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CourseDisplay> coursesLoaded = [];

  @override
  Widget build(BuildContext context) {
    var stream1Owned = _firestore
        .collection(kCoursesCollection)
        .where(kUserIdField, isEqualTo: widget.user.uid)
        .snapshots();
    var stream2Viewing = _firestore
        .collection(kCoursesCollection)
        .where(kViewersField, arrayContains: widget.user.uid)
        .snapshots();

    return ListView(children: [
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
                      Tuple2<AsyncSnapshot<dynamic>, AsyncSnapshot<dynamic>>
                          snapshots) {
                    List<CourseDisplay> ownedCourseWidgets = [];
                    List<CourseDisplay> viewerCourseWidgets = [];
                    List<Course> courseObjects = [];
                    if (snapshots.item1.hasData) {
                      final courses = snapshots.item1.data!.docs;

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
                        List<String>? viewerStrings = [];
                        var viewersIterator = viewersDynamic.iterator;
                        while (viewersIterator.moveNext()) {
                          var current = viewersIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = value.replaceAll(kViewersField + "/", "");
                            viewerStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            viewerStrings.add(currentRef.id);
                          }
                        }

                        var courseRef = course;
                        DocumentReference referenceToCourse1 =
                            courseRef.reference;

                        var courseObject = Course(
                          name: courseName,
                          viewers: viewerStrings,
                          numViewers: viewersDynamic.length,
                          numWorkouts: workoutsDynamic.length,
                          workouts: workoutStrings,
                          courseReference: referenceToCourse1,
                        );
                        courseObjects.add(courseObject);
                      }
                      for (var courseObject in courseObjects) {
                        var courseWidget = CourseDisplay(
                          courseObject: courseObject,
                          viewer: false,
                        );

                        ownedCourseWidgets.add(courseWidget);
                      }
                    }
                    courseObjects = [];
                    if (snapshots.item2.hasData) {
                      final courses = snapshots.item2.data!.docs;
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
                        List<String>? viewerStrings = [];
                        var viewersIterator = viewersDynamic.iterator;
                        while (viewersIterator.moveNext()) {
                          var current = viewersIterator.current;
                          if (current.runtimeType == String) {
                            String value = current;
                            value = value.replaceAll(kViewersField + "/", "");
                            viewerStrings.add(value);
                          } else {
                            DocumentReference currentRef = current;
                            viewerStrings.add(currentRef.id);
                          }
                        }

                        var courseRef = course;
                        DocumentReference referenceToCourse =
                            courseRef.reference;

                        var courseObject = Course(
                          name: courseName,
                          numViewers: viewersDynamic.length,
                          numWorkouts: workoutsDynamic.length,
                          workouts: workoutStrings,
                          courseReference: referenceToCourse,
                          viewers: viewerStrings,
                        );
                        courseObjects.add(courseObject);
                      }
                      for (var courseObject in courseObjects) {
                        var courseWidget = CourseDisplay(
                          courseObject: courseObject,
                          viewer: true,
                        );
                        viewerCourseWidgets.add(courseWidget);
                      }
                    }
                    coursesLoaded = ownedCourseWidgets + viewerCourseWidgets;

                    if (coursesLoaded.isNotEmpty) {
                      return Column(children: coursesLoaded);
                    }
                    return Center(
                      child: Text(
                        kErrorNoCoursesFoundString,
                        textAlign: TextAlign.center,
                        style: kErrorMessageStyle.copyWith(fontSize: 20.0),
                      ),
                    );
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
