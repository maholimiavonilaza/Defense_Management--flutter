import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/sessionSoutenance.dart';
import 'package:gestion_de_soutenance/screens/admin/admin_root_screen.dart';
import 'package:gestion_de_soutenance/services/sessionSoutenanceService.dart';

class joinSessionPage extends StatelessWidget {
  final SessionSoutenanceService sessionSoutenanceService = SessionSoutenanceService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votre session'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder<List<SessionSoutenanceModel>>(
              stream: sessionSoutenanceService.getSessionsStream(), // Utilisez la méthode getSessionStream() de votre SessionService
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SessionSoutenanceModel> sessions = snapshot.data!;
                  return ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(sessions[index].type),
                          subtitle: Text(sessions[index].annee.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AdminRootScreen(session: sessions[index],),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implémentez l'action d'édition ici si nécessaire
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // Gérer les erreurs si nécessaire
                  return Text('Une erreur est survenue');
                } else {
                  // Afficher un indicateur de chargement pendant que les données sont récupérées
                  return CircularProgressIndicator();
                }
              },
            )
            ,
          ),
        ],
      ),
    );
  }
}

