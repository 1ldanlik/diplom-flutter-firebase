import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_diplom_first/dialogs/policy_dialog.dart';
import 'package:test_diplom_first/pages/choose_page.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import 'profile_page.dart';
import '../utils/fire_auth.dart';
import '../utils/validator.dart';

class RegisterPage extends StatefulWidget {
  static bool exeptBool = false;


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool isChecked = false;

  static bool _exBool = RegisterPage.exeptBool;
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  User? user;

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.customPurple,
          leading: BackButton(color: CustomColors.customWhite,),
          title: Text('Регистрация', style: TextStyle(color: CustomColors.customWhite),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        // height: 50,
                        child: TextFormField(
                          cursorColor: CustomColors.customBlack,
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
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
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 52.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            hintText: "ФИО",
                            errorBorder: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        // height: 50,
                        child: TextFormField(
                          cursorColor: CustomColors.customBlack,
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
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
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            hintText: "Email",
                            errorBorder: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        // height: 50,
                        child: TextFormField(
                          cursorColor: CustomColors.customBlack,
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 1.0),
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
                            hintText: "Пароль",
                            errorBorder: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                              ),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all(CustomColors.customPurple),
                            value: isChecked,
                            onChanged: (bool? value) {
                              // showDialog(context: context, builder: (context) {
                              //   return PolicyDialog(
                              //     mdFileName: 'privacy_policy.md',);
                              // },);
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          TextButton(onPressed: () {
                            showDialog(context: context, builder: (context) {
                              return PolicyDialog(
                                mdFileName: 'privacy_policy.md',);
                            },);
                          }, child: Text("Пользовательское соглашение", style: TextStyle(fontSize: 16, color: CustomColors.customBlack),))

                        ],
                      ),
                      SizedBox(height: 32.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Container(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isProcessing = true;
                            });

                            if (_registerFormKey.currentState!
                                .validate()) {
                              if(isChecked == true) {
                                user = await FireAuth
                                    .registerUsingEmailPassword(
                                  name: _nameTextController.text,
                                  email: _emailTextController.text,
                                  password:
                                  _passwordTextController.text,
                                );
                              }
                              else {
                                TermsOfUseDialog();
                              }

                              // exceptionMethod(_exBool);

                              setState(() {
                                _isProcessing = false;
                              });

                              if (user != null) {
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChoosePage(user: user,),
                                  ),
                                  ModalRoute.withName('/'),
                                );
                              }
                              else {
                                ExceptionMethod(_exBool);
                              }

                            }

                            await Future.delayed(Duration(seconds: 3));

                            setState(() {
                              _isProcessing = false;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )
                              )
                          ),
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExceptionMethod(bool exBool) {
    if(exBool == true)
    {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка', style: TextStyle(fontSize: 18),),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Пользователь с таким Email уже существует!', style: TextStyle(fontSize: 18),)
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

  TermsOfUseDialog() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка', style: TextStyle(fontSize: 18),),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Для регистрации необходимо принять пользовательское соглашение!', style: TextStyle(fontSize: 18),)
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

}