import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration:
                            const InputDecoration(hintText: 'Enter your email'),
                      ),
                      TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _password,
                          decoration: const InputDecoration(
                              hintText: 'Enter password')),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print(UserCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('Weak Password! Try again');
                            } else if (e.code == 'email-already-in-use') {
                              print('Email already in use');
                            } else if (e.code == 'invalid-email') {
                              print('Invalid email entered');
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  );
                default:
                  return const Text('Loading...');
              }
            }));
  }
}