import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialog/shelf.dart';

class ColorDialog extends BaseDialog {
  List<Color> colors;
  List<List<Color>> subColors;
  final Color initialSelection;
  final bool allowCustomArgb;
  final bool showAlphaSelector;
  final int columnCount;

  ColorDialog(
      {this.columnCount = 4,
      this.initialSelection,
      this.allowCustomArgb = false,
      this.showAlphaSelector = false,
      List<Color> colors,
      List<List<Color>> subColors,
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
      RouteTransitionsBuilder transitionBuilder,
      Duration transitionDuration,
      double cornerRadius,
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
            transitionBuilder: transitionBuilder,
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
            outCanCancel: outCanCancel) {
    if (colors == null || colors.isEmpty) {
      this.colors = MaterialColors.colors;
      this.subColors = MaterialColors.subColors;
    } else {
      this.colors = colors;
      if (subColors != null &&
          subColors.isNotEmpty &&
          subColors.length != colors.length) {
        throw ArgumentError(
            "当 [colors]不为空且[subColors]也不为空时,[colors.length]必须等于[subColors.length]");
      }
      this.subColors = subColors;
    }
  }

  //当前选中的主要颜色的序列
  int mainSelectIndex = -1;

  //当前选中的子颜色的序列
  int subSelectIndex = -1;

  ///[allowCustomArgb]==true时 用于记录ViewPage当前的界面索引
  int viewPageIndex = -1;

  //当前自定义的颜色(该颜色只有当当前界面是自定义颜色界面是才会有用)
  Color customArgbColor = Colors.black;

  //自定义颜色的输入栏
  TextEditingController _controller;

  //当前显示的界面 只有当其有subColor时才会有用 只能在0和1之间
  int showStackIndex = 0;

  @override
  void initState() {
    super.initState();
    if (customArgbColor == null) {
      customArgbColor = Colors.black;
    }
    if (_controller == null) {
      _controller = TextEditingController(text: _formatColorToString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }

  ///返回被选中的颜色,选取规则如下:
  ///如果[allowCustomArgb]为true 且当前页面为自定义颜色界面 则返回自定义颜色
  ///否则其它情况下会返回主界面选择的颜色
  @override
  dynamic operationResult(bool isPositiveButton) {
    if (allowCustomArgb && viewPageIndex == 1) {
      if (showAlphaSelector) {
        return Color.fromARGB(customArgbColor.alpha, customArgbColor.red,
            customArgbColor.green, customArgbColor.blue);
      } else {
        return Color.fromARGB(255, customArgbColor.red, customArgbColor.green,
            customArgbColor.blue);
      }
    }
    if (colors == null ||
        colors.isEmpty ||
        mainSelectIndex < 0 ||
        mainSelectIndex >= colors.length) {
      return null;
    }
    Color color = colors[mainSelectIndex];
    if (subColors == null ||
        subColors.isEmpty ||
        mainSelectIndex < 0 ||
        mainSelectIndex >= subColors.length) {
      return color;
    }
    List<Color> subList = subColors[mainSelectIndex];
    if (subList == null ||
        subList.isEmpty ||
        subList.length <= subSelectIndex ||
        subSelectIndex < 0) {
      return color;
    }
    return subList[subSelectIndex];
  }

  @override
  Widget buildContentWidget(BuildContext context) {
    if (!allowCustomArgb) {
      viewPageIndex = -1;
      return Padding(
          padding: EdgeInsets.only(top: 24, left: 8, right: 8),
          child: _buildMainPage());
    }

    return PageView(
      onPageChanged: (val) {
        viewPageIndex = val;
      },
      children: <Widget>[_buildMainPage(), _buildArgbPage()],
    );
  }

  //构建完整的页面
  Widget _buildMainPage() {
    if (!_hasChildColor(mainSelectIndex)) {
      return _buildNormalPage(colors, columnCount);
    }
    return IndexedStack(
      index: showStackIndex,
      children: <Widget>[
        _buildNormalPage(colors, columnCount),
        _buildSubPage(subColors[mainSelectIndex], columnCount)
      ],
    );
  }

  //主颜色的主界面
  Widget _buildNormalPage(List<Color> colorList, int columnCount) {
    if (colorList == null) {
      colorList = [];
    }
    if (columnCount <= 0) {
      columnCount = 4;
    }
    return GridView.builder(
        itemCount: colorList.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1),
        itemBuilder: (ctx, index) {
          Color curColor = colorList[index];
          Color borderColor;
          if (curColor == Colors.black) {
            borderColor = Colors.grey;
          } else if (curColor == Colors.white) {
            borderColor = Colors.grey;
          } else {
            borderColor = Colors.black54;
          }

          return InkWell(
            onTap: () {
              _selectMainColor(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.50),
                color: curColor,
                shape: BoxShape.circle,
              ),
              child: (index == mainSelectIndex)
                  ? Center(
                      child: Icon(
                        Icons.done,
                        color: curColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                        size: 48,
                      ),
                    )
                  : null,
            ),
          );
        });
  }

  //次要颜色的界面
  Widget _buildSubPage(List<Color> colorList, int columnCount) {
    if (colorList == null) {
      colorList = [];
    }
    if (columnCount <= 0) {
      columnCount = 4;
    }
    //   subSelectIndex = _findColorIndexInSubColor();
    return GridView.builder(
        shrinkWrap: true,
        itemCount: colorList.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1),
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                subSelectIndex = -1;
                showStackIndex = 0;
                setState();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      Icon(Icons.arrow_back, color: Colors.black54, size: 40),
                ),
              ),
            );
          }

          Color curColor = colorList[index - 1];
          Color borderColor;
          if (curColor == Colors.black) {
            borderColor = Colors.white;
          } else {
            borderColor = Colors.black;
          }
          return InkWell(
            onTap: () {
              subSelectIndex = index - 1;
              setState();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                color: curColor,
                shape: BoxShape.circle,
              ),
              child: ((index - 1) == subSelectIndex)
                  ? Center(
                      child: Icon(
                      Icons.done,
                      color: curColor == Colors.white
                          ? Colors.black
                          : Colors.white,
                      size: 48,
                    ))
                  : null,
            ),
          );
        });
  }

  //自定义颜色界面
  Widget _buildArgbPage() {
    InputBorder inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white));
    double topMargin = 12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          color: customArgbColor,
          constraints: BoxConstraints(
              maxWidth: double.maxFinite,
              minWidth: double.maxFinite,
              minHeight: 64,
              maxHeight: 64),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  "#",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 30,
                  maxWidth: 96,
                  minHeight: 30,
                  minWidth: 40,
                ),
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(showAlphaSelector ? 8 : 6),
                    WhitelistingTextInputFormatter(RegExp("[0-9A-Fa-f]")),
                    _CustomFormatter()
                  ],
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  autofocus: false,
                  onChanged: _handleColorWhenTextChange,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8),
                      hintText: "十六进制颜色值",
                      hintStyle:
                          TextStyle(fontSize: 13, color: Colors.grey[300]),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      errorBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      focusedErrorBorder: inputBorder),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Alpha
                Offstage(
                  offstage: !showAlphaSelector,
                  child: Padding(
                    padding: EdgeInsets.only(top: topMargin),
                    child: _buildProgressBar(
                        customArgbColor.alpha,
                        "A",
                        "${customArgbColor.alpha}",
                        Colors.grey[500],
                        Colors.black26, (value) {
                      int progress = value.floor();
                      customArgbColor = customArgbColor.withAlpha(progress);
                      _controller.text = _formatColorToString();
                      setState();
                    }),
                  ),
                ),
                //Red
                Padding(
                  padding: EdgeInsets.only(top: topMargin),
                  child: _buildProgressBar(
                      customArgbColor.red,
                      "R",
                      "${customArgbColor.red}",
                      Colors.red,
                      Colors.red[100], (value) {
                    int progress = value.floor();
                    customArgbColor = customArgbColor.withRed(progress);
                    _controller.text = _formatColorToString();
                    setState();
                  }),
                ),
                //Green
                Padding(
                  padding: EdgeInsets.only(top: topMargin),
                  child: _buildProgressBar(
                      customArgbColor.green,
                      "G",
                      "${customArgbColor.green}",
                      Colors.green,
                      Colors.green[100], (value) {
                    int progress = value.floor();
                    customArgbColor = customArgbColor.withGreen(progress);
                    _controller.text = _formatColorToString();
                    setState();
                  }),
                ),
                //Blue
                Padding(
                  padding: EdgeInsets.only(top: topMargin, bottom: 8),
                  child: _buildProgressBar(
                      customArgbColor.blue,
                      "B",
                      "${customArgbColor.blue}",
                      Colors.blue,
                      Colors.blue[100], (value) {
                    int progress = value.floor();
                    customArgbColor = customArgbColor.withBlue(progress);
                    _controller.text = _formatColorToString();
                    setState();
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //处理当文本改变时，应该显示的颜色是什么
  void _handleColorWhenTextChange(String s) {
    if (s == null || s.isEmpty) {
      return;
    }
    if (s.length <= 2) {
      if (showAlphaSelector) {
        int alpha = int.tryParse("$s", radix: 16);
        customArgbColor = customArgbColor.withAlpha(alpha);
      } else {
        int red = int.tryParse("$s", radix: 16);
        customArgbColor=customArgbColor.withAlpha(255);
        customArgbColor = customArgbColor.withRed(red);
      }
    }

    if (s.length > 2 && s.length <= 4) {
      if (showAlphaSelector) {
        int red = int.tryParse("${s.substring(2)}", radix: 16);
        customArgbColor = customArgbColor.withRed(red);
      } else {
        int green = int.tryParse("${s.substring(2)}", radix: 16);
        customArgbColor = customArgbColor.withGreen(green);
      }
    }
    if (s.length > 4 && s.length <= 6) {
      if(showAlphaSelector){
        int green = int.tryParse("${s.substring(4)}", radix: 16);
        customArgbColor = customArgbColor.withGreen(green);
      }else{
        int blue = int.tryParse("${s.substring(4)}", radix: 16);
        customArgbColor = customArgbColor.withBlue(blue);
      }
    }
    if (s.length > 6 && s.length <= 8) {
      customArgbColor = Color(int.tryParse("$s", radix: 16));
    }
    setState();
  }

  //构建进度条
  Widget _buildProgressBar(int value, String startText, String endText,
      Color activeColor, Color inActiveColor, ValueChanged<double> callback) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(startText,
                  style: TextStyle(color: Colors.black45, fontSize: 15))),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            activeColor: activeColor,
            inactiveColor: inActiveColor,
            onChanged: callback,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: EdgeInsets.only(left: 2),
              child: SizedBox(
                  width: 30,
                  child: Text(
                    endText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45, fontSize: 15),
                  ))),
        )
      ],
    );
  }

  //更新主界面的颜色选择
  void _selectMainColor(int selectIndex) {
    mainSelectIndex = selectIndex;
    if (_hasChildColor(mainSelectIndex)) {
      showStackIndex = 1;
      subSelectIndex = _findColorIndexInSubColor();
    } else {
      showStackIndex = 0;
      subSelectIndex = -1;
    }
    setState();
  }

  bool _hasChildColor(int mainIndex) {
    if (mainIndex < 0) {
      return false;
    }
    if (subColors == null || subColors.isEmpty) {
      return false;
    }

    if (colors == null ||
        colors.isEmpty ||
        colors.length <= mainIndex ||
        subColors.length <= mainIndex) {
      return false;
    }
    List<Color> sl = subColors[mainIndex];
    return sl != null && sl.isNotEmpty;
  }

  //找到当前颜色在SubColor中的位置如果没有 则返回0
  int _findColorIndexInSubColor() {
    int index = 0;
    Color curColor = colors[mainSelectIndex];
    List<Color> subList = subColors[mainSelectIndex];
    for (int i = 0; i < subList.length; i++) {
      if (subList[i] == curColor) {
        index = i;
        break;
      }
    }
    return index;
  }

//格式化当前的颜色
  String _formatColorToString() {
    if (showAlphaSelector) {
      return customArgbColor.value.toRadixString(16).padLeft(8, '0');
    }
    return customArgbColor.value.toRadixString(16).padLeft(8, '0').substring(2);
  }
}

class _CustomFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
        composing: TextRange.empty);
  }
}
