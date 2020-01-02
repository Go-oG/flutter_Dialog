import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_dialog/share.dart';
import 'package:material_dialog/src/core/dialog.dart';
import 'package:material_dialog/src/custom_button.dart';

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

class _DialogState extends State<CoreDialog> {
  double _maxDialogWidth;
  double _maxDialogHeight;

  @override
  void initState() {
    super.initState();
    widget.dialog.stateUpdateCallback = (value) {
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
    widget.dialog.stateUpdateCallback = null;
    widget.dialog.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dialog.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    widget.dialog.context=context;
    this._maxDialogWidth = widget.dialog.obtainDialogMaxWidth(context);
    this._maxDialogHeight = widget.dialog.obtainDialogMaxHeight(context);
    Widget contentWidget = widget.dialog.buildContentWidget(context);
    AlignmentGeometry align = Alignment.center;
    if (widget.dialog.gravity == Gravity.top) {
      align = Alignment.topCenter;
    } else if (widget.dialog.gravity == Gravity.bottom) {
      align = Alignment.bottomCenter;
    }
    
    return WillPopScope(
      onWillPop: () async {
        return widget.dialog.breakCancel;
      },
      child: Align(
        alignment: align,
        child: Container(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
                maxHeight: _maxDialogHeight,
                maxWidth: _maxDialogWidth,
                minWidth: _maxDialogWidth),
            //这里嵌套一个Material是因为某些子组件要求上级部件必须包含有Material 组件
            child: Material(
              type: MaterialType.card,
              color: widget.dialog.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: widget.dialog.cornerRadius),
              //borderRadius: BorderRadius.circular(widget.dialog.radius)
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
    //当全部控件为空时直接返回一个空白的界面
    if (widget.dialog.title == null &&
        widget.dialog.titleIcon == null &&
        contentWidget == null &&
        widget.dialog.checkBoxPrompt == null) {
      return list;
    }

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
  //TODO 后面考虑优化
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
    bool isTooLarge = ((negLength + posLength) * actionButtonTextSize + 80) >
        _maxDialogWidth * 0.8;
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

///用于感知[StatefulWidget]控件的生命周期
@protected
abstract class LiveCycleCallback {
  ///用于实现状态改变通知页面进行刷新，由[_CoreDialog]进行注入
  @protected
  ValueChanged<VoidCallback> stateUpdateCallback;

  @protected
  BuildContext context;

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
  Widget buildContentWidget(BuildContext context) ;
}
