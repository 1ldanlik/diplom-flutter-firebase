import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:test_diplom_first/res/custom_colors.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    Key? key,
    this.radius = 8,
    required this.mdFileName,
  })  : assert(mdFileName.contains('.md'), 'The file must contain the .md extension'),
        super(key: key);
  final double radius;
  final String mdFileName;



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/$mdFileName');
            }),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Markdown(
                    data: snapshot.data.toString(),
                );
              }
              return Center(
              child: CircularProgressIndicator(),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  ),
                ),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.customPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
