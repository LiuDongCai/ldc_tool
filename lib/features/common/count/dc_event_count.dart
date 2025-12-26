import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class DCEventCount {
  /// 事件统计
  static countEvent(
    String eventName, {
    Map<String, dynamic>? params,
  }) {
    // 发送自定义事件
    // 参数说明：目前属性值支持字符、整数、浮点、长整数，暂不支持NULL、布尔、MAP、数组
    UmengCommonSdk.onEvent(
      "eventName",
      params ?? {},
    );
  }
}
