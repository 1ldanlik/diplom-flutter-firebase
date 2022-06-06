import 'package:http/http.dart' as http;
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'dart:convert';

import 'package:test_diplom_first/utils/issues_get.dart';


class JiraService {
  static String? loginJira = "dawani2016@mail.ru";
  static String? passwordJira = "Xm6EN8qHwuRFXvLXclBUA0BB";
  static String? encoded;
  static var headers;

  void BasicAuthJira(String login, String password) async {
    String credentials = "${loginJira.toString()}:${passwordJira.toString()}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
    var response = await http.get(url, headers: headers);
    if(response.statusCode != 200 || response.statusCode != 201)
      throw Exception('http.get Auth error: statusCode= ${response.statusCode}');

  }
}


//     String body = '{ "fields": { "project": { "key": "GEEK" }, "summary": "REST ye merry gentlemen.", "description": "Creating of an issue using project keys and issue type names using the REST API", "issuetype": { "id": "10001" } } }';
//
//     var url = Uri.parse(
//         'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
//     var lol = await http.post(url, headers: headers,
//         body: body,
//         encoding: Encoding.getByName("utf-8"));
//     if (lol.statusCode != 201) throw Exception(
//         'http.get error: statusCode= ${lol.statusCode}');
//     print(lol.body.toString() + 'lllllllllll');
//   }
// }
