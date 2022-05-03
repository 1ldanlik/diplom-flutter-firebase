import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';

import '../utils/database.dart';

class BirthdayList extends StatelessWidget {
  static String? userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // stream: Database.readDateOfBirthday(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          else if(snapshot.hasData || snapshot.data != null) {
            var dateInfo = snapshot.data!.docs[int.parse(userId.toString())].data();
            return Text(dateInfo['date']);
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orangeAccent,
              ),
            ),
          );
        }
    );
  }
}