import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'core_dialog.dart';

//顶层常量 Material Design设计
//https://material.io/components/dialogs/#full-screen-dialog

//整个Dialog的最大宽度
const double _dialogMaxWidth = 320;

//整个Dialog内容的左右边距
const double leftMargin = 24;
const double rightMargin = 24;
const double titleTopMargin = 20; //title距顶部的间距
const double titleWithContentMargin = 20; //title和Content之间的间隔
const double listItemContentMargin = 32; //在ListDialog中 item中 checkBox和Text的间隔
const double contentWithActionButtonMargin = 20; //中间内容和ActionButton的间隔
const double contentWithCheckBoxMargin = 8; //中间内容和CheckBox的间隔
const double titleTextSize = 20; //title 字体大小
const double contentTextSize = 16; //中心内容 文字的大小
const double actionButtonTextSize = 14; //ActionButton 文字大小
const double actionButtonHeight = 36; //ActionButton按钮的高度
const double actionButtonHMargin = 8; //ActionButton之间水平间隔
const double actionButtonVMargin = 12; //ActionButton之间的竖直间隔
const double minBottomMargin = 8;

///用于Dialog中ActionButton的回调
typedef ActionListener = void Function(
    bool isPositiveClick, bool checkBoxIsSelect);

//用于控制其显示位置
enum Gravity { top, center, bottom }

///基础的Dialog 其拥有StatefulWidget控件的生命周期
///同时也有对应setState函数和构建选项
///但其并不是[StatefulWidget]控件的子类，仅仅只是一个普通类
///另外 如果用户想实现自定义中心内容,可以继承该类并实现相关方法
abstract class BaseDialog extends LiveCycleCallback {
  final Text title;
  final Widget titleIcon; //Title对应的Icon
  final String positive;
  final String negative;

  //Dialog在屏幕上的位置(永远都不为空)
  Gravity gravity;

  //复选框提示(在Content之下 actionButton按钮之上)
  final Text checkBoxPrompt;
  final ValueChanged<bool> checkBoxPromptCallback;

  //Dialog动画构建者，可以更改该参数实现不同的动画效果
  final RouteTransitionsBuilder animation;

  //两个按钮对应的回调
  final ActionListener actionListener;

  //是否反转negativeButton和PositiveButton的按钮的顺序
  //默认为negative在前面
  final bool reverseActionButton;

  //dialog圆角
  BorderRadiusGeometry cornerRadius;

  //ActionButton Color
  Color negativeColor;
  Color positiveColor;

  //背景颜色
  Color backgroundColor;

  //遮罩层颜色
  Color maskColor;

  //是否自动退出
  bool autoCancel;

  //按 返回键能否退出 true 能 false 不能
  bool breakCancel;

  //能否点击外部退出
  bool outCanCancel;

  //动画时间
  Duration transitionDuration;

  //底部CheckBox的初始值
  bool promptInitValue;

  BaseDialog({
    this.title,
    this.titleIcon,
    this.checkBoxPrompt,
    this.positive,
    this.negative,
    this.reverseActionButton = false,
    this.actionListener,
    this.checkBoxPromptCallback,
    this.animation = buildDialogTransitions,
    BorderRadiusGeometry cornerRadius, //卡片的圆角
    bool promptInitValue = false,
    bool autoCancel,
    bool breakCancel,
    bool outCanCancel,
    Color positiveColor,
    Color negativeColor,
    Color backgroundColor,
    Color maskColor,
    Gravity gravity,
    Duration transitionDuration,
  }) {
    this.cornerRadius =
        cornerRadius == null ? BorderRadius.circular(0) : cornerRadius;
    this.autoCancel = autoCancel == null ? true : autoCancel;
    this.breakCancel = breakCancel == null ? true : breakCancel;
    this.outCanCancel = outCanCancel == null ? true : outCanCancel;
    this.promptInitValue = promptInitValue == null ? false : promptInitValue;
    this.gravity = gravity == null ? Gravity.center : gravity;
    this.positiveColor =
        positiveColor == null ? Colors.blue[600] : positiveColor;
    this.negativeColor = negativeColor == null ? Colors.grey : negativeColor;
    this.backgroundColor =
        backgroundColor == null ? Colors.white : backgroundColor;
    this.maskColor = maskColor == null ? Colors.black54 : maskColor;
    this.transitionDuration = transitionDuration == null
        ? Duration(milliseconds: 150)
        : transitionDuration;
  }

  ///构建Dialog弹出动画
  static Widget buildDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  //返回中间内容的间隔如果返回值为空则使用原始值
  EdgeInsetsGeometry obtainContentPadding() {
    return null;
  }

  @mustCallSuper
  void setState({VoidCallback fn}) {
    if (stateUpdateCallback != null) {
      if (fn != null) {
        stateUpdateCallback(fn);
      } else {
        stateUpdateCallback(() {});
      }
    } else {
      print("尝试更新状态，但 StateUpdateCallback 为空");
    }
  }

  ///返回dialog的最大高度,该方法决定了Dialog整体的高度
  ///默认为（屏幕高度-状态栏高度）*0.8
  double obtainDialogMaxHeight(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    Size size = data.size;
    return (size.height - data.padding.top)*0.8;
  }

  ///返回dialog的最大宽度 该方法决定了Dialog整体的宽度
  double obtainDialogMaxWidth(BuildContext context) {
    if (gravity != null && gravity == Gravity.bottom) {
      Size size = MediaQuery.of(context).size;
      return size.width;
    }
    return _dialogMaxWidth;
  }

  ///该方法返回中间内容的最大宽度，已经去除掉了水平padding的影响
  ///该方法决定的是Dialog中心内容的宽度
  double obtainContentMaxWidth(BuildContext context) {
    EdgeInsetsGeometry padding = obtainContentPadding();
    if (padding == null) {
      padding = EdgeInsets.only(left: leftMargin, right: rightMargin);
    }
    return obtainDialogMaxWidth(context) - padding.horizontal;
  }

  ///子类通过复写该方法实现操作数据的传递
  ///该方法只会在 用户主动点击积极/消极按钮且autoCancel=true 时才会被调用
  ///参数 isPositionButton 标识用户点击的是哪个按钮，从而实现不同按钮返回不同的数据
  dynamic operationResult(bool isPositiveButton) {
    return null;
  }

  //隐藏软键盘
  void dismissKeyboard(){
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
