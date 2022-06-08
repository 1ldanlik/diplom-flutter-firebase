import 'dart:convert';
import 'package:adaptive_spinner/adaptive_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:test_diplom_first/pages/jira_issues_list.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import 'package:test_diplom_first/utils/created_issue_get.dart';
import 'package:test_diplom_first/utils/jira_auth.dart';
import 'package:test_diplom_first/utils/projects_get.dart';
import '../utils/validator.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({Key? key}) : super(key: key);
  // static const IconData check = IconData(0xe156, fontFamily: 'MaterialIcons');

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _focusSummary = FocusNode();
  final _focusDescription = FocusNode();
  final _summaryTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  bool isProcess = false;
  late List<Value> projectsList;
  List<String> strCB = [];
  String projectValue = 'null';
  String typeIssueValue = 'Task';
  String priorityValue = 'Medium';
  late int hours;
  late int minutes;
  int _weeks = 0;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  List<Map> priorityMap = [
    {"name": 'Highest', "image": "assets/highest.svg"},
    {"name": 'High', "image": "assets/high.svg"},
    {"name": 'Medium', "image": "assets/medium.svg"},
    {"name": 'Low', "image": "assets/low.svg"},
    {"name": 'Lowest', "image": "assets/lowest.svg"},
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customPurple,
        leading: BackButton(color: CustomColors.customWhite, onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>
                  JiraIssuesList()
              )
          );
        },),
        title: Text('Добавление задачи', style: TextStyle(fontSize: 24, color: Colors.white),),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: isProcess == false ? GestureDetector(
                onTap: () {
                  if(_summaryTextController.text !='null' && _descriptionTextController.text != 'null'
                  && _hours != 0 && _minutes != 0)
                    setState(() {
                      isProcess = true;
                    });
                  createIssue(projectValue,
                      typeIssueValue,
                      priorityValue,
                      _summaryTextController.text,
                      _descriptionTextController.text,
                      _hours,
                      _minutes)
                      .whenComplete(() => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => JiraIssuesList())
                  ) );
                },
                child: Icon(
                  Icons.check,
                  size: 26.0,
                  color: CustomColors.customWhite,
                ),
              ) :
              AdaptiveSpinner(withRadius: 30,),
          ),
        ],
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 40.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text('Проект:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      new DropdownButtonHideUnderline(
                        child: Container(
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
                                });
                              },),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Тип задачи:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      SizedBox(width: 10,),
                      Container(
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
                        child: ButtonTheme(
                          child: new DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: typeIssueValue,
                              items: <String>['Task', 'Epic'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child:
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(value)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  typeIssueValue = newValue!;
                                });
                              },),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Приоритет:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  SizedBox(width: 10,),
                  DropdownButtonHideUnderline(
                    child: Container(
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
                      child: ButtonTheme(
                        child: DropdownButton<String>(
                          value: priorityValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              priorityValue = newValue!;
                            });

                            print(priorityValue);
                          },
                          items: priorityMap.map((Map map) {
                            return new DropdownMenuItem<String>(
                              value: map["name"].toString(),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(map['image'],width: 30,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(map["name"])),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  // ),
                ]
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Text('Название', style: TextStyle(fontSize: 18),),
                    SizedBox(height: 10,),
                    TextFormField(
                      cursorColor: CustomColors.customBlack,
                      maxLength: 100,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          )
                      ),
                      controller: _summaryTextController,
                      focusNode: _focusSummary,
                      validator: (value) => Validator.validateSummary(summary: value),
                    ),
                    Text('Описание', style: TextStyle(fontSize: 18),),
                    SizedBox(height: 10,),
                    TextFormField(
                      cursorColor: CustomColors.customBlack,
                        maxLength: 500,
                        maxLines: 6,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 30),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 3.0),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                )
                            )
                        ),
                        controller: _descriptionTextController,
                        focusNode: _focusDescription,
                        validator: (value) => Validator.validateSummary(summary: value),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Часы:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 50,),
                  Container(
                    width: 60,
                    child: FloatingActionButton(
                      onPressed: addHours,
                      child: Icon(Icons.add, color: Colors.black,),
                      backgroundColor: Colors.white,),
                  ),
                  SizedBox(width: 10,),
                  Text('$_hours',
                      style: TextStyle(fontSize: 24.0)),
                  SizedBox(width: 10,),
                  Container(
                    width: 60,
                    child: FloatingActionButton(
                      onPressed: minusHours,
                      child: Icon(Icons.remove),
                    backgroundColor: Colors.white,),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Минуты:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 30,),
                  Container(
                    width: 60,
                    child: FloatingActionButton(
                      onPressed: addMinutes,
                      child: Icon(Icons.add, color: Colors.black,),
                      backgroundColor: Colors.white,),
                  ),
                  SizedBox(width: 10,),
                  Text('$_minutes',
                      style: TextStyle(fontSize: 24.0)),
                  SizedBox(width: 10,),
                  Container(
                    width: 60,
                    child: FloatingActionButton(
                      onPressed: minusMinutes,
                      child: Icon(Icons.remove),
                    backgroundColor: Colors.white,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  void minusHours() {
    setState(() {
      if (_hours != 0)
        _hours--;
    });
  }

  void addHours() {
    setState(() {
      _hours++;
    });
  }

  void minusMinutes() {
    setState(() {
      if (_minutes != 0)
        _minutes--;
    });
  }

  void addMinutes() {
    setState(() {
      _minutes++;
    });
  }

  void minusWeeks() {
    setState(() {
      if (_weeks != 0)
        _weeks--;
    });
  }

  void addWeeks() {
    setState(() {
      _weeks++;
    });
  }

  void minusDays() {
    setState(() {
      if (_days != 0)
        _days--;
    });
  }

  void addDays() {
    setState(() {
      _days++;
    });
  }

  Future createIssue(String projectValue,
      String typeIssueValue,
      String priorityValue,
      String summary,
      String description,
      int hour,
      int minute, ) async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "fields": { "project": { "key": "$projectValue" }, "summary": "$summary", "description": "$description", "issuetype": { "name": "$typeIssueValue" }, "priority":{ "name": "$priorityValue" } } }';

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
    var lol = await http.post(url, headers: JiraAuth.headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    if (lol.statusCode != 201) throw Exception(
        'http.get error: statusCode= ${lol.statusCode}');
    print(lol.body.toString() + 'CreateIssue');
    var _json = await getCreatedIssueFromJson(lol.body);

    // var url = Uri.parse('https://jirasoftwareildan.atlassian.net/rest/auth/1/session/');
    // var res = await http.get(url, headers: headers);
    // if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    // print(res.body.toString() + '999999999999999999');
    await createWorkLog(hour, minute, _json.key);
  }

  createWorkLog(
      int _hour,
      int _minute,
      String _issueKey) async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // String body = '{ "timeSpent": "${week}w${day}d${hour}h${minute}m" }';
    String body = '{ "update": { "timetracking":[ { "edit": { "originalEstimate":"${_hour}h ${_minute}m", "remainingEstimate":"${_hour}h ${_minute}m" } } ] } }';

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/$_issueKey');
    var lol = await http.put(url, headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"));
    if (lol.statusCode != 201 || lol.statusCode != 204) throw Exception(
        'http.get error: statusCode= ${lol.statusCode}');
    print(lol.body.toString() + 'lllllllllll');

  }

}
