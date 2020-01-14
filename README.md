
# Material_Dialog

# About
Material_dialog was created to simplify the use of Dialog in Flutter. 
The project refers to [material-dialogs](https://github.com/afollestad/material-dialogs) on GitHub. 
Currently, this project implements SimpleDialog and InputDialog , ColorDialog, ListDialog; 
other Dialogs will be considered for implementation in the future
## install
Because for other reasons I can't publish my program on pub.dev, so currently you only have to clone the project

## How To Use MaterialDialog
For more about [API](#jump), please see [here](#jump).
### SimpleDialog
![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/simple_dialog.jpg)

```
    cs.SimpleDialog dialog = cs.SimpleDialog(
         title: Text("Simple Dialog",
             style: TextStyle(fontSize: 19, color: Colors.black87)),
         titleIcon: Icon(
           Icons.send,
           color: Colors.black87,
         ),
         contentStyle: TextStyle(fontSize: 17, color: Colors.black54),
         content: "This is Simple Dialog" * 5,
         cornerRadius: BorderRadius.circular(16),
         checkBoxPrompt: Text(
           "This is CheckBoxPrompt text",
           style: TextStyle(color: Colors.black54, fontSize: 13),
         ),
         promptInitValue: true,
         autoCancel: true,
         outCanCancel: false,
         breakCancel: false,
         gravity: Gravity.center,
         backgroundColor: Colors.white,
         maskColor: Colors.black38,
         positive: "done",
         negative: "cancel",
         positiveColor: Colors.blue,
         negativeColor: Colors.red);
     DialogUtil.show(context, dialog);
```
the cs is library Alias;the real Value is: package:material_dialog/subtype/simple_dialog.dart

### InputDialog
![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/input_dialog.jpg)

```
     InputDialog dialog = InputDialog(
      title: Text("Input Dialog", style: TextStyle(color: Colors.black87, fontSize: 19)),
      autoCancel: true,
      hintText: "please input content",
      contentStyle: TextStyle(fontSize: 17,color: Colors.black54),
      positive: "done",
      negative: "cancel",
      showMaxLengthTip: false,
      maxLength: null,
      inputType: InputType.TEXT,
    );
    DialogUtil.show(context, dialog);
```

### ListDialog
![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/list_dialog1.jpg) ![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/list_dialog2.jpg)

```
    ListDialog dialog = ListDialog(15, (val) {
      return "Item $val";
    },
        singleSelect: true,
        isRadioButton: false,
        title: Text(
          "List Dialog",
          style: TextStyle(color: Colors.black87, fontSize: 19),
        ),
        positive: "done",
        negative: "cancel",
        autoCancel: true);
    DialogUtil.show(context, dialog);
```

### ColorList
![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/color_dialog1.jpg) ![SimpleDialog](https://raw.githubusercontent.com/Go-oG/flutter_Dialog/master/static/color_dialog2.jpg)

```
 ColorDialog dialog = ColorDialog(
        title: Text("Color Dialog"),
        positive: "done",
        negative: "cancel",
        cornerRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        showAlphaSelector: true,
        initialSelection: Colors.blue[500],
        allowCustomArgb: true);

    var result = await DialogUtil.show(context, dialog);
    if (result == null) {
      print("Not choose Color");
    }
    Color color = result as Color;
```
<spand id="jump"></spand>

### API Introduction
The project mainly contains two core classes _CoreDialog and BaseDialog;
_CoreDialog is a Real StatefulWidget, but BaseDialog is Virtual StatelessWidget, it`s simulated StatefulWidget, so you can use it like use StatefulWidget; SimpleDialog, InputDialog, ListDialog, and ColorDialog are all inherited from BaseDialog and have all their attributes, so, if If you want to implement other Dialog, you can inherit from BaseDialog.
Here are the properties of BaseDialog and their meaning

| Parameter  | Type  | Mean  |
| ------------ | ------------ | ------------ |
|  title | Text  | 标题  |
| titleIcon  | Widget  | 标题图标  |
| checkBoxPrompt  | Text  | 底部提示内容  |
|  positive | String   | 确认按钮  |
|  negative | String  |消极按钮   |
|  reverseActionButton | bool  | 是否反转按钮顺序  |
| actionListener  |  ActionListener | 按钮点击事件监听器  |
| checkBoxPromptCallback  |  ValueChanged<bool> | 底部CheckBox的事件监听器  |
| animation  | RouteTransitionsBuilder  |  Dialog动画 |
|  BorderRadiusGeometry |  cornerRadius | Dialog四周圆角  |
| promptInitValue  | bool  | checkBoxPrompt的初始时是否选中  |
| autoCancel  |  bool |  是否自动消失 |
| breakCancel  | bool  | 是否屏蔽返回键  |
| outCanCancel  | bool  | 点击外部能取消不  |
| positiveColor  | Color  |积极按钮的文字颜色  |
| negativeColor  | Color  |消极按钮的文字颜色  |
| backgroundColor  |  Color | 背景颜色  |
| maskColor  |  Color |  遮罩层颜色 |
| gravity  |  Gravity |  显示位置 |
| transitionDuration  |  Duration |  动画持续时间 |

## SimpleDialog

| Parameter  | Type  | Mean  |
| ------------ | ------------ | ------------ |
|  content | String  | 内容  |
|  contentStyle | TextStyle  | 内容样式  |

## InputDialog

| Parameter  | Type  | Mean  |
| ------------ | ------------ | ------------ |
|  border | InputBorder  | 文本输入框的边框  |
|  maxLength | int  | 最大输入长度  |
|  showMaxLengthTip | bool  | 是否显示最大长度提示  |
|  autoFocus | bool  | 自动获取焦点  |
|  hintText | String  | 隐藏文本  |
|  hintStyle | TextStyle  | 隐藏文本样式  |
|  contentStyle | TextStyle  | 输入文本样式  |
|  borderColor | Color  | 默认的边框的颜色  |
|  inputType | InputType  | 输入类型  |
|  textContentPadding | EdgeInsetsGeometry  | 内容间距|
|  onChanged | ValueChanged<String>  | 内容改变回调|

## ListDialog

| Parameter  | Type  | Mean  |
| ------------ | ------------ | ------------ |
|  itemCount | int   | item的数量 |
|  itemBuilder | ItemBuilder   | 构建单个Item |
|  itemStyle | TextStyle   | item文本样式 |
|  activeColor | Color   | ... |
|  checkColor | Color   | ... |
|  focusColor | Color   | ... |
|  isRadioButton | bool   | 是否为RadiuButton |
|  singleSelect | bool   | 单选还是多选 |

## ColorDialog

| Parameter  | Type  | Mean  |
| ------------ | ------------ | ------------ |
|  columnCount | int   | 列数 |
|  childItemMargin | double   | child之间的间距 |
|  outCircleWidth | double   | 外层圆环的宽度 |
|  initialSelection | Color   | 初始化时传入的颜色初定值 |
|  allowCustomArgb | bool   | 是否运行显示自定义颜色 |
|  showAlphaSelector | bool   | 是否显示透明通道的选择器 |
|  colors | List<Color>   | 颜色 |
|  childColors | List<Color>   | 二级颜色 |

