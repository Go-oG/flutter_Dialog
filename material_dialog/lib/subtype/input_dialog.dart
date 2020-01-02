import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialog/share.dart';

class InputDialog extends BaseDialog {
  InputBorder border;
  final int maxLength;

  //是否显示输入字数
  final bool showMaxLengthTip;
  final bool autoFocus;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle contentStyle;
  final Color borderColor;
  final InputType inputType;

  final EdgeInsetsGeometry textContentPadding;
  final ValueChanged<String> onChanged;

  InputDialog(
      {this.contentStyle =
          const TextStyle(color: Color(0xFFBDBDBD), fontSize: 17),
      this.hintText = "",
      this.hintStyle = const TextStyle(color: Color(0xFF9E9E9E), fontSize: 17),
      this.maxLength,
      this.showMaxLengthTip = false,
      this.autoFocus = false,
      this.textContentPadding =
          const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
      this.borderColor = const Color(0xFFBDBDBD),
      this.inputType = InputType.TEXT,
      this.onChanged,
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
            checkBoxPromptCallback: checkBoxPromptCallback) {
    this.border =
        UnderlineInputBorder(borderSide: BorderSide(color: borderColor));
  }

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
    return Container(
      constraints: BoxConstraints(maxHeight: 144),
      child: _buildTextWidget(),
    );
  }

  //构建当输入类型为TEXT时的文本控件
  Widget _buildTextWidget() {
    List<TextInputFormatter> list = [];
    if (maxLength != null && !showMaxLengthTip) {
      list.add(LengthLimitingTextInputFormatter(maxLength));
    }
    if (inputType == InputType.PHONE_NUMBER) {
      list.add(WhitelistingTextInputFormatter.digitsOnly);
      list.add(BlacklistingTextInputFormatter.singleLineFormatter);
    } else if (inputType == InputType.EMAIL) {
      String regex = r'[a-zA-Z0-9@.]+';
      list.add(WhitelistingTextInputFormatter(RegExp(regex)));
      list.add(BlacklistingTextInputFormatter.singleLineFormatter);
    }

    InputDecoration inputDecoration = InputDecoration(
        contentPadding: textContentPadding,
        hintText: hintText,
        hintStyle: hintStyle,
        border: border,
        disabledBorder: border,
        focusedBorder: border,
        enabledBorder: border);

    int maxLength2;
    int maxLine2;
    
    if(maxLength!=null){
      maxLength2=maxLength;
    }else{
      maxLength2=TextField.noMaxLength;
    }
    
    if(inputType==InputType.PASSWORD){
      maxLine2=1;
    }else{
      maxLine2=null;
    }
    
    return TextField(
        controller: _controller,
        style: contentStyle,
        maxLines: maxLine2,
        maxLength:maxLength2,
        autofocus: autoFocus,
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChanged,
        obscureText: inputType == InputType.PASSWORD ? true : false,
        inputFormatters: list,
        decoration: inputDecoration);
  }
  
}


class _EmailFormat extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text=newValue.text;
    int i=0;
    for(;i<text.length;i++){
      
      
    }
    
    
    return null;
  }
  
}


//文本框的输入类型
enum InputType {
  TEXT,
  EMAIL,
  PHONE_NUMBER,
  PASSWORD,
}
