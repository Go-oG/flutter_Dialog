import 'package:flutter/material.dart';
import 'package:material_dialog/share.dart';

class InputDialog extends BaseDialog {
  final InputBorder border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]));
  final int maxLength;
  final bool autoFocus;
  final String hintText;
  final bool isPassword;
  final EdgeInsetsGeometry textContentPadding;
  final TextInputAction inputAction;
  TextStyle hintStyle;
  TextStyle contentStyle;
  ValueChanged<String> changedCallback;
  InputBorder inputBorder;

  InputDialog(
      {this.contentStyle =
          const TextStyle(color: Color(0xFFBDBDBD), fontSize: 17),
      this.hintText = "",
      this.hintStyle = const TextStyle(color: Color(0xFF9E9E9E), fontSize: 17),
      this.maxLength,
      this.autoFocus = false,
      this.isPassword = false,
      this.textContentPadding =
          const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
      this.inputAction = TextInputAction.none,
      this.inputBorder,
      this.changedCallback,
      bool reverseActionButton = false,
      Text title,
      Widget titleIcon,
      Text checkBoxPrompt,
      bool promptInitValue,
      String positive,
      String negative,
      Color positiveColor,
      Color negativeColor,
      Color backgroundColor,
      Color maskColor,
      BorderRadiusGeometry cornerRadius,
      RouteTransitionsBuilder animation,
      Duration transitionDuration,
      bool autoCancel = true,
      bool breakCancel = true,
      bool outCanCancel = true,
      ActionListener actionListener,
      ValueChanged<bool> checkBoxPromptCallback})
      : super(
            title: title,
            titleIcon: titleIcon,
            checkBoxPrompt: checkBoxPrompt,
            promptInitValue: promptInitValue,
            positive: positive,
            negative: negative,
            reverseActionButton: reverseActionButton,
            positiveColor: positiveColor,
            negativeColor: negativeColor,
            backgroundColor: backgroundColor,
            maskColor: maskColor,
            animation: animation,
            transitionDuration: transitionDuration,
            cornerRadius: cornerRadius,
            autoCancel: autoCancel,
            breakCancel: breakCancel,
            outCanCancel: outCanCancel,
            actionListener: actionListener,
            checkBoxPromptCallback: checkBoxPromptCallback);

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (_controller == null) {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }

  @override
  dynamic operationResult(bool isPositiveButton) {
    if (_controller != null) {
      return null;
    }
    return _controller.text;
  }

  @override
  Widget buildContentWidget(BuildContext context) {
    if (inputBorder == null) {
      inputBorder = border;
    }
    TextField field = TextField(
      controller: _controller,
      style: contentStyle,
      maxLines: null,
      maxLength: maxLength,
      autofocus: autoFocus,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      textAlignVertical: TextAlignVertical.center,
      onChanged: changedCallback,
      keyboardType: TextInputType.multiline,
      obscureText: isPassword,
      textInputAction: inputAction,
      decoration: InputDecoration(
          contentPadding: textContentPadding,
          hintText: hintText,
          hintStyle: hintStyle,
          border: border,
          disabledBorder: border,
          focusedBorder: border,
          enabledBorder: border),
    );
    return Container(
      constraints: BoxConstraints(maxHeight: 144),
      child: field,
    );
  }
}
