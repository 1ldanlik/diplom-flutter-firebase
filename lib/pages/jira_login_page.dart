import 'package:test_diplom_first/pages/choose_page.dart';
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'package:test_diplom_first/pages/news_page.dart';

import '../res/custom_colors.dart';
import '../utils/jira_auth.dart';
import '../utils/validator.dart';
import '../utils/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/fire_auth.dart';
import '../widgets/custom_form_field.dart';
import 'profile_page.dart';
import 'register_page.dart';

class JiraLoginPage extends StatefulWidget {
  static String? textExceptionSt = '';
  static bool noUser = false;
  static bool wrongPassword = false;

  @override
  State<JiraLoginPage> createState() => _JiraLoginPageState();
}

class _JiraLoginPageState extends State<JiraLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  String? textException = '';
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  static bool _noUser = JiraLoginPage.noUser;
  static bool _wrongPassword = JiraLoginPage.wrongPassword;
  @override
  void initState() {
    super.initState();
    textException = JiraLoginPage.textExceptionSt;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customPurple,
        leading: BackButton(color: CustomColors.customWhite,),
        title: Row(
          children: [
            Image.asset("assets/jira_icon.png", width: 20, color: Colors.white,),
            SizedBox(width: 20,),
            Text('Авторизация Jira',
              style: TextStyle(fontSize: 24, color: Colors.white),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Image.asset("assets/jira_icon.png", width: 60, color: CustomColors.customGrey,),
                  Text('Jira', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 36, color: CustomColors.customGrey)),
                  SizedBox(height: 20,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          child: TextFormField(
                            cursorColor: CustomColors.customBlack,
                            style: TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              contentPadding: EdgeInsets.only(left: 20, right: 20),
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
                          height: 50,
                          child: TextFormField(
                            cursorColor: CustomColors.customBlack,
                            style: TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: 'Пароль (API Token)',
                              contentPadding: EdgeInsets.only(left: 20, right: 20),
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
                            obscureText: true,
                            validator: (value) => Validator.validateJiraPassword(password: value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 70.0,),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // User? user = await FireAuth.signInUsingEmailPassword(
                              //   email: _emailTextController.text,
                              //   password: _passwordTextController.text,
                              // );
                              JiraAuth.BasicAuthJira(_emailTextController.text,
                                  _passwordTextController.text).whenComplete(() => {
                              if (JiraAuth.statusCode == 200 ||
                              JiraAuth.statusCode == 201) {
                                  Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => JiraIssuesList()),
                              )
                            }
                            else {
                              exceptionMethod(_noUser, _wrongPassword)
                            }
                              });


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