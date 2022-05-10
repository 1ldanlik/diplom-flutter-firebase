import 'package:test_diplom_first/pages/news_page.dart';

import '../utils/validator.dart';
import '../utils/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/fire_auth.dart';
import '../widgets/custom_form_field.dart';
import 'profile_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Text('Авторизация', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  )
                              ),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  )
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  )
                              )
                          ),
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(email: value),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 5.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                            )
                          ),
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(password: value),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 20.0,),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User? user = await FireAuth.signInUsingEmailPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );
                                if (user != null) {
                                  Database.commonId = '1234';
                                  Navigator.of(context)
                                      .pushReplacement(
                                    MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ),
                          Container(
                            width: 200,
                            child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                        ),
                          ),
                    ],
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}