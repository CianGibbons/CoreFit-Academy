import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/screens/course_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourseDisplay extends StatelessWidget {
  CourseDisplay({Key? key, required this.courseObject, this.viewer = false})
      : super(key: key);
  bool viewer;
  final Course courseObject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursePage(
              viewer: viewer,
              courseObject: courseObject,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      courseObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    Text("Number of Workouts in Course: " +
                        courseObject.numWorkouts.toString()),
                  ],
                ),
              ),
              Container(
                child: viewer
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(FontAwesomeIcons.pencilAlt),
              )
            ],
          ),
        ),
      ),
    );
  }
}
