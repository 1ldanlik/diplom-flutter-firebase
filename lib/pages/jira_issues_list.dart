import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:test_diplom_first/pages/add_issue_page.dart';
import 'package:test_diplom_first/pages/choose_page.dart';
import 'package:test_diplom_first/pages/jira_login_page.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import 'package:test_diplom_first/utils/fire_auth.dart';
import 'package:test_diplom_first/utils/issues_get.dart';
import 'package:test_diplom_first/utils/jira_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/projects_get.dart';
import '../utils/validator.dart';

class JiraIssuesList extends StatefulWidget {
  const JiraIssuesList({Key? key}) : super(key: key);
  static List<Issue>? issueListSt = [];

  @override
  State<JiraIssuesList> createState() => _JiraIssuesListState();
}

class _JiraIssuesListState extends State<JiraIssuesList> {
  late String? issues;
  var isLoaded = false;
  List<Issue>? issueList;
  List<Issue>? filterList;
  late List<Value> projectsList;
  String projectValue = 'Все';
  List<String> strCB = [];
  DateTime? dateTime;
  final zero = DateTime;
  int _hours = 0;
  int _minutes = 0;
  final _focusHour = FocusNode();
  final _focusMinute = FocusNode();
  final _hourTextController = TextEditingController();
  final _minuteTextController = TextEditingController();
  String priorityValue = 'Все';
  List<Map> priorityMap = [
    {"name": 'Все', "image": "null"},
    {"name": 'Highest', "image": "assets/highest.svg"},
    {"name": 'High', "image": "assets/high.svg"},
    {"name": 'Medium', "image": "assets/medium.svg"},
    {"name": 'Low', "image": "assets/low.svg"},
    {"name": 'Lowest', "image": "assets/lowest.svg"},
  ];

  @override
  void initState() {
    super.initState();
    getProjectData();
    getData();
  }

  getProjectData() async {
    strCB.add('Все');
    projectsList = await getProjects();
    if(projectsList != null){
      setState(() {
        for(var proj in projectsList)
        {
          strCB.add(proj.name);
          print(strCB);
        }
        projectValue = strCB[0];
        // isLoaded = true;
      });
    }
  }

  getData() async{
    if(priorityValue == 'Все' && projectValue == 'Все') {
      issueList = await getIssues();
    }
    else if (priorityValue != 'Все' && projectValue != 'Все')
    {
      issueList = await getIssues();
      issueList = issueList!.where((element) => element.fields.priority.id == priorityToIdMethod(priorityValue)
          && element.key.contains(projectValue)).toList();
    }
    else if (priorityValue != 'Все' && projectValue == 'Все')
    {
      issueList = await getIssues();
      issueList = issueList!.where((element) => element.fields.priority.id == priorityToIdMethod(priorityValue)).toList();
    }
    else if (priorityValue == 'Все' && projectValue != 'Все')
    {
      issueList = await getIssues();
      issueList = issueList!.where((element) => element.key.contains(projectValue)).toList();
    }
    else
    {
      issueList = await getIssues();
      issueList = issueList!.where((element) => element.fields.priority.id == priorityToIdMethod(priorityValue)).toList();
    }

    if(issueList != null) {
          setState(() {
            isLoaded = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customPurple,
        leading: BackButton(color: CustomColors.customWhite, onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>
            JiraLoginPage()
            )
          );
        },),
        title: Row(
          children: [
            Image.asset("assets/jira_icon.png", width: 20, color: Colors.white,),
            SizedBox(width: 20,),
            Text('Задачи',
                style: TextStyle(fontSize: 24, color: Colors.white),),
          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.customWhite,
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(width: 2),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 3,
                            color: Colors.grey
                        ),
                      ],
                    ),
                    height: 30,
                    // color: CustomColors.customWhite,
                    child:

