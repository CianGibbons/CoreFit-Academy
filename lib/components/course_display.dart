import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/screens/course_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/utilities/constants.dart';

class CourseDisplay extends StatefulWidget {
  const CourseDisplay(
      {Key? key, required this.courseObject, this.viewer = false})
      : super(key: key);
  final bool viewer;
  final Course courseObject;

  @override
  State<CourseDisplay> createState() => _CourseDisplayState();
}

class _CourseDisplayState extends State<CourseDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("Course: " + widget.courseObject.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursePage(
              viewer: widget.viewer,
              courseObject: widget.courseObject,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
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
                      widget.courseObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    Text(kShowNumberWorkoutsForCourse +
                        widget.courseObject.numWorkouts.toString()),
                    Text(kShowNumberViewersForCourse +
                        widget.courseObject.numViewers.toString()),
                  ],
                ),
              ),
              Container(
                child: widget.viewer
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(FontAwesomeIcons.pencil),
              )
            ],
          ),
        ),
      ),
    );
  }
}
