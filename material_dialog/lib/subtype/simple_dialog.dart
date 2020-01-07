import 'package:flutter/material.dart';
import 'package:material_dialog/share.dart';

class SimpleDialog extends BaseDialog {
  final String content;
  TextStyle contentStyle;

  SimpleDialog(
      {this.content,
      this.contentStyle =
          const TextStyle(color: Color(0xFFBDBDBD), fontSize: 17),
      Text title,
      Widget titleIcon,
      Text checkBoxPrompt,
      bool promptInitValue = false,
      String positive,
      String negative,
      bool reverseActionButton,
      Color positiveColor,
      Color negativeColor,
      Color backgroundColor,
      Color maskColor,
      Gravity gravity,
      RouteTransitionsBuilder animation,
      Duration transitionDuration,
      BorderRadiusGeometry cornerRadius,
      bool autoCancel = true,
      bool breakCancel = true,
      bool outCanCancel = true,
      ActionListener actionListener,
      ValueChanged<bool> checkBoxPromptCallback})
      : super(
            title: title,
            titleIcon: titleIcon,
            checkBoxPrompt: checkBoxPrompt,
            positive: positive,
            negative: negative,
            gravity: gravity,
            reverseActionButton: reverseActionButton,
            animation: animation,
            actionListener: actionListener,
            checkBoxPromptCallback: checkBoxPromptCallback,
            cornerRadius: cornerRadius,
            promptInitValue: promptInitValue,
            positiveColor: positiveColor,
            negativeColor: negativeColor,
            backgroundColor: backgroundColor,
            maskColor: maskColor,
            transitionDuration: transitionDuration,
            autoCancel: autoCancel,
            breakCancel: breakCancel,
            outCanCancel: outCanCancel);

  @override
  Widget buildContentWidget(BuildContext context) {
    if (!StringUtil.isEmpty(content)) {
      return Text(content,
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
          style: contentStyle);
    }
    return null;
  }

  SimpleDialog.of(this.content,
      {String title,
      String positive,
      String negative,
      ActionListener actionListener}) {
    SimpleDialog(
        title:
            Text(title, style: TextStyle(color: Colors.black87, fontSize: 19)),
        content: content,
        contentStyle: TextStyle(color: Colors.black54, fontSize: 17),
        gravity: Gravity.center,
        backgroundColor: Colors.white,
        maskColor: Colors.black38,
        cornerRadius: BorderRadius.circular(16),
        autoCancel: true,
        outCanCancel: true,
        breakCancel: true,
        positive: positive,
        negative: negative,
        actionListener: actionListener);
  }
}
