import 'package:flutter/material.dart';
import 'package:material_dialog/shelf.dart';
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
    DialogUtil.show(
        context,
        cs.SimpleDialog(
            title: Text("Simple Dialog"),
            content: "This is Simple Dialog" * 5,
            autoCancel: true,
            positive: "确定",
            negative: "取消"));
  }

  void _showInputDialog(BuildContext context) {
    DialogUtil.show(
        context,
        InputDialog(
            title: Text("Input Dialog"),
            autoCancel: true,
            hintText: "请输入文字",
            positive: "确定",
            negative: "取消"));
  }

  void _showListDialog(BuildContext context) {
    DialogUtil.show(
        context,
        ListDialog(20, (val) {
          return "Item $val";
        }));
  }

  void _showColorDialog(BuildContext context) {
    DialogUtil.show(
        context,
        ColorDialog(
            title: Text("Color Dialog"),
            positive: "确定",
            negative: "取消",
            showAlphaSelector: false,
            allowCustomArgb: true));
  }
}
