import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';

class juryDetailScreen extends StatelessWidget {
  final UserModel jury;

  juryDetailScreen({required this.jury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 25,
          right: 25,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome',
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      jury.name,
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      jury.role,
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                /**CircleAvatar(
                    child: Image.asset(
                    'assets/images/user-3331256_640.png',
                    fit: BoxFit.cover,
                    ),
                    ),**/
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${jury.name}'),
                  SizedBox(height: 8),
                  Text('Email: ${jury.email}'),
                  SizedBox(height: 8),
                  Text('Age: ${jury.age}'),
                  // Ajoutez d'autres détails que vous souhaitez afficher
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
