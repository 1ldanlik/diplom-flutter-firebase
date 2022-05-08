import 'package:http/http.dart' as http;
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'dart:convert';

import 'package:test_diplom_first/utils/issues_get.dart';


class JiraService {
  void main() async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "fields": { "project": { "key": "GEEK" }, "summary": "REST ye merry gentlemen.", "description": "Creating of an issue using project keys and issue type names using the REST API", "issuetype": { "id": "10001" } } }';

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
    var lol = await http.post(url, headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    if (lol.statusCode != 201) throw Exception(
        'http.get error: statusCode= ${lol.statusCode}');
    print(lol.body.toString() + 'lllllllllll');

    // var url = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/auth/1/session/');
    // var res = await http.get(url, headers: headers);
    // if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    // print(res.body.toString() + '999999999999999999');
  }

  getIssues() async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "expand": "names,schema", "startAt": 0, "maxResults": 50, "total": 1, "issues": [ { "expand": "", "id": "10001", "self": "https://jirasoftwareildan.atlassian.net/rest/api/2/issue/10001", "key": "GEEK-4"} ] }';

    Uri uri = Uri.parse("https://jirasoftwareildan.atlassian.net/rest/api/2/search");
    uri.replace(query: body);

    var lol = await http.get(uri, headers: headers);
    // var jsonData = jsonDecode(lol.body);
    // List<Issue> issuesList = [];
    // for(var i in jsonData)
    // {
    //   Issue issue2 = Issue(i['expand'], i['id'], i['self'], i['key'], i['fields']);
    //   issuesList.add(issue2);
    // }
    // print('USERS LENGTH' + issuesList.length.toString());

    // var url = Uri.parse(
    //     'https://jirasoftwareildan.atlassian.net/rest/api/2/search');
    // var lol = await http.post(url, headers: headers,
    //     body: body,
    //     encoding: Encoding.getByName("utf-8"));
    print( 'GET ISSUES' + lol.body);
    print( 'GET LENGTH' + lol.statusCode.toString());
    print('REDACT ISSUES' + jsonDecode(lol.body).toString());
    if (lol.statusCode == 200 || lol.statusCode == 201) {
      var json1 = json.decode(lol.body);
      // JiraIssuesList.strIssues = lol.body.toString();
      // return jsonDecode(lol.body).toString();
    }
    else {
      throw Exception('http.get error: statusCode= ${lol.statusCode}');
    }

  }
}
