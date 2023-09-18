import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';
import 'package:gestion_de_soutenance/screens/admin/admin_root_screen.dart';
import 'package:gestion_de_soutenance/screens/home/admin_home_screen.dart';
import 'package:gestion_de_soutenance/screens/home/teacher_home_screen.dart';
import 'package:gestion_de_soutenance/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import '../screens/home/student_home_screen.dart';
import '../services/auth_service.dart';

Future<void> handleLoggedInUser(bool isLoggedIn, BuildContext context) async {
  AuthService _authService = AuthService();

  // Redirigez l'utilisateur vers une autre page car il est déjà connecté
  _authService.getCurrentUser().then((user) async {
    if (user != null) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user);

      final isFirstAppLaunch = await isFirstLaunch();

      if (isFirstAppLaunch) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('first_launch', false);
        redirectUserToHome(user, context);
      }
    }
  });
}

Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('first_launch') ?? true;
}

void redirectUserToHome(UserModel user, BuildContext context) {
  if (user.role == 'student') {
    print('User is student');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StudentHomeScreen(
          title: 'TEST',
          items: ['List'],
        ),
      ),
    );
  } else if (user.role == 'admin') {
    // Redirigez l'utilisateur vers une autre page car il est déjà connecté
    print('User is admin');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => /**AdminRootScreen()**/ AdminHomeScreen()),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => TeacherHomeScreen(
        title: 'JURY',
        items: ['List'],
      )),
    );
  }
}
