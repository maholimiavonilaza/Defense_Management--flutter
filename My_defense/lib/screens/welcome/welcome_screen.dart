import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/providers/user_provider.dart';
import 'package:gestion_de_soutenance/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/custom_button.dart';
import '../../models/user_model.dart'; // Replace with the actual file path

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel? user = userProvider.user ?? null;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue sur My defense!' + (user != null ? ' ${user.name}' : ''),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Voulez-vous voir les guides de l\' utilisation de cet Apps?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.school,
              size: 80,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  icon: Icons.play_arrow,
                  text: 'Tutoriel',
                  onPressed: () {
                    // Redirect to tutorial screen
                    // Add your navigation code here
                  },
                ),
                SizedBox(width: 20),
                CustomButton(
                  icon: Icons.arrow_forward,
                  text: 'Ignorer',
                  onPressed: () {
                    redirectUserToHome(
                        user ??
                            UserModel(
                                id: 'id',
                                name: 'name',
                                email: 'email',
                                role: 'role',
                                password: 'password',
                                age: 2,
                                parcours: 'parcours',
                                code:'code',),

                        context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
