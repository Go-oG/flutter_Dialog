import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dialog.dart';



///自定义Dialog的工具类
class DialogUtil {
  DialogUtil._();

  static void show(BuildContext context, BaseDialog dialog) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = CoreDialog(dialog);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return pageChild;
          }),
        );
      },
      barrierDismissible: dialog.outCanCancel,
      barrierLabel: "",
      barrierColor: dialog.maskColor,
      transitionDuration: dialog.transitionDuration,
      transitionBuilder: dialog.buildMaterialDialogTransitions,
      useRootNavigator: true,
    );
  }
}
