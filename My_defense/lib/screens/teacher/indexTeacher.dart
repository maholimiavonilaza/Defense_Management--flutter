import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexTeacher extends StatelessWidget {
  final Future<UserModel?> userFuture;

  IndexTeacher({required this.userFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (userSnapshot.hasError || !userSnapshot.hasData || userSnapshot.data == null) {
          return Text('Erreur lors de la récupération de l\'utilisateur');
        } else {
          UserModel currentUser = userSnapshot.data!;

          // Récupérer le champ de code de l'utilisateur
          String userCode = currentUser.code;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Session').where("code", isEqualTo: userCode).snapshots(),
            builder: (context, sessionSnapshot) {
              if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (!sessionSnapshot.hasData) {
                return Text('Erreur lors de la récupération de la session');
              } else {
                // Supposons que vous vous attendez à un seul document correspondant
                var sessionDocument = sessionSnapshot.data!.docs.first;
                var sessionData = sessionDocument.data() as Map<String, dynamic>;

                // Utilisez les valeurs de la session ici, par exemple :
                String sessionValue = sessionData['type'];
                int sessionDate = sessionData['annee'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nom : ${currentUser.name}'),
                    Text('E-mail : ${currentUser.email}'),
                    Text('Parcours : ${currentUser.parcours}'),
                    Text('Role : ${currentUser.role}'),
                    Text('Valeur de la session : $sessionValue'),
                    Text('Annee : $sessionDate'),
                    // ... Ajoutez plus d'éléments d'interface utilisateur ici si nécessaire
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
