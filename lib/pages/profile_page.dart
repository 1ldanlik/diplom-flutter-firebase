import 'dart:convert';
import 'dart:io';
import 'package:adaptive_spinner/adaptive_spinner.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:test_diplom_first/pages/choose_page.dart';
import 'package:test_diplom_first/pages/redact_profile_page.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import '../utils/fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import '../utils/database.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  bool uploading = false;
  double value = 0;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User? _currentUser;
  firebase_storage.Reference? ref;
  final picker = ImagePicker();

  late  File _image;
  late Future<DateTime> time;
  late DateTime? dateTime = null;
  late String? subDiv = null;
  double valueIndicator = 0;
  bool isProcess = false;
  bool isAuthInJira = false;

  @override
  void initState() {
    super.initState();
    refreshUser();
    _currentUser = widget.user;
    Database.userUid = _currentUser!.uid.toString();
    Database.readDateOfBirthday(_currentUser!.uid).then((value) {
      setState(() {
        dateTime = value;
      });
    }
    );
    Database.readSubdivision(_currentUser!.uid).then((value) {
      setState(() {
        subDiv = value;
      });
    }
    );
    checkOnAuthInJira();
  }

  checkOnAuthInJira() {
    Database.readJiraAuthData(FireAuth.user!.uid).then((value) {
      setState(() {
        isAuthInJira = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 80,),
            Text('Профиль', style: TextStyle(fontSize: 24, color: CustomColors.customWhite),),
          ],
        ),
        backgroundColor: CustomColors.customPurple,
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
          ChoosePage(user: _currentUser)
          ));
        },color: CustomColors.customWhite,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 65,),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.customGrey,
                        blurRadius: 100.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: _currentUser!.photoURL != null ? ClipRRect(
                      child: Image.network(
                        _currentUser!.photoURL.toString(),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        frameBuilder: (context, child, frame, wasSynchronousLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress == null) {
                            return child;
                          }
                          else {
                            return Container(
                              height: 100,
                                width: 100,
                                child: AdaptiveSpinner(withRadius: 30,));
                          }
                        },
                      )) : ClipRRect(
                      child: Image.asset("assets/avatar_null.png",
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      )
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                        ElevatedButton(
                            onPressed: () => chooseImage(),
                            child: Text('Выбрать картинку', style: TextStyle(color: CustomColors.customWhite, fontSize: 16),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                        ),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                color: CustomColors.customWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 2),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Colors.grey
                  ),
                ],
              ),
              width: 320,
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Text(
                    'Имя: ${_currentUser!.displayName}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)
                  ),
                  Container(
                      child: dateTime == null ? Row(
                        children: [
                          SizedBox(width: 30,),
                      Text('Дата рождения: ', style: TextStyle(fontSize: 16)),
                          TextButton(onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1920, 1, 1),
                                maxTime: DateTime(2004, 12, 31), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  Database.userUid = _currentUser!.uid;
                                  Database.addUserDateOfBirth(dateOfBirth: Timestamp.fromDate(date));
                                  setState(() {
                                    dateTime = date;
                                  });
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                            child: Text(
                              'Выбрать дату',
                              style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ) : Row(
                        children: [
                          SizedBox(width: 30,),
                          Text('Дата рождения: ${DateFormat('yyyy-MM-dd').format(dateTime!)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                            ),),
                          IconButton(
                            icon: Icon(Icons.edit),onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1920, 1, 1),
                                maxTime: DateTime(2004, 12, 31), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  Database.updateUserDateOfBirth(dateOfBirth: date.toString(), docId: _currentUser!.uid);
                                  setState(() {
                                    dateTime = date;
                                  });
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          )
                        ],
                      )
                  ),

                  SizedBox(height: 16.0),
                  Text(subDiv != null ? 'Подразделение: ${subDiv.toString()}' : 'Подразделение: не выбрано', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                  SizedBox(height: 16.0),
                  Text(
                    'EMAIL: ${_currentUser!.email}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _currentUser!.emailVerified
                          ? Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Подтверждена',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                        decoration: BoxDecoration(
                          color: CustomColors.customGreen,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 3,
                                color: Colors.grey
                            ),
                          ],
                        ),
                          )
                          : Container(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                        'Не подтверждена',
                        style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: CustomColors.customWhite),
                      ),
                            ),
                        // color: CustomColors.customRed,
                        decoration: BoxDecoration(
                          color: CustomColors.customRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 3,
                                color: Colors.grey
                            ),
                          ],
                        ),
                          ),
                      ElevatedButton(
                        onPressed: () async {
                          await _currentUser!.sendEmailVerification();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                        child: Text('Подтвердить почту', style: TextStyle(color: CustomColors.customWhite, fontSize: 16)
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(name: _currentUser!.displayName, mail: _currentUser!.email, subdivision: subDiv, user: _currentUser!)
                          ));
                    },
                    child: Text('Редактировать профиль', style: TextStyle(color: CustomColors.customWhite, fontSize: 16),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.customPurple,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 3,
                            color: Colors.grey
                        ),
                      ],
                    ),
                    child: IconButton(
                        icon: Icon(Icons.refresh, color: CustomColors.customWhite,),
                        onPressed: () {
                          refreshUser();
                        }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            isAuthInJira == true ? SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    Database.deleteJiraAuthData(docId: FireAuth.user!.uid).whenComplete(() =>
                        checkOnAuthInJira());
                  },
                  child: Text('Выйти из Jira', style: TextStyle(color:  CustomColors.customWhite, fontSize: 16),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(CustomColors.customGrey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
              ),
            ) : SizedBox(height: 10,),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text('Выйти', style: TextStyle(color:  CustomColors.customWhite, fontSize: 16),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(CustomColors.customGrey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() async {
      _image = File(pickedFile!.path);
      await uploadFile().whenComplete(() => refreshUser());
    });

    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
    else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    if(_currentUser!.photoURL != null) {
      firebase_storage.FirebaseStorage.instance.refFromURL(
          _currentUser!.photoURL.toString()).delete();
    }
    ref = firebase_storage.FirebaseStorage.instance.ref().child('images/avatarImgs/${Path.basename(_image.path)}');
    await ref!.putFile(_image).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        await _currentUser!.updatePhotoURL(value);
        // refreshUser();
      });
    });
  }


  Future refreshUser() async {
    User? user = await FireAuth?.refreshUser(_currentUser!);
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
    print('eeeeeeeeeeeeeeeeeeeeee');
  }

}