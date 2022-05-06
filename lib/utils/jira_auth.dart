// import 'package:http/http.dart' as http;
//
// class AuthService {
//   final baseUrl = 'https://jirasoftwareildan.atlassian.net';
//
//   Future<dynamic> login(String email, String password) async {
//     try {
//       var res = await http.post(Uri.parse(
//           'https://id.atlassian.com/login?continue=https%3A%2F%2Fjirasoftwareildan.atlassian.net%2Flogin%3FredirectCount%3D1%26application%3Djira&application=jira'),
//           body: {
//             'email': email,
//             'password': password,
//           }
//       );
//       return res?.body;
//     }
//     finally {
//       //can add something here
//     }
//   }
//
//   static setToken(String token, String refreshToken) async {
//     AuthData data = AuthDAta(token, refreshToken);
//     return SESSION.set('tokens')
//   }
// }

// import 'dart:io';
// import 'package:atlassian_apis/jira_platform.dart';
//
// class JiraAuth {
//
//   static void jiraAuthMethod() async{
//     var user = Platform.environment['dawani2016@mail.ru']!;
//     var apiToken = Platform.environment['Xm6EN8qHwuRFXvLXclBUA0BB']!;
//
//     var client = ApiClient.basicAuthentication(Uri.https('jirasoftwareildan.atlassian.net', '/rest/auth/1/session/'),
//         user: user,
//         apiToken: apiToken);
//
//     var jira = JiraPlatformApi(client);
//
//     await jira.projects.searchProjects();
//     print('----------' + jira.toString());
//     client.close();
//   }
//
// }

import 'package:http/http.dart' as http;

void main() async {

  var headers = {
    'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
    'Content-Type': 'application/json',
  };

  var url = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/auth/1/session/');
  var res = await http.get(url, headers: headers);
  if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
  print(res.body);
}

// void main() async {
//   String usePas = "dawani2016@mail.ru:Xm6EN8qHwuRFXvLXclBUA0BB";
//   Codec<String, String> stringToBase64 = utf8.fuse(base64);
//   String encoded = stringToBase64.encode(usePas);
//   var headers = {
//     'Authorization': '$encoded',
//     'Content-Type': 'application/json',
//   };
//   print(encoded.toString() + 'lllllllllllllllllll');
//
//   var url = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/auth/1/session/');
//   var res = await http.get(url, headers: headers);
//   if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
//   print(res.body);
// }