import 'package:ldc_tool/base/light_tracking/core/define.dart';
import 'package:ldc_tool/base/light_tracking/core/data_manager.dart';
import 'package:ldc_tool/common/util/dc_log.dart';

/// 曝光管理类
class TLExposureManager {
  /*
  ==================== 规则 ====================
  
  如果已经拿到数据，则按数据中的 exposureRatio 来计算曝光，曝光次数按 triggerTime
  - exposureRatio: 为0时，一出现就曝光
  - triggerTime: 为-1时，反复曝光，非-1时为准确曝光次数
  
  如果没有拿到数据，则按照 1/2 曝光来计算曝光，并且先存储起来，等到拿到数据后再触发曝光
  */

  // 记录是否已曝光
  Map<String, bool> recordMap = {};

  /// 记录曝光次数
  ///
  /// key: elementId
  /// value: 曝光次数
  Map<String, int> exposureCountMap = {};

  /// 曝光缓存
  ///
  /// 当需要曝光，但又没有数据时，先缓存起来
  Map<String, LTBindData?> exposureBuffer = {};

  /// 有效重置记录次数
  ///
  /// key: elementId
  /// value: 曝光次数
  Map<String, int> resetCountMap = {};

  void dispose() {
    // 移除监听
    removeGotDataListener();
  }

  /// 上报曝光触发
  ///
  /// [elementId] 元素ID
  /// [visiblePercentage] 当前可见百分比 (0.0 - 1.0]
  /// [bindData] 绑定数据
  /// [overrideRatio] 重写检测曝光的比例
  /// [overrideTime] 重写曝光次数
  /// [onTrigger] 满足曝光统计条件触发回调
  /// [onReset] 有效重置曝光记录回调
  void report({
    required String elementId,
    required double visiblePercentage,
    required LTBindData? bindData,
    LTExposureRatio? overrideRatio,
    int? overrideTime,
    LTOnExposureTrigger? onTrigger,
    LTOnReset? onReset,
  }) {
    // 触发曝光的视图比例
    double exposureRatio = overrideRatio?.value ?? 0;
    // 值为百分比([0, 100])，转换为小数
    exposureRatio = exposureRatio / 100;
    // 可曝光的次数（取不到则为反复曝光）
    final triggerTime = overrideTime ?? LTDataMacro.unlimitedTriggerTime;
    bool isUnlimitedTriggerTime =
        LTDataMacro.unlimitedTriggerTime == triggerTime;

    if (overrideRatio == null) {
      // 没有数据 且 没有重写曝光比例
      // 按 1/2 曝光的规则来
      exposureRatio = 0.5;
    }
    // 小于等于 0 时，重置为最小正数，方便计算
    if (exposureRatio <= 0) {
      exposureRatio = double.minPositive;
    }

    // 不满足曝光条件
    if (visiblePercentage < exposureRatio) {
      // 如果是反复曝光，则重置曝光记录
      //
      // 如果是准确曝光次数，则在未达到曝光次数限制时，也重置曝光记录
      if (isUnlimitedTriggerTime ||
          exposureReportRecordCount(elementId) <= triggerTime) {
        if (canRecordResetCount(elementId)) {
          // 有记录，此次为有效重置
          // 先触发 onReset 回调
          onReset?.call();
          // 再记录重置
          recordExposureResetCount(elementId);
        }
        resetExposureForCalc(elementId);
      }
      return;
    }

    // 满足曝光条件
    if (haveExposureForCalc(elementId)) {
      // 已经曝光过了
      return;
    }
    recordExposureForCalc(elementId);

    // 取限制的曝光次数
    if (isUnlimitedTriggerTime) {
      // 不限次数，反复曝光
      onTrigger?.call();
      trigger(
        elementId,
        bindData: bindData,
      );
    } else {
      // 准确曝光次数
      final currentExposureCount = exposureReportRecordCount(
        elementId,
      );
      // 已达曝光次数限制
      if (currentExposureCount >= triggerTime) {
        return;
      }
      // 未达曝光次数限制
      onTrigger?.call();
      trigger(
        elementId,
        bindData: bindData,
      );
    }
  }

  /// 触发曝光统计
  ///
  /// 注: 该方法内不可能处理 onTrigger 的调用
  void trigger(
    String elementId, {
    LTBindData? bindData,
  }) {
    // 不管是否有拿到数据，都先记录起来
    DCLog.i('触发曝光统计 $elementId');
    recordExposureReportCount(elementId);

    addToExposureBuffer(
      elementId,
      bindData: bindData,
    );
    addGotDataListener();
    return;
  }

  /// 添加到曝光缓存
  void addToExposureBuffer(
    String elementId, {
    required LTBindData? bindData,
  }) {
    exposureBuffer[elementId] = bindData;
  }

  /// 处理缓存中的曝光
  void handleBuffer() {
    if (exposureBuffer.isEmpty) return;
    // 拷贝，避免在遍历时修改
    final tempBufferData = Map.from(exposureBuffer);
    for (final elementId in tempBufferData.keys) {
      // 先移除
      exposureBuffer.remove(elementId);
      // 重置曝光记录，之前有无数据都会记录，是因为需要触发 onTrigger
      // 现在重置掉无用记录，再调用 trigger 上报统计
      resetExposureCount(elementId);
      // 再处理曝光统计
      trigger(
        elementId,
        bindData: tempBufferData[elementId],
      );
    }
  }
}

/// 获取数据监听
extension TLExposureManagerForGotDataListener on TLExposureManager {
  /// 添加监听
  void addGotDataListener() {
    final id = gotDataListenerId();
    // 如果已经存在监听，则不用再添加
    if (TLDataManager.instance.exitGotDataListener(id)) return;
    TLDataManager.instance.addGotDataListener(
      id,
      () {
        // 拿到接口数据后触发曝光
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

/// 上报曝光的数据管理
extension TLExposureManagerForExposureReport on TLExposureManager {
  /// 记录曝光
  void recordExposureReportCount(String elementId) {
    final count = exposureCountMap[elementId] ?? 0;
    exposureCountMap[elementId] = count + 1;
  }

  /// 当前的曝光次数
  int exposureReportRecordCount(String elementId) {
    return exposureCountMap[elementId] ?? 0;
  }

  /// 重置曝光次数
  void resetExposureCount(String elementId) {
    exposureCountMap.remove(elementId);
  }
}

/// 重置次数的数据管理
extension TLExposureManagerForExposureReset on TLExposureManager {
  /// 记录重置
  void recordExposureResetCount(String elementId) {
    final count = resetCountMap[elementId] ?? 0;
    resetCountMap[elementId] = count + 1;
  }

  /// 是否可以记录重置
  bool canRecordResetCount(String elementId) {
    final resetCount = resetCountMap[elementId] ?? 0;
    final reportCount = exposureReportRecordCount(elementId);
    // 因为是先触发 onReset，再记录重置的，所以这里用 <
    return resetCount < reportCount;
  }
}

/// 内部曝光计算
extension TLExposureManagerForExposureCalc on TLExposureManager {
  /// 记录曝光计算
  void recordExposureForCalc(String elementId) {
    recordMap[elementId] = true;
  }

  /// 是否已在曝光计算记录中
  bool haveExposureForCalc(String elementId) {
    return recordMap[elementId] ?? false;
  }

  /// 重置曝光计算记录
  void resetExposureForCalc(String elementId) {
    recordMap.remove(elementId);
  }
}
