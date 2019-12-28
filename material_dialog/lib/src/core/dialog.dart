import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils.dart';

//顶层常量 Material Design设计
//https://material.io/components/dialogs/#full-screen-dialog

//整个Dialog的最大宽度
final double dialogMaxWidth = 300;

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

class _DialogState extends State<CoreDialog> {
  //外边距
  final EdgeInsetsGeometry outPadding = EdgeInsets.only(left: 24, right: 24);

  @override
  void initState() {
    super.initState();
    widget.dialog._stateUpdateCallback = (value) {
      setState(value);
    };
    widget.dialog.initState();
  }

  @override
  void didUpdateWidget(CoreDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.dialog.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.dialog.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.dialog.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    widget.dialog.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dialog.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = widget.dialog.buildContentWidget(context);
    //全部控件为空 直接返回一个空白的界面
    Size size = MediaQuery.of(context).size;
    double maxHeight = (size.height - MediaQuery.of(context).padding.top) * 0.8;
    if (widget.dialog.title == null &&
        contentWidget == null &&
        widget.dialog.checkBoxPrompt == null) {
      return WillPopScope(
        onWillPop: () async {
          return widget.dialog.breakCancel;
        },
        child: Center(
            child: Container(
          constraints:
              BoxConstraints(maxHeight: maxHeight, maxWidth: dialogMaxWidth),
          decoration: ShapeDecoration(
              color: widget.dialog.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.dialog.radius))),
        )),
      );
    }

    //只会拦截返回键
    return WillPopScope(
      onWillPop: () async {
        return widget.dialog.breakCancel;
      },
      child: Center(
        child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: dialogMaxWidth),
            //这里嵌套一个Card是因为某些子组件要求上级部件必须包含有Material 组件
            child: Card(
              color: widget.dialog.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.dialog.radius)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildWidgetList(context, contentWidget),
              ),
            )),
      ),
    );
  }

  //构建控件列表
  List<Widget> _buildWidgetList(BuildContext context, Widget contentWidget) {
    List<Widget> list = [];

    //构建Title
    Widget title = _buildTitle(context);
    if (title != null) {
      list.add(title);
    }

    //  构建ContentWidget并解决像素越界问题
    if (contentWidget != null) {
      EdgeInsetsGeometry cp = widget.dialog.obtainContentPadding();
      if (cp == null) {
        cp = EdgeInsets.only(
            left: leftMargin, right: rightMargin, top: titleWithContentMargin);
      }
      list.add(Flexible(
          child: Padding(
            padding: cp,
            child: contentWidget,
          ),
          fit: FlexFit.loose));
    }

    //   构建checkBoxPrompt
    Widget checkBoxPromptWidget = _buildCheckBoxPrompt(context);
    if (checkBoxPromptWidget != null) {
      list.add(Padding(
          padding: EdgeInsets.only(
              left: leftMargin,
              right: rightMargin,
              top: contentWithCheckBoxMargin),
          child: checkBoxPromptWidget));
    }

    //构建底部ActionButton
    List<Widget> actionButtonList = _buildActionWidget();
    if (actionButtonList != null && actionButtonList.isNotEmpty) {
      list.add(Padding(
          padding: EdgeInsets.only(
              top: contentWithActionButtonMargin + minBottomMargin)));
      list.addAll(actionButtonList);
      list.add(Padding(padding: EdgeInsets.only(bottom: minBottomMargin)));
    }

    return list;
  }

  //Title
  Widget _buildTitle(BuildContext context) {
    EdgeInsetsGeometry padding = EdgeInsets.only(
        top: titleTopMargin, left: leftMargin, right: rightMargin);
    List<Widget> widgetList = [];
    if (widget.dialog.titleIcon != null) {
      widgetList.add(widget.dialog.titleIcon);
    }
    if (widget.dialog.title != null) {
      if (widget.dialog.titleIcon != null) {
        widgetList.add(
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: widget.dialog.title,
            ),
          ),
        );
      } else {
        widgetList.add(Expanded(child: widget.dialog.title));
      }
    }

    return Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgetList,
        ));
  }

  //checkBoxPrompt
  Widget _buildCheckBoxPrompt(BuildContext context) {
    if (widget.dialog.checkBoxPrompt == null) {
      return null;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StatefulBuilder(
          builder: (context, stateSetter) {
            return Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                autofocus: false,
                value: widget.dialog.promptInitValue,
                onChanged: (val) {
                  widget.dialog.promptInitValue = val;
                  if (widget.dialog.checkBoxPromptCallback != null) {
                    widget.dialog.checkBoxPromptCallback(val);
                  }
                  setState(() {});
                });
          },
        ),
        widget.dialog.checkBoxPrompt
      ],
    );
  }

  //构建底部的ActionButton
  List<Widget> _buildActionWidget() {
    bool posIsNull = StringUtil.isEmpty(widget.dialog.positive);
    bool negIsNull = StringUtil.isEmpty(widget.dialog.negative);
    if (posIsNull && negIsNull) {
      return [Padding(padding: EdgeInsets.only(bottom: minBottomMargin))];
    }
    EdgeInsetsGeometry buttonContentPadding =
        EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16);
    int posLength = posIsNull ? 0 : widget.dialog.positive.length;
    int negLength = negIsNull ? 0 : widget.dialog.negative.length;
    bool isTooLarge =
        ((negLength + posLength) * actionButtonTextSize + 80) > dialogMaxWidth;
    List<Widget> widgetList = [];
    bool reversButton = widget.dialog.reverseActionButton == null
        ? false
        : widget.dialog.reverseActionButton;
    if (isTooLarge) {
      if (!negIsNull && !posIsNull) {
        if (reversButton) {
          widgetList.add(Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildPositiveButton(buttonContentPadding),
            ),
          ));
          widgetList.add(Padding(padding: EdgeInsets.only(top: 12, right: 8)));
          widgetList.add(Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildNegativeButton(buttonContentPadding),
            ),
          ));
        } else {
          widgetList.add(Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildNegativeButton(buttonContentPadding),
            ),
          ));
          widgetList.add(Padding(padding: EdgeInsets.only(top: 12, right: 8)));
          widgetList.add(Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildPositiveButton(buttonContentPadding),
            ),
          ));
        }
      } else if (!negIsNull && posIsNull) {
        widgetList.add(Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: _buildPositiveButton(buttonContentPadding),
          ),
        ));
      } else if (negIsNull && !posIsNull) {
        widgetList.add(Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: _buildNegativeButton(buttonContentPadding),
          ),
        ));
      }
    } else {
      List<Widget> rowList = [];
      if (!negIsNull && !posIsNull) {
        if (reversButton) {
          rowList.add(_buildPositiveButton(buttonContentPadding));
          rowList.add(
              Padding(padding: EdgeInsets.only(left: actionButtonHMargin)));
          rowList.add(_buildNegativeButton(buttonContentPadding));
        } else {
          rowList.add(_buildNegativeButton(buttonContentPadding));
          rowList.add(
              Padding(padding: EdgeInsets.only(left: actionButtonHMargin)));
          rowList.add(_buildPositiveButton(buttonContentPadding));
        }
      } else if (!posIsNull && negIsNull) {
        rowList.add(_buildPositiveButton(buttonContentPadding));
      } else if (posIsNull && !negIsNull) {
        rowList.add(_buildNegativeButton(buttonContentPadding));
      }
      widgetList.add(Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: actionButtonHMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: rowList,
          ),
        ),
      ));
    }
    return widgetList;
  }

  Widget _buildNegativeButton(EdgeInsetsGeometry buttonContentPadding) {
    return CustomButton(
      contentPadding: buttonContentPadding,
      color: Colors.transparent,
      text: Text(
        widget.dialog.negative,
        style: TextStyle(fontSize: actionButtonTextSize),
      ),
      onPressed: () {
        if (widget.dialog.actionListener != null) {
          widget.dialog.actionListener(false, widget.dialog.promptInitValue);
        }
        if (widget.dialog.autoCancel) {
          dynamic operationResult = widget.dialog.operationResult(false);
          Navigator.of(context).pop(operationResult);
        }
      },
    );
  }

  Widget _buildPositiveButton(EdgeInsetsGeometry buttonContentPadding) {
    return CustomButton(
      contentPadding: buttonContentPadding,
      onPressed: () {
        if (widget.dialog.actionListener != null) {
          widget.dialog.actionListener(true, widget.dialog.promptInitValue);
        }
        if (widget.dialog.autoCancel) {
          dynamic operationResult = widget.dialog.operationResult(true);
          Navigator.of(context).pop(operationResult);
        }
      },
      text: Text(widget.dialog.positive,
          style: TextStyle(
              fontSize: actionButtonTextSize,
              color: widget.dialog.positiveColor)),
    );
  }
}

