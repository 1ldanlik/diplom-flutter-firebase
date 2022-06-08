import 'package:test_diplom_first/pages/choose_page.dart';
import 'package:test_diplom_first/pages/news_page.dart';

import '../res/custom_colors.dart';
import '../utils/validator.dart';
import '../utils/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/fire_auth.dart';
import '../widgets/custom_form_field.dart';
import 'profile_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  static String? textExceptionSt = '';
  static bool noUser = false;
  static bool wrongPassword = false;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  String? textException = '';
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  static bool _noUser = LoginPage.noUser;
  static bool _wrongPassword = LoginPage.wrongPassword;
  @override
  void initState() {
    super.initState();
    textException = LoginPage.textExceptionSt;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Firebase Authentication'),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 170, left: 20, right: 20),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text('Авторизация', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 36)),
                      SizedBox(height: 50,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                cursorColor: CustomColors.customBlack,
                                style: TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      )
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      )
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                ),
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(email: value),
                              ),
                            ),
                            SizedBox(height: 18.0),
                            Container(
                              // height: 50,
                              child: TextFormField(
                                obscureText: true,
                                cursorColor: CustomColors.customBlack,
                                style: TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: 'Пароль',
                                  contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      )
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                ),
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                validator: (value) => Validator.validatePassword(password: value),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20.0,),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  User? user = await FireAuth.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  );


                                  if (user != null) {
                                    Database.commonId = 'main';
                                    Navigator.of(context)
                                        .pushReplacement(
                                      MaterialPageRoute(builder: (context) => ChoosePage(user: user)),
                                    );
                                  }
                                  else
                                  {
                                    exceptionMethod(_noUser, _wrongPassword);
                                  }
                                }
                              },
                              child: Text(
                                'Войти',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      )
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: 400,
                            height: 50,
                            child:
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => RegisterPage()),
                                );
                              },
                              child: Text(
                                'Регистрация',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      )
                                  )
                              ),
                            ),

                          )
                        ],
                      )
                    ],
                  ),
                ),
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

  exceptionMethod(bool userBool, bool passBool) {
    if(userBool == true || passBool == true)
    {
      // _noUser = false;
      // _wrongPassword = false;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка', style: TextStyle(fontSize: 18),),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Пользователь не найден!', style: TextStyle(fontSize: 18),)
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ок'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else return null;
  }

}