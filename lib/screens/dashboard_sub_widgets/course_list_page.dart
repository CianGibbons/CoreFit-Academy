import 'package:corefit_academy/components/course_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/controllers/course_request_controller.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  List<CourseDisplay> coursesLoaded = [];

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
                FutureBuilder(
                    future: getCourses(),
                    builder: (context, snapshot) {
                      List<Course> courseObjects = [];
                      coursesLoaded = [];
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          if (data.runtimeType == List<Course>) {
                            courseObjects = data as List<Course>;
                            for (var courseObject in courseObjects) {
                              var courseWidget = CourseDisplay(
                                courseObject: courseObject,
                                viewer: courseObject.viewer,
                              );
                              coursesLoaded.add(courseWidget);
                            }

                            if (coursesLoaded.isNotEmpty) {
                              return Column(children: coursesLoaded);
                            }

                            if (coursesLoaded.isEmpty) {
                              return Center(
                                child: Text(
                                  kErrorNoCoursesFoundString,
                                  textAlign: TextAlign.center,
                                  style: kErrorMessageStyle.copyWith(
                                      fontSize: 20.0),
                                ),
                              );
                            }
                          }
                        }
                      }
                      return const CircularProgressIndicator();
                    }),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
