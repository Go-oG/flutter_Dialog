import 'package:flutter/material.dart';
import 'package:material_dialog/share.dart';
import 'package:material_dialog/subtype/simple_dialog.dart' as cs;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 64)),
              RaisedButton(
                child: Text("Simple Dialog"),
                onPressed: () => _showSimpleDialog(context),
              ),
              RaisedButton(
                child: Text("Input Dialog"),
                onPressed: () => _showInputDialog(context),
              ),
              RaisedButton(
                child: Text("List Dialog"),
                onPressed: () => _showListDialog(context),
              ),
              RaisedButton(
                child: Text("Color Dialog"),
                onPressed: () => _showColorDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    cs.SimpleDialog dialog = cs.SimpleDialog(
        title: Text("Simple Dialog",
            style: TextStyle(fontSize: 19, color: Colors.black87)),
        titleIcon: Icon(
          Icons.send,
          color: Colors.black87,
        ),
        contentStyle: TextStyle(fontSize: 17, color: Colors.black54),
        content: "This is Simple Dialog" * 5,
        cornerRadius: BorderRadius.circular(16),
        checkBoxPrompt: Text(
          "This is CheckBoxPrompt text",
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        promptInitValue: true,
        autoCancel: true,
        outCanCancel: false,
        breakCancel: false,
        gravity: Gravity.center,
        backgroundColor: Colors.white,
        maskColor: Colors.black38,
        positive: "done",
        negative: "cacel",
        positiveColor: Colors.blue,
        negativeColor: Colors.red);
    DialogUtil.show(context, dialog);
  }

  void _showInputDialog(BuildContext context) {
    InputDialog dialog = InputDialog(
      title: Text("Input Dialog",
          style: TextStyle(color: Colors.black87, fontSize: 19)),
      autoCancel: true,
      hintText: "please input content",
      contentStyle: TextStyle(fontSize: 17, color: Colors.black54),
      positive: "done",
      negative: "cancel",
      showMaxLengthTip: false,
      maxLength: null,
      inputType: InputType.TEXT,
    );

    DialogUtil.show(context, dialog);
  }

  void _showListDialog(BuildContext context) {
    ListDialog dialog = ListDialog(4, (val) {
      return "Item $val";
    },
        singleSelect: true,
        isRadioButton: false,
        title: Text(
          "List Dialog",
          style: TextStyle(color: Colors.black87, fontSize: 19),
        ),
        positive: "done",
        negative: "cancel",
        autoCancel: true);
    DialogUtil.show(context, dialog);
  }

  void _showColorDialog(BuildContext context) async {
    ColorDialog dialog = ColorDialog(
        title: Text("Color Dialog",style: TextStyle(color: Colors.black87,fontSize: 19),),
        positive: "done",
        negative: "cancel",
        cornerRadius: BorderRadius.all(Radius.circular(16)),
        showAlphaSelector: true,
        initialSelection: Colors.blue[500],
        allowCustomArgb: true);

    var result = await DialogUtil.show(context, dialog);
    if (result == null) {
      print("没选择任何颜色");
    }
    Color color = result as Color;
    print("颜色： $color");
  }
}
