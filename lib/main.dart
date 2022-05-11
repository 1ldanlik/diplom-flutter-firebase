import 'package:flutter/material.dart';
import 'pages/login_page.dart';

import 'dart:io';
// import 'package:atlassian_apis/jira_platform.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoginPage(),
    );
  }


  // static jiraAuthMethod() async{
  //   var user = Platform.environment['dawani2016@mail.ru']!;
  //   var apiToken = Platform.environment['Xm6EN8qHwuRFXvLXclBUA0BB']!;
  //
  //   var client = ApiClient.basicAuthentication(Uri.https('jirasoftwareildan.atlassian.net', '/rest/auth/1/session/'),
  //       user: user,
  //       apiToken: apiToken);
  //
  //   var jira = JiraPlatformApi(client);
  //
  //   await jira.projects.searchProjects();
  //   print('----------' + jira.toString());
  //   client.close();
  // }

}