import 'package:ldc_tool/base/light_tracking/core/data_manager.dart';
import 'package:ldc_tool/base/light_tracking/core/define.dart';
import 'package:ldc_tool/common/util/dc_log.dart';

class TLClickManager {
  /// 记录点击的次数
  ///
  /// key: elementId
  /// value: 点击次数
  Map<String, int> clickCountMap = {};

  /// 点击缓存
  ///
  /// 当需要点击，但又没有数据时，先缓存起来
  Map<String, LTBindData?> clickBuffer = {};

  dispose() {
    // 移除监听
    removeGotDataListener();
  }

  /// 上报点击触发
  ///
  /// [elementId] 元素ID
  /// [bindData] 需要绑定的数据
  /// [overrideTime] 重写点击次数
  /// [onTrigger] 满足点击统计条件触发回调
  void report({
    required String elementId,
    required LTBindData? bindData,
    int? overrideTime,
    LTOnClickTrigger? onTrigger,
  }) {
    // 可点击的次数（取不到则为反复点击）
    final triggerTime = overrideTime ?? LTDataMacro.unlimitedTriggerTime;
    bool isUnlimitedTriggerTime =
        LTDataMacro.unlimitedTriggerTime == triggerTime;

    // 取限制的点击次数
    if (isUnlimitedTriggerTime) {
      // 不限次数，反复点击
      onTrigger?.call();
      trigger(
        elementId,
        bindData: bindData,
      );
    } else {
      // 准确点击次数
      final currentClickCount = clickReportRecordCount(
        elementId,
      );
      // 已达点击次数限制
      if (currentClickCount >= triggerTime) {
        return;
      }
      // 未达点击次数限制
      onTrigger?.call();
      trigger(
        elementId,
        bindData: bindData,
      );
    }
  }

  /// 触发点击统计
  ///
  /// 注: 该方法内不可能处理 onTrigger 的调用
  void trigger(
    String elementId, {
    required LTBindData? bindData,
  }) {
    // 不管是否有拿到数据，都先记录起来
    DCLog.i('触发点击统计 $elementId');
    recordClickReportCount(elementId);

    addToClickBuffer(
      elementId,
      bindData: bindData,
    );
    addGotDataListener();
    return;
  }

  /// 添加到点击缓存
  void addToClickBuffer(
    String elementId, {
    required LTBindData? bindData,
  }) {
    clickBuffer[elementId] = bindData;
  }

  /// 处理缓存中的点击
  void handleBuffer() {
    if (clickBuffer.isEmpty) return;
    // 拷贝，避免在遍历时修改
    final tempBufferData = Map.from(clickBuffer);
    for (final elementId in tempBufferData.keys) {
      // 先移除
      clickBuffer.remove(elementId);
      // 重置点击记录，之前有无数据都会记录，是因为需要触发 onTrigger
      // 现在重置掉无用记录，再调用 trigger 上报统计
      resetClickCount(elementId);
      // 再处理点击统计
      trigger(
        elementId,
        bindData: tempBufferData[elementId],
      );
    }
  }
}

/// 获取数据监听
extension TLClickManagerForGotDataListener on TLClickManager {
  /// 添加监听
  void addGotDataListener() {
    final id = gotDataListenerId();
    // 如果已经存在监听，则不用再添加
    if (TLDataManager.instance.exitGotDataListener(id)) return;
    TLDataManager.instance.addGotDataListener(
      id,
      () {
        // 拿到接口数据后触发点击
        handleBuffer();
      },
    );
  }

  void removeGotDataListener() {
    TLDataManager.instance.removeGotDataListener(gotDataListenerId());
  }

  /// 用于 gotDataListener 的 ID
  String gotDataListenerId() {
    return hashCode.toString();
  }
}

/// 上报点击的数据管理
extension TLClickManagerForClickReport on TLClickManager {
  /// 记录点击
  void recordClickReportCount(String elementId) {
    final count = clickCountMap[elementId] ?? 0;
    clickCountMap[elementId] = count + 1;
  }

  /// 当前的点击次数
  int clickReportRecordCount(String elementId) {
    return clickCountMap[elementId] ?? 0;
  }

  /// 重置点击次数
  void resetClickCount(String elementId) {
    clickCountMap.remove(elementId);
  }
}
