import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_diplom_first/res/custom_colors.dart';
import '../utils/database.dart';
import '../utils/validator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddItemForm extends StatefulWidget {
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;

  const AddItemForm({
    required this.titleFocusNode,
    required this.descriptionFocusNode,
  });

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  firebase_storage.Reference? ref;
  late File _choosedImage;
  String _choosedImageStr = 'null';
  final picker = ImagePicker();

  bool _isProcessing = false;

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addItemFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                Text(
                  'Изображение',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ClipRRect(
                          child: _choosedImageStr != 'null' ? Image.file(
                            _choosedImage,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ) : null
                      ),
                    ),
                    SizedBox(width: 30,),
                    ElevatedButton(
                      onPressed: () => chooseImage(),
                      child: Text('Выбрать изображение', style: TextStyle(color: CustomColors.customWhite, fontSize: 16),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CustomColors.customPurple)
                    ),),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  'Описание',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  maxLines: 10,
                  // isLabelEnabled: false,
                  controller: _descriptionController,
                  focusNode: widget.descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  // inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value!,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                    ),
                    labelStyle: TextStyle(color: Colors.yellow),
                    hintText: 'Введите описание',
                    errorStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                )
                )],
            ),
          ),
          _isProcessing
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            ),
          )
              : Container(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  CustomColors.customPurple,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              onPressed: () async {
                widget.titleFocusNode.unfocus();
                widget.descriptionFocusNode.unfocus();

                if (_addItemFormKey.currentState!.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });

                  await uploadFile().whenComplete(() =>
                      setState(() {
                        _isProcessing = false;
                      })
                  );

                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'Добавить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.customWhite,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future uploadFile() async {
    ref = firebase_storage.FirebaseStorage.instance.ref().child('images/newsAppImgs/${Path.basename(_choosedImage.path)}');
    await ref!.putFile(_choosedImage).whenComplete(() async {
      await ref!.getDownloadURL().then((value) {
        Database.addItem(title: _descriptionController.text, description: value, date: Timestamp.now(), type: 'App');
      });
    });
  }

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      // _image.add(File(pickedFile!.path));
      _choosedImage = File(pickedFile!.path);
      _choosedImageStr = _choosedImage.toString();
    });
    print(_choosedImage.toString());
    // await uploadFile();
    // if (pickedFile!.path == null) retrieveLostData();
  }


}