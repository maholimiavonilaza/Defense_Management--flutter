import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_soutenance/components/loader/loader.dart';
import 'package:gestion_de_soutenance/models/session_model.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';
import 'package:gestion_de_soutenance/services/session_service.dart';
import 'package:intl/intl.dart';

class EventScreenTeacher extends StatefulWidget {
  final Future<UserModel?> userFuture;

  EventScreenTeacher({required this.userFuture});

  @override
  _EventScreenTeacherState createState() => _EventScreenTeacherState();
}

class _EventScreenTeacherState extends State<EventScreenTeacher> {
  late CollectionReference sessionsCollection;
  late String userCode;
  late String userRole;
  late double notes;
  late String comments1;
  late String comments2;
  late String comments3;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _comments1Controller = TextEditingController();
  final TextEditingController _comments2Controller = TextEditingController();
  final TextEditingController _comments3Controller = TextEditingController();
  final SessionService _sessionService = SessionService();
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
        userRole = user.role;
        setState(() {}); // Triggers a rebuild after obtaining userCode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getRandomColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Planning de votre Soutenance'),
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
              child: Text('Il n\' y a pas encore de session disponible'),
            );
          }

          return ListView.builder(
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
                notes: notes = double.tryParse(_noteController.text) ?? 0.0,
                comments1: sessionData['comments1'],
                comments2: sessionData['comments2'],
                comments3: sessionData['comments3'],
                code: sessionData['code'],
              );

              if (userRole == "president") {
                if (session.comments1?.isEmpty ?? true && session.emailStudent.isNotEmpty) {
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
                                  'Date: ' +
                                      DateFormat('dd-MM-yyyy')
                                          .format(session.date),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heure: ' +
                                        DateTime.parse(session.time)
                                            .toLocal()
                                            .toLocal()
                                            .toString()
                                            .split(' ')[1]
                                            .substring(0, 5),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Durée: ' + session.duration.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Notation'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(session.date),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Date',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateTime.parse(
                                                            session.time)
                                                        .toLocal()
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[1]
                                                        .substring(0, 5),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Heure',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                TextField(
                                                  controller: _noteController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Note',
                                                    labelText:
                                                        'Note de la soutenance',
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      _comments1Controller,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Votre commentaire',
                                                    labelText:
                                                        'Commentaire du Président',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  notes = double.tryParse(
                                                          _noteController.text
                                                              .trim()) ??
                                                      0.0;
                                                  comments1 =
                                                      _comments1Controller.text
                                                          .trim();

                                                  await _sessionService
                                                      .updateNotesPresident(
                                                          sessionData.id,
                                                          notes,
                                                          comments1);

                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Notation réussie'),
                                                        content: Text(
                                                            'La soutenance a bien été notée.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('OK'),
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
                                    child: Text('Noter'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: Text('Aucune nouvelle soutenance à noter'),
                  ),
                ); // Retourne un widget vide par défaut si les conditions ne sont pas remplies
              } else if (userRole == "rapporteur") {
                if (session.comments2?.isEmpty ?? true  && session.emailStudent.isNotEmpty) {
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
                                  'Date: ' +
                                      DateFormat('dd-MM-yyyy')
                                          .format(session.date),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heure: ' +
                                        DateTime.parse(session.time)
                                            .toLocal()
                                            .toLocal()
                                            .toString()
                                            .split(' ')[1]
                                            .substring(0, 5),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Durée: ' + session.duration.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Notation'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(session.date),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Date',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateTime.parse(
                                                            session.time)
                                                        .toLocal()
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[1]
                                                        .substring(0, 5),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Heure',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                TextField(
                                                  controller: _noteController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Note',
                                                    labelText:
                                                        'Note de la soutenance',
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      _comments2Controller,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Votre commentaire',
                                                    labelText:
                                                        'Commentaire du rapporteur',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  notes = double.tryParse(
                                                          _noteController.text
                                                              .trim()) ??
                                                      0.0;
                                                  comments2 =
                                                      _comments2Controller.text
                                                          .trim();

                                                  await _sessionService
                                                      .updateNotesRapporteur(
                                                          sessionData.id,
                                                          notes,
                                                          comments2);

                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Notation réussie'),
                                                        content: Text(
                                                            'La soutenance a bien été notée.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('OK'),
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
                                    child: Text('Noter'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: Text('Aucune nouvelle soutenance à noter'),
                  ),
                ); // Retourne un widget vide par défaut si les conditions ne sont pas remplies
              } else if (userRole == "examinateur") {
                if (session.comments3?.isEmpty ?? true && session.emailStudent.isNotEmpty) {
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
                                  'Date: ' +
                                      DateFormat('dd-MM-yyyy')
                                          .format(session.date),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heure: ' +
                                        DateTime.parse(session.time)
                                            .toLocal()
                                            .toLocal()
                                            .toString()
                                            .split(' ')[1]
                                            .substring(0, 5),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Durée: ' + session.duration.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Notation'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(session.date),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Date',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                    text: DateTime.parse(
                                                            session.time)
                                                        .toLocal()
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[1]
                                                        .substring(0, 5),
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: 'Heure',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                TextField(
                                                  controller: _noteController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Note',
                                                    labelText:
                                                        'Note de la soutenance',
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextField(
                                                  controller:
                                                      _comments3Controller,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Votre commentaire',
                                                    labelText:
                                                        'Commentaire de l\'examinateur',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  notes = double.tryParse(
                                                          _noteController.text
                                                              .trim()) ??
                                                      0.0;
                                                  comments3 =
                                                      _comments3Controller.text
                                                          .trim();

                                                  await _sessionService
                                                      .updateNotesExaminateur(
                                                          sessionData.id,
                                                          notes,
                                                          comments3);

                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Notation réussie'),
                                                        content: Text(
                                                            'La soutenance a bien été notée.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('OK'),
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
                                    child: Text('Noter'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: Text('Aucune nouvelle soutenance à noter'),
                  ),
                ); // Retourne un widget vide par défaut si les conditions ne sont pas remplies
              }
            },
          );
        },
      ),
    );
  }
}
