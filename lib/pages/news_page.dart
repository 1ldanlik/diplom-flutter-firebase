import 'package:flutter/material.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io' as io;

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
  String botName = '';
  var msgId = 0;
  String _image = 'https://upload.wikimedia.org/wikipedia/ru/7/7c/%D0%A2%D0%B0%D1%87%D0%BA%D0%B8_%D0%BF%D0%BE%D1%81%D1%82%D0%B5%D1%80.jpg';

  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  List<Map<String, Map<String, String>>> _msgs = [];

  final telegramApiKey = '5319164055:AAH44FhYObq6qHBr4_D_DVezT9kmk2cBvx0';

  @override
  void initState() {
    super.initState();
    _startBot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(widget.title),
        // actions: [
        //   IconButton(icon: Icon(Icons.play_arrow), onPressed: () => _startBot())
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9
                ],
                colors: [
                  Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.teal
                ])),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.network(
                  _image,
                  fit: BoxFit.cover),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: ListView.builder(
                  itemCount: _msgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: _getAligment(index),
                      children: [
                        Flexible(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_msgs.isNotEmpty ? _msgs[index] : ''}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        )
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 20.0,
            ),
            Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Message',
                      hintText: 'input text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      )),
                  controller: _controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter text';
                    }
                    return null;
                  },
                )),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    botSendMessage(_controller.text);
                    _controller.text = '';
                  }
                })
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

    teleDart!
        .onMessage(entityType: 'bot_command', keyword: 'start')
        .listen((message) {
      msgId = message.chat.id;
      teleDart!.telegram.sendMessage(msgId, 'Hello I am Flutter bot');
    });

    teleDart!
        .onMessage(entityType: 'bot_command', keyword: 'dart')
        .listen((message) {
        msgId = message.chat.id;
        setState(() {
        _msgs.add({message.chat.username.toString(): {message.text! : message.photo.toString()}});
        });
        print('+++++++++++' + message.text!);
        print('-----------' + message.photo.toString());
        print(_msgs);
    });


    teleDart!.onMessage().listen((message) {
      // message.reply('${message.from.first_name} say ${message.text}');
      msgId = message.chat.id;
      setState(() {
        _msgs.add({message.chat.username.toString(): {message.text! : message.photo.toString()}});
      });
      print('+++++++++++' + message.text!);
      print('-----------' + message.photo.toString());
      print(_msgs);
    });

    teleDart!.onMessage(keyword: 'Load images').listen((message) async {

      // ask user to select one photo
      teleDart!.telegram.sendMessage(message.chat.id, 'choose one');

      // subscribe to user input
      final subscription = teleDart!.onMessage().listen((_) {});

      // listen subscription
      subscription.onData((data) async {

        // if user upload photo do the following
        if (data.photo != null) {
          print('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||----' + data.photo.toString() + '&&&&&&&&&&&&&&&&' );
          // create the dicrectory on the host
          final tPhoto = data.photo!.last;
          print('???????tPhoto' + tPhoto.toString() + '??????????');
          final tFile = await teleDart!.telegram.getFile(tPhoto.file_id);
          print('???????tFile' + tFile.toString() + '??????????');

          // print('_IIIIImage' + _image.toString());
          final tFileLink = tFile.getDownloadLink(telegramApiKey);
          print('???????tFileLink' + tFileLink.toString() + '??????????');
          final request = await io.HttpClient().getUrl(Uri.parse(tFileLink!));
          print('???????request' + request.toString() + '??????????');
          final response = await request.close();
          print('???????response' + response.toString() + '??????????');
          setState(() {
            _image = tFileLink.toString();
          });

          final dir =
          await io.Directory('/var/upload/${message.chat.id}').create();
          print('/var/upload/${message.chat.id}, -------${message.photo.toString()}-----');

          // download photo to the directory

          downloadPhoto(
            '${dir.path}/img.png',
            telegramApiKey,
            data,
            teleDart!,
          ).then((value) =>
              teleDart!.telegram.sendMessage(data.chat.id, 'image loaded'));
        }
      });
    });

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
    print('АХУЕТЬ');
  }


// teleDart!.fetcher.onUpdate().listen((event) {
    //   msgId = event.message!.chat.id;
    //   setState(() {
    //     _msgs.add({event.message!.chat.username.toString(): {event.message!.text! : event.message!.photo.toString()}});
    //   });
    //   print('+++++++++++' + event.message!.text!);
    //   print('-----------' + event.message!.photo.toString());
    //   print(_msgs);
    // });


  botSendMessage(String msg) {
    teleDart!.telegram.sendMessage(msgId, msg);
    setState(() {
      _msgs.add({botName: {msg : ''}});
    });
  }

  @override
  void dispose() {
    teleDart!.stop();
    super.dispose();
  }
}