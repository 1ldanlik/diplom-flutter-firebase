import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import '../utils/fire_auth.dart';
import '../utils/validator.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? mail;
  final User? user;

  EditProfilePage({
    required this.name,
    required this.mail,
    required this.user,
  });


  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;


  @override
  void initState() {
    super.initState();
    _nameTextController.text = widget.name!;
    _emailTextController.text = widget.mail!;
  }

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
          title: Text('Register'),
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
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(height: 32.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isProcessing = true;
                                });

                                if (_registerFormKey.currentState!
                                    .validate()) {
                                  if(_nameTextController.text != null) {
                                    widget.user!.updateDisplayName(_nameTextController.text);
                                  }
                                  if(_emailTextController.text != null) {
                                    widget.user!.updateEmail(_emailTextController.text);
                                  }



                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (widget.user != null) {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePage(user: widget.user),
                                      ),
                                      ModalRoute.withName('/'),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Сохранить',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
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
}