///核心的Dialog,通过持有[BaseDialog]进行内容视图的更新和生命周期的回调
@protected
class CoreDialog<T extends BaseDialog> extends StatefulWidget {
  @protected
  final T dialog;

  CoreDialog(this.dialog);

  @override
  State createState() {
    return _DialogState();
  }
}

///基础的Dialog 其拥有StatefulWidget控件的生命周期
///同时也有对应setState函数和构建选项
///但其并不是[StatefulWidget]控件的子类，仅仅只是一个普通类
///另外 如果用户想实现自定义中心内容,可以继承该类并实现相关方法
abstract class BaseDialog extends _LiveCycleCallback {
  final Text title;
  final Widget titleIcon; //Title对应的Icon
  final String positive;
  final String negative;

  //复选框提示(在Content之下 actionButton按钮之上)
  final Text checkBoxPrompt;
  final ValueChanged<bool> checkBoxPromptCallback;

  //Dialog显示动画
  final RouteTransitionsBuilder transitionBuilder;

  //两个按钮对应的回调
  final ActionListener actionListener;

  //是否反转negativeButton和PositiveButton的按钮的顺序
  //默认为negative在前面
  final bool reverseActionButton;

  ///用于实现状态改变通知页面进行刷新，由[_CoreDialog]进行注入
  ValueChanged<VoidCallback> _stateUpdateCallback;

