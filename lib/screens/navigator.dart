import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/widgets/create_course_widget.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/landing_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/settings_page.dart';
import 'package:corefit_academy/screens/dashboard_sub_widgets/logbook_page.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;
  String testString = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      LandingPage(
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Logbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: _getFAB(),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  Widget _getFAB() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) =>
                    //Using a Wrap in order to dynamically fit the modal sheet to the content
                    Wrap(children: [CreateCoursePage(user: widget.user)]));
          });
    } else {
      return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
