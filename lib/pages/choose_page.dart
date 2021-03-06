import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'package:test_diplom_first/pages/jira_login_page.dart';
import 'package:test_diplom_first/pages/profile_page.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import 'package:test_diplom_first/utils/database.dart';
import 'package:test_diplom_first/utils/fire_auth.dart';

import 'login_page.dart';
import 'news_page.dart';

class ChoosePage extends StatefulWidget {
  final User? user;
  const ChoosePage({required this.user});


  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 240,
                height: 80,
                child: ElevatedButton(onPressed: () { Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                  ProfilePage(user: widget.user,),
                ));},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  ))),
                  child: Text("Профиль", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: CustomColors.customWhite),),
                )),
              SizedBox(height: 20,),
              SizedBox(
                width: 240,
                height: 80,
                child: ElevatedButton.icon(onPressed: () { Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      MyHomePage(title: 'lkl'),
                ));},style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                        )
                    )
                ), icon:
          Icon(Icons.newspaper_rounded, size: 40, color: Colors.white,),
                    label: Text('Новости',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: CustomColors.customWhite),
              ))),
              SizedBox(height: 20,),
              SizedBox(
                width: 240,
                height: 80,
                child: ElevatedButton.icon(onPressed: () async {
                  bool isAuth = await Database.readJiraAuthData(FireAuth.user!.uid);
                  if(isAuth) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            JiraIssuesList()
                        ));
                  }
                  else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            JiraLoginPage(),
                        ));
                  }
                  },style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomColors.customPurple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                        )
                    )
                ), icon:
          Image.asset("assets/jira_icon.png", width: 30, color: Colors.white,), label: Text('Jira', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: CustomColors.customWhite),)),
              ),
              SizedBox(height: 100,),
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
                  child: Text('Выйти', style: TextStyle(color:  CustomColors.customWhite, fontSize: 18),),
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
      ),
    );
  }
}
