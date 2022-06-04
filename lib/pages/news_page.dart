import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_diplom_first/widgets/add_item_form.dart';
import 'package:test_diplom_first/widgets/telegram_list.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

import '../res/custom_colors.dart';
import '../utils/database.dart';
import 'add_news_page.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TODO Secret API Key
  final telegram = Telegram('5319164055:AAH44FhYObq6qHBr4_D_DVezT9kmk2cBvx0');
  TeleDart? teleDart;
  firebase_storage.Reference? ref;
  String botName = '';
  var msgId = 0;
  final _formKey = GlobalKey<FormState>();
  static String? userUid;
  List<Map<String, String>> _msgs = [];
  List<Map<int, String>> _imgs = [];
  final telegramApiKey = '5319164055:AAH44FhYObq6qHBr4_D_DVezT9kmk2cBvx0';
  static String? title = 'null';

  @override
  void initState() {
    super.initState();
    _startBot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customPurple,
        leading: BackButton(color: CustomColors.customWhite,),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image.asset("assets/jira_icon.png", width: 20, color: Colors.white,),
            // SizedBox(width: 20,),
            Text('Новости',
              style: TextStyle(fontSize: 24, color: Colors.white),),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height / 1.38,
              child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left:16.0,
                  right:16.0,
                  // bottom:20.0,
                ),
                child: ItemList(),
              ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: CustomColors.customPurple,
                borderRadius: BorderRadius.circular(30)
              ),
              child: IconButton(
                  icon: Icon(Icons.add, color: CustomColors.customWhite, size: 40,),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                            AddNewsPage()
                        ));
                    }),
            )
          ],
        ),
      ),
    );
  }

  _getAligment(index) {
    if (_msgs[index].keys.toList()[0] == botName) {
      return MainAxisAlignment.end;
    }
    return MainAxisAlignment.start;
  }

  _startBot() async {
    final event = Event((await telegram.getMe()).username!);
    teleDart = TeleDart(telegram, event);
    teleDart!.start();

    // teleDart!
    //     .onMessage(entityType: 'bot_command', keyword: 'start')
    //     .listen((message) {
    //   msgId = message.chat.id;
    //   teleDart!.telegram.sendMessage(msgId, 'Hello I am Flutter bot');
    // });
    //
    // teleDart!
    //     .onMessage(entityType: 'bot_command', keyword: 'dart')
    //     .listen((message) {
    //   msgId = message.chat.id;
    //   setState(() {
    //     _msgs.add({message.chat.username.toString(): message.text!});
    //   });
    //   print('+++++++++++' + message.text!);
    //   print('-----------' + message.photo.toString());
    //   print(_msgs);
    // });


    teleDart!.onMessage().listen((message) {
      msgId = message.chat.id;
      setState(() {
        _msgs.add({message.chat.username.toString(): message.text!});
      });
    });

    // teleDart!.onMessage(keyword: 'Load images').listen((message) async {
    //
    //   // ask user to select one photo
    //   teleDart!.telegram.sendMessage(message.chat.id, 'choose one');

      // subscribe to user input
      final subscription = teleDart!.onMessage().listen((_) {});

      subscription.onData((data) async {
        teleDart!.telegram.getChat(data.message_id);
        if (data.photo != null) {
          final tPhoto = data.photo!.last;
          final tFile = await teleDart!.telegram.getFile(tPhoto.file_id);
          final tFileLink = tFile.getDownloadLink(telegramApiKey);
          // Database.addItem(title: data.caption.toString(),
          //     description: tFileLink.toString(),
          //     date: Timestamp.fromDate(data.date_),
          //     type: 'Telegram').then((value) => print(''
          //     'Message'+ data.caption.toString()));
          uploadFile(data.caption.toString(), tFileLink.toString(), data.date_);
          print('???????tFileLink' + tFileLink.toString() + '??????????');
          final request = await io.HttpClient().getUrl(Uri.parse(tFileLink!));
          print('???????request' + request.toString() + '??????????');
          final response = await request.close();
          print('???????response' + response.toString() + '??????????');
          setState(() {

          });
        }
      });
    // });
    // teleDart!.onMessage(keyword: 'lol').listen((message) {
    //   print('--------MESAGETEXT----------' + message.text.toString() + '------');
    //   teleDart!.telegram.sendMessage(message.chat.id, 'image deleted' + message.caption.toString());

    // });
    // execute this if user hit 'Delete images' button
    teleDart!.onMessage(keyword: 'Delete images').listen((message) {
      // delete folder and image in it
      deletePhotosDirectory(teleDart!, message).then((value) =>
          teleDart!.telegram.sendMessage(message.chat.id, 'image deleted'));
    });

  }

  Future<void> deletePhotosDirectory(
      TeleDart teledart,
      TeleDartMessage message,
      ) async {
    final dir = io.Directory('/var/upload/${message.chat.id}');
    final isDirExist = await dir.exists();
    if (isDirExist) {
      await io.Directory('/var/upload/${message.chat.id}')
          .delete(recursive: true);
    } else {
      teledart.telegram.sendMessage(message.chat.id, 'Nothing to delete');
    }
  }

  Future<void> downloadPhoto(
      String path,
      String telegramApiKey,
      TeleDartMessage message,
      TeleDart teledart,
      ) async {
    final tPhoto = message.photo!.last;
    final tFile = await teledart.telegram.getFile(tPhoto.file_id);
    final tFileLink = tFile.getDownloadLink(telegramApiKey);
    final request = await io.HttpClient().getUrl(Uri.parse(tFileLink!));
    final response = await request.close();
    await response.pipe(io.File(path).openWrite()) as io.File;
  }


// teleDart!.fetcher.onUpdate().listen((event) {
  //   msgId = event.message!.chat.id;
  //   setState(() {
  //     _msgs.add({event.message!.chat.username.toString(): {event.message!.text! : event.message!.photo.toString()}});
  //   });
  //   print('+++++++++++' + event.message!.text!);
  //   print('-----------' + event.message!.photo.toString());
  //   print(_msgs);
  //   print(_msgs);
  // });


  Future uploadFile(String caption,
      String tFileLink,
      DateTime date) async {
    ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${tFileLink}');
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(tFileLink)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    await ref!.putData(bytes).whenComplete(() async {
      await ref!.getDownloadURL().then((value) {
        Database.addItem(title: caption,
            description: value,
            date: Timestamp.fromDate(date),
            type: 'Telegram').then((value) => print(''
            'Message'+ caption.toString()));;
      });
    });
  }

  botSendMessage(String msg) {
    teleDart!.telegram.sendMessage(msgId, msg);
    setState(() {
      _msgs.add({botName: msg});
    });
  }

  @override
  void dispose() {
    teleDart!.stop();
    super.dispose();
  }
}