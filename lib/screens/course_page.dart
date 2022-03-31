import 'package:corefit_academy/components/workout_display.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/widgets/create_workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/controllers/workout_request_controller.dart';
import 'package:corefit_academy/controllers/course_request_controller.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key, required this.courseObject, this.viewer = false})
      : super(key: key);

  final Course courseObject;
  final bool viewer;
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final _addViewerFormKey = GlobalKey<FormState>();
  final _cloneCourseFormKey = GlobalKey<FormState>();

  List<WorkoutDisplay> workoutsLoaded = [];
  TextEditingController addViewerTextEditingController =
      TextEditingController();
  TextEditingController cloneCourseTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseObject.name),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuBarClick,
            itemBuilder: (BuildContext context) {
              Set<String> activeMenuItems = {};
              Set<String> menuItemsOwner = {
                kAddFriendsToCourseAction,
                kDeleteCourseAction,
                kCloneCourseAction,
              };
              Set<String> menuItemsViewer = {
                kAddFriendsToCourseAction,
                kRemoveCourseAction,
                kCloneCourseAction
              };
              if (widget.viewer) {
                activeMenuItems = menuItemsViewer;
              } else {
                activeMenuItems = menuItemsOwner;
              }

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
                FutureBuilder(
                    future: getWorkouts(widget.courseObject),
                    builder: (builder, snapshot) {
                      List<Workout> workoutObjects = [];
                      workoutsLoaded = [];
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          if (data.runtimeType == List<Workout>) {
                            workoutObjects = data as List<Workout>;

                            for (var workoutObject in workoutObjects) {
                              workoutsLoaded.add(WorkoutDisplay(
                                parentCourseObject: widget.courseObject,
                                workoutObject: workoutObject,
                                viewer: workoutObject.viewer,
                              ));
                            }

                            if (workoutsLoaded.isNotEmpty) {
                              return Column(children: workoutsLoaded);
                            }
                            if (workoutsLoaded.isEmpty) {
                              return Text(
                                kErrorNoWorkoutsFoundString,
                                textAlign: TextAlign.center,
                                style:
                                    kErrorMessageStyle.copyWith(fontSize: 20.0),
                              );
                            }
                          }
                        }
                      }

                      return const CircularProgressIndicator();
                    }),
              ],
            ),
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
                Wrap(
              children: [
                CreateWorkoutPage(
                  courseObject: widget.courseObject,
                )
              ],
            ),
          ).whenComplete(() {
            context.read<ErrorMessageStringProvider>().setValue(null);
            // Ensure the page updates with the new Workout with set state
            setState(() {});
          });
        },
      );
    } else {
      return Container();
    }
  }

  void handleMenuBarClick(String value) {
    switch (value) {
      case kAddFriendsToCourseAction:
        displayAddViewerToCourseDialog(context, widget.courseObject,
            workoutsLoaded, addViewerTextEditingController, _addViewerFormKey);
        break;
      case kCloneCourseAction:
        showCloneCourseDialog(context, widget.courseObject,
            cloneCourseTextEditingController, _cloneCourseFormKey);
        break;
      case kDeleteCourseAction:
        showDeleteOwnedCourseDialog(context, widget.courseObject);
        break;
      case kRemoveCourseAction:
        showRemoveViewedCourseDialog(context, widget.courseObject);
        break;
    }
  }
}
