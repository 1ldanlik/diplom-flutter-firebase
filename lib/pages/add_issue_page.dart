import 'dart:convert';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:test_diplom_first/utils/projects_get.dart';

import '../utils/validator.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({Key? key}) : super(key: key);

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _focusEmail = FocusNode();
  final _summaryTextController = TextEditingController();
  late List<Value> projectsList;
  List<String> strCB = [];
  late String projectValue;
  String typeIssueValue = 'Task';
  String priorityValue = 'Medium';
  late int hours;
  late int minutes;
  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    projectsList = await getProjects();
    if(projectsList != null){
      setState(() {
        strCB.add('Все');
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
      body: Container(
        padding: EdgeInsets.only(top: 150.0),
        child: Center(
          child: Column(
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
              SizedBox(height: 30,),
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
              Row(
                children: [
                  Text('Приоритет:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  DropdownButton<String>(
                    value: priorityValue,
                    items: <String>['Highest', 'High', 'Medium', 'Low', 'Lowest'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        priorityValue = newValue!;
                      });
                    },),
                ],
              ),
              Text('Название', style: TextStyle(fontSize: 18),),
              TextFormField(
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
                focusNode: _focusEmail,
                validator: (value) => Validator.validateSummary(summary: value),
              ),
              Text('Описание', style: TextStyle(fontSize: 18),),
              TextFormField(
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
                focusNode: _focusEmail,
                validator: (value) => Validator.validateSummary(summary: value),
              ),
                  Text('Часы:', style: TextStyle(fontSize: 18),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: addHours,
                    child: Icon(Icons.add, color: Colors.black,),
                    backgroundColor: Colors.white,),

                  Text('$_hours',
                      style: TextStyle(fontSize: 24.0)),

                  FloatingActionButton(
                    onPressed: minusHours,
                    child: Icon(Icons.remove),
                  backgroundColor: Colors.white,),
                ],
              ),
                  Text('Минуты:', style: TextStyle(fontSize: 18),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: addMinutes,
                    child: Icon(Icons.add, color: Colors.black,),
                    backgroundColor: Colors.white,),

                  Text('$_minutes',
                      style: TextStyle(fontSize: 24.0)),

                  FloatingActionButton(
                    onPressed: minusMinutes,
                    child: Icon(Icons.remove),
                  backgroundColor: Colors.white,),
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

}
