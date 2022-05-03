import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';

import '../utils/database.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // return Text('Something went wrong');
          return Text(snapshot.error.toString() + 'wwwwwwwwwwwwwwwwwwwwwww');
        } else if (snapshot.hasData || snapshot.data != null) {
          print('OKOKKOKOKKOKOKKOKOKOK');
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index].data();
              // String docID = snapshot.data!.docs[index].id;
              print(noteInfo.toString() + 'ppppppppppppppppppppppppppppppppp');
              String title = noteInfo['title'];
              String description = noteInfo['description'];
              Timestamp date = noteInfo['date'];
              String date2 = DateFormat("yyyy-MM-dd - kk:mm").format(date.toDate());

              return Ink(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(29),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 33,
                        color: Colors.grey
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(date2,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      )),
                      SizedBox(height: 20),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            description,
                            width: 100.0,
                          ),
                        ),
                      SizedBox(height: 20),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.orangeAccent,
            ),
          ),
        );
      },
    );
  }
}