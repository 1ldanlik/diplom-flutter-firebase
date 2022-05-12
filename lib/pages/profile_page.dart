import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'package:test_diplom_first/pages/redact_profile_page.dart';
import 'package:test_diplom_first/utils/jira_auth.dart';
import '../utils/fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'news_page.dart';
import '../utils/database.dart';
import '../utils/jira_auth.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({required this.user});
  static DateTime? dateBirth;
  static String? subdivision;

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
  // Map<String, dynamic> _dateOfBirth = Database.readDateOfBirthday(_currentUser!.uid).data;
  // String? _dateOfBirth;
  // List<File> _image = [];
  late  File _image;
  late Future<DateTime> time;
  late DateTime? dateTime = null;
  late String? subDiv = null;


  @override
  void initState() {
    refreshUser();
    _currentUser = widget.user;
    main();
    Database.userUid = _currentUser!.uid.toString();
    Database.readDateOfBirthday(_currentUser!.uid).then((value) =>
        methodDateBirth()
    );
    Database.readSubdivision(_currentUser!.uid).then((value) =>
        methodSub()
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center(
            //   child:
            // ),
            Text(_currentUser!.uid),
            // Container(
            //   height: 100,
            //   width: 100,
            Row(
              children: [
                SizedBox(width: 65,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ClipRRect(
                    child: _currentUser!.photoURL != null ? Image.network(
                      _currentUser!.photoURL.toString(),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ) : null
                  ),
                ),
                SizedBox(width: 30,),
                        ElevatedButton(
                            onPressed: () => chooseImage(),
                            child: Text('Выбрать картинку',),),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffCCCCCC),
                borderRadius: BorderRadius.circular(20.0),
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
                      child: dateTime == null ? TextButton(onPressed: () {
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
                          'Add date time picker',
                          style: TextStyle(color: Colors.blue),
                        ),
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
                  Text(subDiv != null ? 'Подразделение: ${subDiv.toString()}' : 'Подразделение:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                  SizedBox(height: 16.0),
                  Text(
                    'EMAIL: ${_currentUser!.email}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1,
                  ),
                  SizedBox(height: 16.0),
                  _currentUser!.emailVerified
                      ? Text(
                    'Email verified',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                      : Text(
                    'Email not verified',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _currentUser!.sendEmailVerification();
                    },
                    child: Text('Verify email'),
                  ),
                  IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        refreshUser();
                      }
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(name: _currentUser!.displayName, mail: _currentUser!.email, subdivision: subDiv, user: _currentUser!)
                          ));
                    },
                    child: Text('Редактировать профиль'),),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('Sign out')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'LOL'),
                      // DashboardScreen()
                    ),
                  );
                },
                child: Text('Home page')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          JiraIssuesList(),
                      // DashboardScreen()
                    ),
                  );
                },
                child: Text('Задачи Jira')
            ),
            // Add widgets for verifying email
            // and, signing out the user
          ],
        ),
      ),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      // _image.add(File(pickedFile!.path));
      _image = File(pickedFile!.path);
    });
    await uploadFile();
    print(_image.path);
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
    ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${Path.basename(_image.path)}');
    await ref!.putFile(_image).whenComplete(() async {
      await ref!.getDownloadURL().then((value) {
        _currentUser!.updatePhotoURL(value);
      });
    });
    refreshUser();
  }


  Future refreshUser() async {
    User? user = await FireAuth?.refreshUser(_currentUser!);
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  // timeMethod() async{
  //     var time2 = await Database.readDateOfBirthday(_currentUser!.uid);
  //     setState(() {
  //       dateTime = time2;
  //     });
  // }
  methodDateBirth() {
    setState(() {
      dateTime = ProfilePage.dateBirth;
    });
  }

  methodSub() {
    setState(() {
      subDiv = ProfilePage.subdivision;
    });
  }

  void main() async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "expand": "names,schema", "startAt": 0, "maxResults": 50, "total": 1, "issues": [ { "expand": "", "id": "10001", "self": "https://jirasoftwareildan.atlassian.net/rest/api/2/issue/10001", "key": "GEEK-4"} ] }';

    var url = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
    var lol = await http.post(url, headers: headers, body: body, encoding: Encoding.getByName("utf-8"));
    if (lol.statusCode != 201) throw Exception('http.get error: statusCode= ${lol.statusCode}');
    print(lol.body.toString() + 'GET ISSUES');

  }



}