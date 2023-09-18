import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/loader/loader.dart';
import '../../models/customTextField.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/navigation.dart';

class LoginScreen extends StatefulWidget {
  final Function visible;
  LoginScreen(this.visible);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoaderVisible = false;

  final AuthService _authService = AuthService();
  CustomTextField emailText =
      CustomTextField(title: 'Email', placeholder: 'Votre adresse email');
  CustomTextField passText = CustomTextField(
      title: 'Mot de passe', placeholder: '*****', ispass: true);

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    emailText.error = "Veuillez entrer votre adresse email";
    passText.error = "Veuillez entrer votre mot de passe";

    return Scaffold(
      body: Container(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Page d\' Authentification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          emailText.textFormField(),
                          const SizedBox(
                            height: 10,
                          ),
                          passText.textFormField(),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                String email = emailText
                                    .value; // Déplacer la définition de la variable email ici
                                String password = passText.value;

                                setState(() {
                                  _isLoaderVisible = true;
                                });

                                if (_key.currentState?.validate() ?? false) {
                                  User? user = await _authService
                                      .signInWithEmail(email, password);

                                  if (user != null) {
                                    await handleLoggedInUser(true, context);
                                  }
                                }
                                setState(() {
                                  _isLoaderVisible = false;
                                });
                              } catch (e) {
                                setState(() {
                                  _isLoaderVisible = false;
                                });

                                String errorMessage =
                                    'Une erreur s\'est produite lors de la connexion. Veuillez réessayer.';

                                if (e is FirebaseAuthException) {
                                  if (e.code == 'user-not-found') {
                                    errorMessage =
                                        'Aucun utilisateur trouvé avec cet email.';
                                  } else if (e.code == 'wrong-password') {
                                    errorMessage =
                                        'Mot de passe incorrect pour cet utilisateur.';
                                  } else if (e.code == 'invalid-email') {
                                    errorMessage =
                                        'Format d\'adresse email invalide.';
                                  }
                                }

                                errorMessage ??=
                                    'Une erreur s\'est produite lors de la connexion. Veuillez réessayer.';

                                setState(() {
                                  emailText.error = errorMessage;
                                  passText.error = errorMessage;
                                });

                                print('LoginScreen Error: $e');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent.withOpacity(.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Se connecter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Avez-vous un compte?'),
                              TextButton(
                                onPressed: widget.visible as void Function()?,
                                child: const Text(
                                  'S\' inscrire',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(child: Loader(), visible: _isLoaderVisible),
        ]),
      ),
    );
  }
}
