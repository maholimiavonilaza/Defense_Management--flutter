import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/sessionSoutenance.dart';
import 'jurys_screen.dart';
import 'student_detail_screen.dart';
import '../../models/user_model.dart';
import '../../services/student_service.dart';
import 'studentList.dart';

class Index extends StatefulWidget {

  final SessionSoutenanceModel session;

  Index({required this.session});


  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.redAccent,
            child: Column(
                children: [
                  // Afficher les informations de session
                  Column(
                    children: [
                      Text('Annee: ${widget.session.annee}'),
                      Text('Type: ${widget.session.type}'),
                      Text('Code d\' entree: ${widget.session.code}')
                    ],
                  ),
                  // Espacement entre les informations de session et les boutons
                  SizedBox(height: 20),
                  // Boutons d'accès aux listes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.orange,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StudentList(session: widget.session),
                            ),
                          );
                        },
                        child: Text('Voir la liste des étudiants'),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.orange,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Juryscreen(session: widget.session),
                            ),
                          );
                        },
                        child: const Text('Voir la liste des Jury'),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        )
    );
  }
}