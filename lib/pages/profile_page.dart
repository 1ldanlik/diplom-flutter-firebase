import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_diplom_first/widgets/birthday_list.dart';
import '../utils/fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'news_page.dart';
import '../utils/database.dart';
import '../widgets/birthday_list.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({required this.user});
  static DateTime? dateBirth;

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
  late DateTime? dateTime;


  @override
  void initState() {
    _currentUser = widget.user;
    BirthdayList.userId = _currentUser!.uid.toString();
      Database.readDateOfBirthday(_currentUser!.uid).then((value) =>
          method()
      );
    setState(()  {
      dateTime = ProfilePage.dateBirth;
    });

    // print('[[[[[[[[[[[[[[[[[[[[[' + Database.readDateOfBirthday(_currentUser!.uid).toString());
    // print('[[[[[[[[[[[[[[[[[[[[[' + dateTime.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => chooseImage()),
            ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload'),
            ),
            Text(_currentUser!.uid),
            // Container(
            //   height: 100,
            //   width: 100,
               ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ClipRRect(
                child: Image.network(
                    _currentUser!.photoURL.toString(),
                    fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
                ),

                ),
            // ),
            Text(
              dateTime.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
            Text(
              'NAME: ${_currentUser!.displayName}',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
            // Text(Database.readDateOfBirthday().where((event) => event == _currentUser!.uid)).toString()),
            // Container(
            //   height: MediaQuery.of(context).size.height / 1.5,
            //   child: SafeArea(
            //     child: Padding(
            //       padding: const EdgeInsets.only(
            //         left:16.0,
            //         right:16.0,
            //         bottom:20.0,
            //       ),
            //       child: BirthdayList(),
            //     ),
            //   ),
            // ),
            // Text(_dateOfBirth.toString(),
            //   style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.w500
            //   ),),
            // Container(
            //   child: _dateOfBirth != null ? TextButton(onPressed: () {
            //     DatePicker.showDatePicker(context,
            //         showTitleActions: true,
            //         minTime: DateTime(1920, 1, 1),
            //         maxTime: DateTime(2004, 12, 31), onChanged: (date) {
            //           print('change $date');
            //         }, onConfirm: (date) {
            //           // Database.userUid = _currentUser!.uid;
            //           Database.addUserDateOfBirth(dateOfBirth: Timestamp.fromDate(date));
            //           setState(() {
            //             // _dateOfBirth = date.toString();
            //           });
            //           print('confirm $date');
            //         }, currentTime: DateTime.now(), locale: LocaleType.en);
            //   },
            //     child: Text(
            //       'show date time picker',
            //       style: TextStyle(color: Colors.blue),
            //     ),
            //   ) : Row(
            //     children: [
            //       Text(_dateOfBirth.toString(),
            //       style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w500
            //       ),),
            //       TextButton(onPressed: () {
            //         DatePicker.showDatePicker(context,
            //             showTitleActions: true,
            //             minTime: DateTime(1920, 1, 1),
            //             maxTime: DateTime(2004, 12, 31), onChanged: (date) {
            //               print('change $date');
            //             }, onConfirm: (date) {
            //               Database.updateUserDateOfBirth(dateOfBirth: date.toString(), docId: _currentUser!.uid);
            //               setState(() {
            //                 // _dateOfBirth = date.toString();
            //               });
            //               print('confirm $date');
            //             }, currentTime: DateTime.now(), locale: LocaleType.en);
            //       },
            //         child: Text(
            //           'show date time picker',
            //           style: TextStyle(color: Colors.blue),
            //         ),
            //       )
            //     ],
            //   )
            // ),

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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'LOL'),
                      // DashboardScreen()
                    ),
                  );
                },
                child: Text('Home page')
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
    if (pickedFile!.path == null) retrieveLostData();
    print(_image.path);
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
  method() {
    setState(() {
      dateTime = ProfilePage.dateBirth;
      print(ProfilePage.dateBirth.toString() + 'oooooooooooo');
    });
  }


}