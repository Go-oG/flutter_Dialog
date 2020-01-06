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
            style: TextStyle(fontSize: 17, color: Colors.black87)),
        titleIcon: Icon(
          Icons.send,
          color: Colors.black87,
        ),
        contentStyle: TextStyle(fontSize: 15, color: Colors.black54),
        content: "This is Simple Dialog" * 5,
        autoCancel: true,
        positive: "确定",
        negative: "取消");

    DialogUtil.show(context, dialog);
  }

  void _showInputDialog(BuildContext context) {
    InputDialog dialog = InputDialog(
      title: Text("Input Dialog"),
      autoCancel: true,
      hintText: "请输入文字",
      positive: "确定",
      negative: "取消",
      showMaxLengthTip: true,
      maxLength: null,
      inputType: InputType.EMAIL,
    );

    DialogUtil.show(context, dialog);
  }

  void _showListDialog(BuildContext context) {
    ListDialog dialog = ListDialog(20, (val) {
      return "Item $val";
    },
        singleSelect: true,
        isRadioButton: true,
        title: Text(
          "List Dialog",
          style: TextStyle(color: Colors.black87, fontSize: 17),
        ));

    DialogUtil.show(context, dialog);
  }

  void _showColorDialog(BuildContext context) async {
    ColorDialog dialog = ColorDialog(
        title: Text("Color Dialog"),
        positive: "确定",
        negative: "取消",
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
