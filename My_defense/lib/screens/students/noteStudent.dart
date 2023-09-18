import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_soutenance/components/loader/loader.dart';
import 'package:gestion_de_soutenance/models/session_model.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';
import 'package:gestion_de_soutenance/services/session_service.dart';
import 'package:intl/intl.dart';

class NoteStudent extends StatefulWidget {
  final Future<UserModel?> userFuture;

  NoteStudent({required this.userFuture});

  @override
  _NoteStudentState createState() => _NoteStudentState();
}

class _NoteStudentState extends State<NoteStudent> {
  late CollectionReference sessionsCollection;
  late String userCode;
  late String userEmail;
  final user = FirebaseAuth.instance.currentUser;


  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    final randomIndex = Random().nextInt(colors.length);
    return colors[randomIndex];
  }

  @override
  void initState() {
    super.initState();
    sessionsCollection = FirebaseFirestore.instance.collection('Sessions');

    widget.userFuture.then((user) {
      if (user != null) {
        userCode = user.code;
        userEmail = user.email;
        setState(() {}); // Triggers a rebuild after obtaining userCode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getRandomColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultat de votre soutenance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        sessionsCollection.where("code", isEqualTo: userCode).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Il n\' y a pas encore une session disponible'),
            );
          }

          final List<SessionModel> sessions =
          snapshot.data!.docs.map((sessionData) {
            return SessionModel(
              id: sessionData.id,
              title: sessionData['title'],
              date: (sessionData['date'] as Timestamp).toDate(),
              time: sessionData['time'],
              duration: sessionData['duration'],
              location: sessionData['location'],
              emailStudent: sessionData['emailStudent'],
              notes: sessionData['notes'],
              comments1: sessionData['comments1'],
              comments2: sessionData['comments2'],
              comments3: sessionData['comments3'],
              code: sessionData['code'],
            );
          }).toList();

          final bool hasMatchingSession =
          sessions.any((session) => userEmail == session.emailStudent);

          return hasMatchingSession
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final sessionData = snapshot.data!.docs[index];
              final session = SessionModel(
                id: sessionData.id,
                title: sessionData['title'],
                date: (sessionData['date'] as Timestamp).toDate(),
                time: sessionData['time'],
                duration: sessionData['duration'],
                location: sessionData['location'],
                emailStudent: sessionData['emailStudent'],
                notes: sessionData['notes'],
                comments1: sessionData['comments1'],
                comments2: sessionData['comments2'],
                comments3: sessionData['comments3'],
                code: sessionData['code'],
              );

              if (session.notes != null && session.notes != 0.0 &&
                  session.comments1.isNotEmpty &&
                  session.comments2.isNotEmpty &&
                  session.comments3.isNotEmpty) {
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  session.notes.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Commentaire du président du Jury: ' +
                              session.comments1,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Commentaire de votre rapporteur: ' +
                                        session.comments2,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Commentaire de votre examinateur: ' +
                                        session.comments3,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              }else{
                return Container(
                  child: Text("On attend à la reponse du jury"),
                );
              };
            },
          )
              : Text("Veuillez-vous inscire à une soutenance pour avoir une note");
        },
      ),
    );
  }
}
