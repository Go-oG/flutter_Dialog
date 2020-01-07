
# Material_Dialog

# About
Material_dialog 是为了在Flutter中简化Dialog使用而被创建的，该项目参考了GitHub上的[material-dialogs](https://github.com/afollestad/material-dialogs)，目前本项目实现了SimpleDialog、InputDialog、ColorDialog、ListDialog；其它的Dialog在后续会考虑进行实现的

## install
In your flutter project add the dependency:
```
dependencies:
  ...

```

## How To Use MaterialDialog
更多关于[API](#jump)的说明请见[这里](#jump)。

### SimpleDialog



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
该项目主要包含两个核心类 _CoreDialog 和 BaseDialog;
其中_CoreDialog is a Real StatefulWidget,but BaseDialog is Virtual StatelessWidget ,it`s simulated StatefulWidget，so you can use it like use StatefulWidget;SimpleDialog、InputDialog、ListDialog、ColorDialog都是继承于BaseDialog并拥有其全部属性，so,如果你想实现其它Dialog,你可以继承于BaseDialog。
下面是BaseDialog的属性及其含义

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



