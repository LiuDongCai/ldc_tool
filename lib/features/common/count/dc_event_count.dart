import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ldc_tool/common/util/dc_log.dart';

class DCEventCount {
  /// 设置默认参数
  static Future<void> setDefaultEventParameters(
    Map<String, Object> parameters,
  ) async {
    DCLog.d("count>>> setDefaultEventParameters--$parameters");
    return FirebaseAnalytics.instance.setDefaultEventParameters(parameters);
  }

  /// 设置用户id
  static Future<void> setUserId(String? userId) async {
    DCLog.d("count>>> setUserId--$userId");
    return FirebaseAnalytics.instance.setUserId(id: userId);
  }

  /// 发送事件
  static Future<void> doSendGACount(
    String event,
    Map<String, Object> params,
  ) async {
    final result = await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: params,
    );
    DCLog.d("count>>> $event $params");
    return result;
  }

  /// 发送屏幕事件(GTM后台会做转化)
  static Future<void> doSendPageGACount(
    String path, {
    String name = '',
    Map<String, Object>? params,
  }) async {
    //设置全局module_path
    setDefaultEventParameters({
      'module_path': path,
    });
    return doSendGACount(
      'screen_view',
      _handleScreenParams(
        {
          'screen_class': path,
          'screen_name': name,
          'module_name': name,
        },
        params,
      ),
    );
  }

  /// 处理屏幕事件参数
  static Map<String, Object> _handleScreenParams(
    Map<String, Object> screenParams,
    Map<String, Object>? extraParams,
  ) {
    if (extraParams != null) {
      screenParams.addAll(extraParams);
    }
    return screenParams;
  }

  /// 发送电子商务（view_item_list）事件
  static Future<void> doSendViewItemListGACount(
    Map<String, Object> params,
    AnalyticsEventItem eventItem,
  ) async {
    DCLog.d(
      "count>>> event=view_item_list, eventItemParams=${eventItem.parameters}, params=$params",
    );
    return FirebaseAnalytics.instance.logViewItemList(
      items: [eventItem],
      parameters: params,
    );
  }

  /// 发送电子商务（select_item）事件
  static Future<void> doSendSelectItemGACount(
    Map<String, Object> params,
    AnalyticsEventItem eventItem,
  ) async {
    DCLog.d(
      "count>>> event=select_item, eventItemParams=${eventItem.parameters}, params=$params",
    );
    return FirebaseAnalytics.instance.logSelectItem(
      items: [eventItem],
      parameters: params,
    );
  }

  /// 发送电子商务（view_item）事件
  static Future<void> doSendViewItemGACount(
    Map<String, Object> params,
    AnalyticsEventItem eventItem,
  ) async {
    DCLog.d(
      "count>>> event=view_item, eventItemParams=${eventItem.parameters}, params=$params",
    );
    return FirebaseAnalytics.instance.logViewItem(
      items: [eventItem],
      parameters: params,
    );
  }
}