                    PopupMenuButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 6
                        ),
                        child:Text("Фильтры", style: TextStyle(color: CustomColors.customBlack, fontWeight: FontWeight.w500),),
                      ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Text("Приоритет: "),
                                StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: CustomColors.customWhite,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 3),
                                              blurRadius: 3,
                                              color: Colors.grey
                                          ),
                                        ],
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          child: DropdownButton<String>(
                                            value: priorityValue,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                priorityValue = newValue!;
                                                // sortMethod()!.whenComplete(() => getData());
                                                getData();
                                              });

                                              print(priorityValue);
                                            },
                                            items: priorityMap.map((Map map) {
                                              return new DropdownMenuItem<String>(
                                                value: map["name"].toString(),
                                                child: Row(
                                                  children: <Widget>[
                                                    map['image'] != 'null' ?
                                                    SvgPicture.asset(
                                                      map['image'], width: 30,
                                                    ) : SizedBox(),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(map["name"])),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Text("Проект: "),
                                SizedBox(width: 25,),
                                StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return DropdownButtonHideUnderline(
                                      child: Container(
                                        height: 40,
                                        width: 125,
                                        decoration: BoxDecoration(
                                          color: CustomColors.customWhite,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Colors.grey
                                            ),
                                          ],
                                        ),
                                        child: DropdownButton(
                                          value: projectValue,
                                          items:
                                          strCB.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Text(value),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              projectValue = newValue!;
                                              getData();
                                            });
                                          },),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                            value: 2,
                          )
                        ]
                    )
                  ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                          AddIssuePage())
                        );
                      },
                      child: Icon(
                        Icons.add, color: CustomColors.customWhite,
                        size: 26.0,
                      ),
                    ),
                ],
              )
          ),
        ],
      ),
      body:
      Container(
        color: CustomColors.customWhite,
        child: Visibility(
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

                      String? priority = priorityToNameMethod(int.parse(issueList![index].fields.priority.id));

                      return Column(
                        children: [
                          SizedBox(height: 13,),
                          Ink(
                            width: 370,
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 10.0,
                                  left: 10.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 10.0,),
                                  Text(issueList![index].fields.timeestimate != null && issueList![index].fields.timeestimate != 0  ? 'Срок окончания: ${hours}ч. ${minutes}м.' : 'Без срока', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0,),
                                  Text(issueList![index].key != null ? 'Ключ: ${issueList![index].key}' : 'Без срока', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0,),
                                  Text(issueList![index].fields.summary.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0,),
                                  Text(issueList![index].fields.description.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: [
                                      Container(
                                        child: ElevatedButton(onPressed: () {
                                          showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) => Container(
                                              child: AlertDialog(
                                                title: Row(
                                                  children: [
                                                    const Text('Добавить время',
                                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                                    SizedBox(width: 20,),
                                                    IconButton(onPressed: () => Navigator.pop(context, 'Отменить'), icon: Icon(Icons.cancel_rounded), iconSize: 30,)
                                                  ],
                                                ),
                                                content:  Container(
                                                  child: Column(
                                                    children: [
                                                      const Text('Часы:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                        height: 50,
                                                        width: 200,
                                                        child: TextFormField(
                                                          style: TextStyle(fontSize: 24),
                                                          decoration: const InputDecoration(
                                                              enabledBorder:  OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                                                  borderRadius: BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              ),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                                                  borderRadius: BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              ),
                                                              focusedBorder:  OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                                                  borderRadius:  BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              )
                                                          ),
                                                          controller: _hourTextController,
                                                          focusNode: _focusHour,
                                                          validator: (value) => Validator.validateNumber(number: value),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      const Text('Минуты:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                        height: 50,
                                                        width: 200,
                                                        child: TextFormField(
                                                          style: TextStyle(fontSize: 24),
                                                          decoration: const InputDecoration(
                                                              enabledBorder:  OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                                                  borderRadius: BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              ),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                                                  borderRadius: BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              ),
                                                              focusedBorder:  OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                                                                  borderRadius:  BorderRadius.all(
                                                                     Radius.circular(30.0),
                                                                  )
                                                              )
                                                          ),
                                                          controller: _minuteTextController,
                                                          focusNode: _focusMinute,
                                                          validator: (value) => Validator.validateNumber(number: value),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  height: 192,
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context, 'Добавить');
                                                          logSpentTime(int.parse(_hourTextController.text), (int.parse(_minuteTextController.text)),
                                                              issueList![index].key).whenComplete(() {
                                                                getData();
                                                                print('LOGGED TIME');
                                                                toNull();
                                                              }
                                                          );
                                                        },
                                                        child: Text('Добавить',
                                                          style: TextStyle(fontSize: 24),),
                                                      ),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );

                                        }, child: Icon(Icons.alarm_add_outlined, color: CustomColors.customWhite,),
                                          style: ElevatedButton.styleFrom(
                                              primary: CustomColors.customPurple,
                                              textStyle: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        width: 60,
                                        height: 40,
                                      ),
                                      SizedBox(width: 20.0,),
                                      Container(
                                        width: 60,
                                        height: 40,
                                        child: ElevatedButton(onPressed: () async {
                                          deleteIssue(issueList![index].key).whenComplete(() => getData());
                                        }, child: Icon(Icons.delete, color: CustomColors.customWhite,),
                                          style: ElevatedButton.styleFrom(
                                              primary: CustomColors.customRed,
                                              textStyle: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      SizedBox(width: 150,),
                                      SvgPicture.asset(priorityToImage(priority.toString()).toString(),width: 40,)
                                    ],
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.customWhite,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(width: 2),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 5),
                                      blurRadius: 5,
                                      color: Colors.grey
                                  ),
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
              ),
        ),
      );
  }

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

    var response = await http.get(uri, headers: headers);
    print( 'GET ISSUES' + response.body);
    print( 'GET LENGTH' + response.statusCode.toString());
    print('REDACT ISSUES' + jsonDecode(response.body).toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json1 = response.body;
      print('LLLLLLLLLL' + getIssuesFromJson(json1).issues.toString());
      return getIssuesFromJson(json1).issues;
    }
    else {
      throw Exception('http.get error: statusCode= ${response.statusCode}');
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

  Future logSpentTime(
      int _hour,
      int _minute,
      String _issueKey) async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "timeSpent": "${_hour}h ${_minute}m" }';

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/3/issue/$_issueKey/worklog');
    var response = await http.post(url, headers: JiraAuth.headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    if (response.statusCode != 201 || response.statusCode != 204) throw Exception(
        'http.get LOG TIME error: statusCode= ${response.statusCode}');
    print(response.body.toString() + 'lllllllllll');

  }

  toNull() {
    setState(() {
      _hours = 0;
      _minutes = 0;
    });
  }


  Future? sortMethod () async {
    issueList = await issueList!.where((element) => element.fields.priority.id == priorityToIdMethod(priorityValue)).toList();
  }


  Future getProjects() async {
    String credentials = "dawani2016@mail.ru:Xm6EN8qHwuRFXvLXclBUA0BB";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    print('ENCODED' + encoded.toString());

    var headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var getUrl = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/api/3/project/search');

    var getRequest = await http.get(getUrl, headers: headers);

    if (getRequest.statusCode == 200 || getRequest.statusCode == 201 || getRequest.statusCode == 204) {
      var json1 = getRequest.body;
      print('LLLLLLLLLL' + getProjectsFromJson(json1).toString());
      return getProjectsFromJson(json1).values;
    }
    else {
      throw Exception('http.get error: statusCode= ${getRequest.statusCode}');
    }
  }

  String? priorityToNameMethod(int id) {
    if(id == 1)
      return 'Highest';
    if(id == 2)
      return 'High';
    if(id == 3)
      return 'Medium';
    if(id == 4)
      return 'Low';
    if(id == 5)
      return 'Lowest';
  }

  String? priorityToIdMethod(String name) {
    if(name == 'Highest')
      return '1';
    if(name == 'High')
      return '2';
    if(name == 'Medium')
      return '3';
    if(name == 'Low')
      return '4';
    if(name == 'Lowest')
      return '5';
  }

  String? priorityToImage(String name) {
    if(name == 'Highest')
      return "assets/highest.svg";
    if(name == 'High')
      return "assets/high.svg";
    if(name == 'Medium')
      return "assets/medium.svg";
    if(name == 'Low')
      return "assets/low.svg";
    if(name == 'Lowest')
      return "assets/lowest.svg";
  }

}
