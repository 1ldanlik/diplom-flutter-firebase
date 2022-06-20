import 'package:http/http.dart' as http;
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'dart:convert';

import 'package:test_diplom_first/utils/issues_get.dart';


class JiraAuth {
  static String? encoded;
  static int? statusCode;
  static var headers;

  static Future basicAuthJira(String login, String password) async {
    String credentials = "${login}:${password}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/createmeta');
    var response = await http.get(url, headers: headers);
    statusCode = response.statusCode;
    if(response.statusCode != 200 || response.statusCode != 201)
      throw Exception('http.get Auth error: statusCode= ${response.statusCode}');
  }
}
