import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_diplom_first/utils/projects_get.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({Key? key}) : super(key: key);

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  late List<Value> projectsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(var proj in )
  }

  getData() async {
    projectsList = await getProjects();
    if(projectsList != null){
      setState(() {
        // isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text('Проект:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                // DropdownButton(
                //     items: projectsList.map((List<Value> {
                //
                //     }),
                //     onChanged: onChanged)
              ],
            )
          ],
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

}
