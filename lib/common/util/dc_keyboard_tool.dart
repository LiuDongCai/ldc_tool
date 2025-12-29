import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DCKeyboardTool {
  ///收回键盘 并返回是否收需要收回（注：这样可以保证没有谈起软键盘的时候第一次点击空白处不会刷新）
  static bool hideKeyboard({BuildContext? context}) {
    context = context ?? Get.context;
    if (context != null) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
