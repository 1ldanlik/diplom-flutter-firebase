import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import '../widgets/add_item_form.dart';

class AddNewsPage extends StatefulWidget {
  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.customWhite,
        appBar: AppBar(
          backgroundColor: CustomColors.customPurple,
          leading: BackButton(color: CustomColors.customWhite,),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image.asset("assets/jira_icon.png", width: 20, color: Colors.white,),
              // SizedBox(width: 20,),
              Text('Добавление новости',
                style: TextStyle(fontSize: 24, color: Colors.white),),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: AddItemForm(
              titleFocusNode: _titleFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
            ),
          ),
        ),
      ),
    );
  }
}