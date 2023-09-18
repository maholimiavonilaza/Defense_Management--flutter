import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final UserModel student;

  StudentDetailScreen({required this.student});

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
                      student.name,
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      student.role,
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
                  Text('Name: ${student.name}'),
                  SizedBox(height: 8),
                  Text('Email: ${student.email}'),
                  SizedBox(height: 8),
                  Text('Age: ${student.age}'),
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
