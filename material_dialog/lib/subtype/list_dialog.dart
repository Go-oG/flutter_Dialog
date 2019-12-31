import 'package:flutter/material.dart';
import 'package:material_dialog/share.dart';

typedef ItemBuilder = String Function(int index);

class _ListItemBean {
  final String itemTitle;
  bool isCheck;

  _ListItemBean(this.itemTitle, {this.isCheck = false});
}

///带CheckBox的列表Dialog
///如果有选中的其返回值为: 被选中Item的索引 否则为空
class ListDialog extends BaseDialog {
  List<_ListItemBean> _list = [];
  final int itemCount;
  final ItemBuilder itemBuilder;
  final TextStyle itemStyle;
  final Color activeColor;
  final Color checkColor;
  final Color focusColor;

  //checkBox是圆形还是方形
  final bool isRadioButton;

  //是单选还是多选
  final singleSelect;

  ListDialog(this.itemCount, this.itemBuilder,
      {this.itemStyle = const TextStyle(color: Colors.black45, fontSize: 17),
      this.activeColor = Colors.grey,
      this.checkColor = Colors.white,
      this.focusColor = Colors.white,
      this.isRadioButton = false,
      this.singleSelect = false,
      Text title,
      Widget titleIcon,
      Text checkBoxPrompt,
      bool promptInitValue = false,
      String positive,
      String negative,
      bool reverseActionButton = false,
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
    if (itemBuilder != null && itemCount > 0) {
      for (int i = 0; i < itemCount; i++) {
        _list.add(_ListItemBean(itemBuilder(i), isCheck: false));
      }
    }
  }

  @override
  dynamic operationResult(bool isPositiveButton) {
    if (isPositiveButton) {
      if (_list == null || _list.isEmpty) {
        return null;
      }
      List<int> resultList = [];
      for (int i = 0; i < _list.length; i++) {
        if (_list[i].isCheck) {
          resultList.add(i);
        }
      }
      return resultList;
    } else {
      return null;
    }
  }

  @override
  Widget buildContentWidget(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _list.length,
      padding: EdgeInsets.only(top: 0, bottom: 8),
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Widget box;
    if (isRadioButton) {
      box = Radio<bool>(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          autofocus: false,
          groupValue: true,
          focusColor: focusColor,
          activeColor: activeColor,
          value: _list[index].isCheck,
          onChanged: (val) {
            print("回调");
            _refreshData(val, index, false);
          });
    } else {
      box = Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          autofocus: false,
          focusColor: focusColor,
          activeColor: activeColor,
          checkColor: checkColor,
          value: _list[index].isCheck,
          onChanged: (val) {
            _refreshData(val, index, true);
          });
    }

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          box,
          //避免越界
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: listItemContentMargin),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(_list[index].itemTitle,
                    textAlign: TextAlign.center, maxLines: 1, style: itemStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData(bool val, int index, bool isCheckBox) {
    if (!isCheckBox) {
      val = !val;
    }
    if (singleSelect) {
      for (int i = 0; i < _list.length; i++) {
        if (i == index) {
          _list[i].isCheck = val;
        } else {
          _list[i].isCheck = false;
        }
      }
    } else {
      _list[index].isCheck = val;
    }
    setState();
  }
}
