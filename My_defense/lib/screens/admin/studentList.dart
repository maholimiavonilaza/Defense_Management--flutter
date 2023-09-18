import 'package:flutter/material.dart';
import 'package:gestion_de_soutenance/models/customTextField.dart';
import 'package:gestion_de_soutenance/models/sessionSoutenance.dart';
import 'package:gestion_de_soutenance/screens/admin/student_detail_screen.dart';
import '../../models/user_model.dart';
import '../../services/student_service.dart';

class StudentList extends StatefulWidget {
  final SessionSoutenanceModel session;

  StudentList({required this.session});

  @override
  _CrudStudentListState createState() => _CrudStudentListState();
}

class _CrudStudentListState extends State<StudentList> {
  String generateUniqueId() {
    DateTime now = DateTime.now();
    String id = '${now.microsecondsSinceEpoch}';
    return id;
  }

  final StudentService studentService = StudentService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController parcoursController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  CustomTextField passText = CustomTextField(
      title: 'Mot de passe', placeholder: '*****', ispass: true);
  CustomTextField confirmPassText = CustomTextField(
      title: 'Confirmer mot de passe', placeholder: '*****', ispass: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listes des etudiants'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ajouter un etudiant'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        TextField(
                          controller: parcoursController,
                          decoration: InputDecoration(labelText: 'Parcours'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Age'),
                        ),
                        SizedBox(height: 16),
                        passText.textFormField(),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          String nom = nameController.text.trim();
                          String parcours = parcoursController.text.trim();
                          int age = int.tryParse(ageController.text) ?? 0;
                          String email = emailController.text.trim();
                          String password = passText.value;

                          // Utilisez userData.docs.isNotEmpty au lieu de sessionSnapshot.exists
                          UserModel student = UserModel(
                            id: generateUniqueId(), // Remplacez par l'ID de l'étudiant (vous pouvez générer un ID unique ici ou laisser vide si Firebase se chargera de le générer)
                            name: nom,
                            email: email,
                            age: age,
                            password: password,
                            role: 'student',
                            parcours: parcours,
                            code: '${widget.session.code}',
                          );

                          studentService.addStudent(student);

                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Étudiant enregistré'),
                                content: Text(
                                    'L\'étudiant a été enregistré avec succès.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent.withOpacity(.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Enregistrer'),
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
            child: Text('Ajouter un étudiant'),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              //Affichage etudiants
              stream: studentService.getStudents('${widget.session.code}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserModel> students = snapshot.data!;
                  if (students.isEmpty) {
                    return Center(
                      child: Text("Il n'y a pas encore d'étudiants inscrits."),
                    );
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          // leading: Image.asset("assets/images/logo.png"),
                          title: Text(students[index].name),
                          subtitle: Text(students[index].email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  // View student details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailScreen(
                                        student: students[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(context, students[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Afficher une boîte de dialogue de confirmation
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Voulez-vous vraiment supprimer cet élément ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              studentService.deleteStudent(
                                                  students[index].id);
                                              Navigator.pop(
                                                  context); // Fermer la boîte de dialogue de confirmation
                                              // Afficher une boîte de dialogue de succès
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Suppression réussie'),
                                                    content: Text(
                                                        'L\'élément a été supprimé avec succès.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Fermer la boîte de dialogue de succès
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Text('Confirmer'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showEditDialog(BuildContext context, UserModel student) {
  TextEditingController idController = TextEditingController(text: student.id);
  TextEditingController nameController =
      TextEditingController(text: student.name);
  TextEditingController emailController =
      TextEditingController(text: student.email);
  TextEditingController ageController =
      TextEditingController(text: student.age.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name:'),
            TextField(
              controller: nameController,
            ),
            SizedBox(height: 16),
            Text('Email:'),
            TextField(
              controller: emailController,
            ),
            SizedBox(height: 16),
            Text('Age:'),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              String id = idController.text.trim();
              String newName = nameController.text.trim();
              String newEmail = emailController.text.trim();
              int newAge = int.tryParse(ageController.text) ?? 0;

              // ignore: prefer_typing_uninitialized_variables

              UserModel student = UserModel(
                id: id, // Remplacez par l'ID de l'étudiant (vous pouvez générer un ID unique ici ou laisser vide si Firebase se chargera de le générer)
                name: newName,
                email: newEmail,
                age: newAge,
                password: '',
                role: '',
                parcours: '',
                code: '',
              );
              StudentService studentService = StudentService();

              studentService.updateStudent(student);

              Navigator.pop(context);
            },
            child: Text('Enregistrer'),
          ),
        ],
      );
    },
  );
}
