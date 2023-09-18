import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';
import 'package:gestion_de_soutenance/screens/students/event_screen_student.dart';
import 'package:gestion_de_soutenance/services/auth_service.dart';
import 'package:gestion_de_soutenance/services/student_service.dart';
import '../../main.dart';

import '../admin/event/event_screen.dart';
import '../students/indexStudent.dart';
import '../students/noteStudent.dart';

class StudentHomeScreen extends StatefulWidget {
  final String title;
  final List<String> items;

  StudentHomeScreen({required this.title, required this.items});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;
  int _counter = 0;
  late Future<UserModel?> _currentUserFuture;
  late List<Widget> _widgetOptions; // Declare the list without initialization

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _authService.getCurrentUser();

    // Initialize _widgetOptions after _currentUserFuture is assigned
    _widgetOptions = <Widget>[
      IndexStudent(userFuture: _currentUserFuture),
      EventScreenStudent(userFuture: _currentUserFuture),
      NoteStudent(userFuture: _currentUserFuture),
    ];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Bouton de déconnexion dans l'app bar
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 4),
                Text('Déconnexion'),
              ],
            ),
            onPressed: () => {
              _authService.signOut(),
              // use material page route to redirect to the sign in screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              ),
            },
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_currentIndex)),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Lists'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.event),
            title: Text('Planning'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.bar_chart),
            title: Text('Result'),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
