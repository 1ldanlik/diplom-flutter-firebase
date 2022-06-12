import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:test_diplom_first/res/custom_colors.dart';

import '../utils/database.dart';

class ItemList extends StatefulWidget {
  @override
  static const IconData telegram = IconData(0xf0586, fontFamily: 'MaterialIcons');

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  // final ScrollController _scrollController = ScrollController();
  final _scrollController = ScrollController(initialScrollOffset: 50.0);
  final scrollController = ScrollController(initialScrollOffset: 0);


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Что-то пошлло не так!');
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index].data();
              String title = noteInfo['title'];
              String description = noteInfo['description'];
              Timestamp date = noteInfo['date'];
              String type = noteInfo['type'];
              final duration = Duration(hours: 3);
              String date2 = DateFormat("yyyy-MM-dd - kk:mm").format(date.toDate().add(duration));

              return Ink(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child:
                  Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: CustomColors.customWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(width: 2),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 3,
                          color: Colors.grey
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 5.0,
                          left: 10.0),
                        child: type == "Telegram" ? Icon(
                          ItemList.telegram,
                          color: CustomColors.customBlack,
                          size: 35,
                        ) : SizedBox(width: 40.0,),
                      ),
                      SizedBox(width: 180,),
                      Column(
                        children: [
                          SizedBox(height: 10,),
                          Text(date2,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          )),
                        ],
                      ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: AspectRatio(
                            aspectRatio: 15/8,
                            child: Image.network(
                              description,
                              width: 100.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      Container(
                        child: title != 'null' ? Column(
                           children:[ Text(
                        title != 'null' ? title : '',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ), SizedBox(height: 10)]) : null
                      ),
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