import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/sessionSoutenance.dart';
import 'package:gestion_de_soutenance/screens/admin/joinSession.dart';
import 'package:gestion_de_soutenance/services/sessionSoutenanceService.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import '../../models/session_model.dart';
import '../../services/session_service.dart';
//import '../admin/joinSession.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final SessionSoutenanceService sessionSoutenanceService = SessionSoutenanceService();
  final TextEditingController anneeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My defence"),
        actions: [
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
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenue sur la page Admin🎓",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 150, 28, 28),
                ),
              ),
              SizedBox(height: 10), // Ajustement de l'espace
              Text(
                "Gestion de soutenances",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              _buildColoredButton(
                onPressed: () {
                 Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => joinSessionPage(),
                    ),
                  );
                },
                icon: Icons.arrow_circle_right,
                label: "Gerer une session",
                colors: [
                  Color.fromRGBO(228, 86, 110, 1),
                  Color.fromRGBO(232, 105, 55, 1)
                ],
              ),

              SizedBox(height: 25),
              _buildColoredButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Ajouter un nouveau session'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: anneeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Annee'),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: typeController,
                              decoration: InputDecoration(labelText: 'Type'),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: codeController,
                              decoration: InputDecoration(labelText: 'Code'),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              int annee = int.tryParse(anneeController.text) ?? 0;
                              String code = codeController.text.trim();
                              String type = typeController.text.trim();

                              SessionSoutenanceModel session = SessionSoutenanceModel(
                                id: '',
                                type: type, // Remplacez par l'ID de l'étudiant (vous pouvez générer un ID unique ici ou laisser vide si Firebase se chargera de le générer)
                                annee: annee,
                                code: code,
                              );

                             sessionSoutenanceService.addSession(session);

                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Session enregistré'),
                                    content: Text(
                                        'Une session a été crée avec succès.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MyApp(),
                                            ),
                                          );
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Ajouter'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Annuler'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icons.add_circle,
                label: "Créer une nouvelle session",
                colors: [Color.fromRGBO(68, 140, 216, 1), Color(0xFF1FE9F7)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColoredButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required List<Color> colors,
  }) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
