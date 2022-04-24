import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../fire_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'news_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
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

  // List<File> _image = [];
  late  File _image;


  @override
  void initState() {
    _currentUser = widget.user;
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
            Container(
              height: 100,
              width: 100,
              child: Image.network(
                  _currentUser!.photoURL.toString(),
                  fit: BoxFit.cover),
            ),
            Text(
              'NAME: ${_currentUser!.photoURL}',
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
                      builder: (context) => MyHomePage(title: 'LOL'),
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
}