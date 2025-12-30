import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:os_detect/os_detect.dart' as os_detect;

class DCTool {
  /// 是否是安卓平台
  static bool get isAndroid {
    return os_detect.isAndroid;
  }

  /// 是否是iOS平台
  static bool get isIOS {
    return os_detect.isIOS;
  }

  /// 是否是 Web 平台
  static bool get isWeb {
    return kIsWeb;
  }

  /// 获取设备
  static String device() {
    if (isAndroid) {
      return "android";
    } else if (isIOS) {
      return "ios";
    } else {
      return "unknown";
    }
  }

  /// 获取唯一标识：随机数 + 时间
  static String getUniqueId({int count = 3}) {
    String randomStr = Random().nextInt(10).toString();
    for (var i = 0; i < count; i++) {
      var str = Random().nextInt(10);
      randomStr = randomStr + "$str";
    }
    final timeNumber = DateTime.now().millisecondsSinceEpoch;
    final uuid = randomStr + "$timeNumber";
    return uuid;
  }
}
