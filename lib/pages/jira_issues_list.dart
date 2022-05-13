import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_diplom_first/pages/add_issue_page.dart';
import 'package:test_diplom_first/utils/issues_get.dart';
import 'package:test_diplom_first/utils/jira_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JiraIssuesList extends StatefulWidget {
  const JiraIssuesList({Key? key}) : super(key: key);

  @override
  State<JiraIssuesList> createState() => _JiraIssuesListState();
}

class _JiraIssuesListState extends State<JiraIssuesList> {
  late String? issues;
  var isLoaded = false;
  List<Issue>? issueList;
  DateTime? dateTime;
  final zero = DateTime;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    issueList = await getIssues();
    if(issueList != null){
          setState(() {
            isLoaded = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                    AddIssuePage())
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body:
      Visibility(
        visible: isLoaded,
        child:
        ListView.builder(
            itemCount: issueList?.length,
            itemBuilder: (context, index) {
              int hours = 0;
              int minutes = 0;
              if(issueList![index].fields.timeestimate != null) {
                hours = Duration(
                    minutes: issueList![index].fields.timeestimate ~/ 60)
                    .inHours;
                minutes = Duration(
                    minutes: issueList![index].fields.timeestimate ~/ 60)
                    .inMinutes - hours * 60;
              }

              return Column(
                children: [
                  SizedBox(height: 8,),
                  Ink(
                    width: 370,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            color: Colors.grey
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 10.0,
                          left: 10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.0,),
                          Text(issueList![index].key != null ? 'Ключ: ${issueList![index].key}' : 'Без срока', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Text(issueList![index].fields.duedate != null ? 'Срок окончания: ${issueList![index].fields.duedate}' : 'Без срока', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Text(issueList![index].fields.summary.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Text(issueList![index].fields.description.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Text(issueList![index].fields.timeestimate != null ? 'Срок окончания: ${hours}ч. ${minutes}м.' : 'Без срока', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                child: ElevatedButton(onPressed: () {
                                }, child: Icon(Icons.alarm_add_outlined)),
                                width: 50,
                              ),
                              SizedBox(width: 20.0,),
                              ElevatedButton(onPressed: () async {
                                deleteIssue(issueList![index].key).whenComplete(() => getData());
                              }, child: Icon(Icons.delete)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

  // method() {
  //
  //   setState(() async{
  //     await JiraService().getIssues();
  //     issues = await JiraIssuesList.strIssues;
  //     print('ISSUES LOL' + issues.toString());
  //   });
  // }

  Future<List<Issue>?> getIssues() async {

    String credentials = "dawani2016@mail.ru:Xm6EN8qHwuRFXvLXclBUA0BB";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    print('ENCODED' + encoded.toString());

    var headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "expand": "names,schema", "startAt": 0, "maxResults": 50, "total": 1, "issues": [ { "expand": "", "id": "10001", "self": "https://jirasoftwareildan.atlassian.net/rest/api/2/issue/10001", "key": "GEEK-4"} ] }';

    Uri uri = Uri.parse("https://jirasoftwareildan.atlassian.net/rest/api/2/search");
    uri.replace(query: body);

    var lol = await http.get(uri, headers: headers);
    print( 'GET ISSUES' + lol.body);
    print( 'GET LENGTH' + lol.statusCode.toString());
    print('REDACT ISSUES' + jsonDecode(lol.body).toString());
    if (lol.statusCode == 200 || lol.statusCode == 201) {
      var json1 = lol.body;
      print('LLLLLLLLLL' + getIssuesFromJson(json1).issues.toString());
      // JiraIssuesList.strIssues = jsonDecode(lol.body);
      return getIssuesFromJson(json1).issues;
      // setState(() {
      //   issues = lol.body.toString();
      //   print('HOHOHOH' + issues.toString());
      //   print('KOKOKOKO' + lol.toString());
      // });
    }
    else {
      throw Exception('http.get error: statusCode= ${lol.statusCode}');
    }

  }

  Future deleteIssue(String issueKey) async {

    String credentials = "dawani2016@mail.ru:Xm6EN8qHwuRFXvLXclBUA0BB";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    print('ENCODED' + encoded.toString());

    var headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var deleteUrl = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/api/3/issue/$issueKey');

    var deleteRequest = await http.delete(deleteUrl, headers: headers);

    if (deleteRequest.statusCode == 200 || deleteRequest.statusCode == 201 || deleteRequest.statusCode == 204) {
      var json1 = deleteRequest.body;
      print('LLLLLLLLLL' + getIssuesFromJson(json1).issues.toString());
      // JiraIssuesList.strIssues = jsonDecode(lol.body);
      return getIssuesFromJson(json1).issues;
      // setState(() {
      //   issues = lol.body.toString();
      //   print('HOHOHOH' + issues.toString());
      //   print('KOKOKOKO' + lol.toString());
      // });
    }
    else {
      throw Exception('http.get error: statusCode= ${deleteRequest.statusCode}');
    }
  }


}
