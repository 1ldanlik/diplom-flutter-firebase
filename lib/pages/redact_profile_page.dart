import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/custom_colors.dart';
import '../utils/database.dart';
import 'profile_page.dart';
import '../utils/fire_auth.dart';
import '../utils/validator.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? mail;
  final String? subdivision;
  final User? user;

  EditProfilePage({
    required this.name,
    required this.mail,
    required this.subdivision,
    required this.user,
  });


  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _subdivisionTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusSubdivision = FocusNode();

  bool _isProcessing = false;


  @override
  void initState() {
    super.initState();
    _nameTextController.text = widget.name!;
    _emailTextController.text = widget.mail!;
    if(widget.subdivision != null)
    _subdivisionTextController.text = widget.subdivision!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusSubdivision.unfocus();
      },
      child:
      Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 80,),
              Text('Профиль', style: TextStyle(fontSize: 24, color: CustomColors.customWhite),),
            ],
          ),
          backgroundColor: CustomColors.customPurple,
          leading: BackButton(color: CustomColors.customWhite,),
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
                          hintText: "ФИО",
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
                          errorBorder: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
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
                          errorBorder: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _subdivisionTextController,
                        // focusNode: _focusSubdivision,
                        validator: (value) => Validator.validateSubdivision(
                          subDivis: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Подразделение",
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
                          errorBorder: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
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
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ))),
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
                                  if(widget.subdivision == null)
                                    {
                                      Database.addUserSubdivision(subdivision: _subdivisionTextController.text);
                                    }
                                  else
                                    {
                                      Database.updateUserSubdivision(subdivision: _subdivisionTextController.text, docId: widget.user!.uid).whenComplete(() =>
                                          print('PRINT USER UID' + widget.user!.uid));
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