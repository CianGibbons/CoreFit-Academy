import 'package:corefit_academy/widgets/create_course_widget.dart';
import 'package:corefit_academy/screens/main_page_sub_widgets/landing_page.dart';
import 'package:corefit_academy/screens/main_page_sub_widgets/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/screens/main_page_sub_widgets/logbook_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LandingPage(),
    LogBook(),
    SettingsPage(),
  ];

  // ignore: unused_field
  final _auth = FirebaseAuth.instance;

  String testString = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
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
            //TODO: Create new Course Pop Up;
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) =>
                    //Using a Wrap in order to dynamically fit the modal sheet to the content
                    Wrap(children: const [CreateCoursePage()]));
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
