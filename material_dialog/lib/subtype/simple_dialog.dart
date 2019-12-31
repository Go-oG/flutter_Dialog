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
}
