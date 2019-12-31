import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_dialog/src/core/core_dialog.dart';
import 'dialog.dart';

///自定义Dialog的工具类
class DialogUtil {
  DialogUtil._();

  static Future<dynamic> show(BuildContext context, BaseDialog dialog) {
   return showGeneralDialog(
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
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        if (dialog.animation == null) {
          return BaseDialog.buildDialogTransitions(
              context, animation, secondaryAnimation, child);
        } else {
          return dialog.animation(
              context, animation, secondaryAnimation, child);
        }
      },
      useRootNavigator: true,
    );
  }
}
