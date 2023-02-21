import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text('Login'),
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
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            print(userCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('User Not Found');
                            } else if(e.code == 'wrong-password'){
                              print('Incorrect Password! Try again');
                            }
                          }
                        },
                        child: const Text('Login '),
                      ),
                    ],
                  );
                default:
                  return const Text('Loading...');
              }
            }));
  }
}
