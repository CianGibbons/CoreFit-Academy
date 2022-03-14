// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:corefit_academy/screens/log_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/widgets/create_course_widget.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/dashboard_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/course_list_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/settings_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/logbook_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/providers/valid_workout_selected_provider.dart';
// import 'package:corefit_academy/models/course.dart';
// import 'package:corefit_academy/models/workout.dart';
// import 'package:corefit_academy/models/exercise.dart';
// import 'package:corefit_academy/models/muscle.dart';
// import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _firebase = FirebaseAuth.instance;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      DashboardPage(
        user: widget.user,
      ),
      CourseListPage(
        user: widget.user,
      ),
      LogBook(
        user: widget.user,
      ),
      SettingsPage(
        user: widget.user,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _getFAB(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: kHomePageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.running,
            ),
            label: kCoursePageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            label: kLogbookPageName,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: kSettingsPageName,
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getFAB() {
    // Courses
    if (_selectedIndex == 1) {
      return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            context.read<ValidWorkoutSelectedBoolProvider>().setValue(false);
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) =>
                    //Using a Wrap in order to dynamically fit the modal sheet to the content
                    Wrap(children: [CreateCoursePage()])).whenComplete(() {
              context.read<ErrorMessageStringProvider>().setValue(null);
            });
          });
    } else {
      return Container();
    }
  }

  void _onItemTapped(int index) {
    context.read<ValidWorkoutSelectedBoolProvider>().setValue(false);
    setState(() {
      _selectedIndex = index;
    });
  }
}