  //dialog圆角
  double radius;

  Color negativeColor;
  Color positiveColor;

  //背景颜色
  Color backgroundColor;

  //遮罩层颜色
  Color maskColor;

  //是否自动退出
  bool autoCancel;

  //按 返回键能否退出
  bool breakCancel;

  //能否点击外部退出
  bool outCanCancel;

  //动画时间
  Duration transitionDuration;

  bool promptInitValue;

  BaseDialog({
    this.title,
    this.titleIcon,
    this.checkBoxPrompt,
    this.positive,
    this.negative,
    this.reverseActionButton = false,
    this.transitionBuilder,
    this.actionListener,
    this.checkBoxPromptCallback,
    double cornerRadius = 0, //卡片的圆角
    bool promptInitValue = false,
    bool autoCancel,
    bool breakCancel,
    bool outCanCancel,
    Color positiveColor,
    Color negativeColor,
    Color backgroundColor,
    Color maskColor,
    Duration transitionDuration,
  }) {
    this.radius = cornerRadius == null ? 0 : cornerRadius;
    this.autoCancel = autoCancel == null ? true : autoCancel;
    this.breakCancel = breakCancel == null ? true : breakCancel;
    this.outCanCancel = outCanCancel == null ? true : outCanCancel;
    this.promptInitValue = promptInitValue == null ? false : promptInitValue;

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

  //构建一个Material design 设计的动画
  Widget buildMaterialDialogTransitions(
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
  @protected
  EdgeInsetsGeometry obtainContentPadding() {
    return null;
  }

  void setState({VoidCallback fn}) {
    if (_stateUpdateCallback != null) {
      if (fn != null) {
        _stateUpdateCallback(fn);
      } else {
        _stateUpdateCallback(() {});
      }
    } else {
      print("尝试更新状态，但 StateUpdateCallback 为空");
    }
  }

  ///子类通过复写该方法实现操作数据的传递
  ///该方法只会在 用户主动点击积极/消极按钮且autoCancel=true 时才会被调用
  ///参数 isPositionButton 标识用户点击的是哪个按钮，从而实现不同按钮返回不同的数据
  ///
  dynamic operationResult(bool isPositiveButton) {
    return null;
  }
}

//<editor-folder desc="用于感知[ma.StatefulWidget]控件的生命周期">

abstract class _LiveCycleCallback {
  //在构建前调用
  @protected
  @mustCallSuper
  void initState() {}

  @protected
  @mustCallSuper
  void didUpdateWidget(covariant Widget oldWidget) {}

  @protected
  @mustCallSuper
  void reassemble() {}

  @protected
  @mustCallSuper
  void deactivate() {}

  @protected
  @mustCallSuper
  void dispose() {}

  @protected
  @mustCallSuper
  void didChangeDependencies() {}

  ///构建中心内容Widget可以为空
  Widget buildContentWidget(BuildContext context);
}

//</editor-folder>

class CustomButton extends StatelessWidget {
  final EdgeInsetsGeometry contentPadding;
  final Widget text;
  final VoidCallback onPressed;
  final Color color;

  CustomButton(
      {this.color = Colors.transparent,
      this.text,
      this.contentPadding = EdgeInsets.zero,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        color: color,
        child: Padding(padding: contentPadding, child: text),
      ),
    );
  }
}
