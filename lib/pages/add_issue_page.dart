import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:test_diplom_first/utils/created_issue_get.dart';
import 'package:test_diplom_first/utils/projects_get.dart';
import '../utils/validator.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({Key? key}) : super(key: key);

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _focusSummary = FocusNode();
  final _focusDescription = FocusNode();
  final _summaryTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
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
        backgroundColor: Colors.purple,
        title: Text('Добавление задачи', style: TextStyle(fontSize: 24, color: Colors.white),),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if(_summaryTextController.text !='null')
                  createIssue(projectValue,
                      typeIssueValue,
                      priorityValue,
                      _summaryTextController.text,
                      _descriptionTextController.text,
                      _weeks,
                      _days,
                      _hours,
                      _minutes);
                },
                child: Icon(
                  Icons.confirmation_num,
                  size: 26.0,
                ),
              )
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
                      DropdownButton(
                        value: projectValue,
                          items:
                          strCB.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              projectValue = newValue!;
                            });
                          },),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Тип задачи:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      DropdownButton<String>(
                        value: typeIssueValue,
                        items: <String>['Task', 'Epic'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            typeIssueValue = newValue!;
                          });
                        },),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Приоритет:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  Expanded(
                  child: DropdownButtonHideUnderline(
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
                  // value: _mySelection,
                  child: Row(
                  children: <Widget>[
                    SvgPicture.asset(map['image'],width: 30,
                  // Image.asset(
                  // map["image"],
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
                ]
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Text('Название', style: TextStyle(fontSize: 18),),
                    TextFormField(
                      maxLength: 100,
                      decoration: const InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 5.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 5.0),
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
                    TextFormField(
                      maxLength: 500,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 5.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 5.0),
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
                  Text('Недели:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 30,),
                  Container(
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: addWeeks,
                      child: Icon(Icons.add, color: Colors.black,),
                      backgroundColor: Colors.white,),
                  ),
                  SizedBox(width: 10,),
                  Text('$_weeks',
                      style: TextStyle(fontSize: 24.0)),
                  SizedBox(width: 10,),
                  Container(
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: minusWeeks,
                      child: Icon(Icons.remove),
                    backgroundColor: Colors.white,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Дни:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 60,),
                  Container(
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: addDays,
                      child: Icon(Icons.add, color: Colors.black,),
                      backgroundColor: Colors.white,),
                  ),
                  SizedBox(width: 10,),
                  Text('$_days',
                      style: TextStyle(fontSize: 24.0)),
                  SizedBox(width: 10,),
                  Container(
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: minusDays,
                      child: Icon(Icons.remove),
                    backgroundColor: Colors.white,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Часы:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 50,),
                  Container(
                    width: 40,
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
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: minusHours,
                      child: Icon(Icons.remove),
                    backgroundColor: Colors.white,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Минуты:', style: TextStyle(fontSize: 18),),
                  SizedBox(width: 30,),
                  Container(
                    width: 40,
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
                    width: 40,
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
      int week,
      int hour,
      int day,
      int minute, ) async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    String body = '{ "fields": { "project": { "key": "$projectValue" }, "summary": "$summary", "description": "$description", "issuetype": { "name": "$typeIssueValue" }, "priority":{ "name": "$priorityValue" } } }';

    var url = Uri.parse(
        'https://jirasoftwareildan.atlassian.net/rest/api/2/issue/');
    var lol = await http.post(url, headers: headers,
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
    await createWorkLog(week, day, hour, minute, _json.key);
  }

  createWorkLog(int _week,
      int _day,
      int _hour,
      int _minute,
      String _issueKey) async {
    var headers = {
      'Authorization': 'Basic ZGF3YW5pMjAxNkBtYWlsLnJ1OlhtNkVOOHFId3VSRlh2TFhjbEJVQTBCQg==',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // String body = '{ "timeSpent": "${week}w${day}d${hour}h${minute}m" }';
    String body = '{ "update": { "timetracking":[ { "edit": { "originalEstimate":"${_week}w ${_day}d ${_hour}h ${_minute}m", "remainingEstimate":"${_week}w ${_day}d ${_hour}h ${_minute}m" } } ] } }';

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
