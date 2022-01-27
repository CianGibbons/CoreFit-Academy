import 'package:corefit_academy/screens/landing_page.dart';
import 'package:corefit_academy/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  // If I wanted to pass in an int to this page upon Navigation, would need to
  // use onGeneralRoute in MaterialApp
  // final int value;
  // const LandingPage(this.value, {Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LandingPage(),
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
