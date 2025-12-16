/// 数据绑定类型
typedef LTBindData = Map<String, Object?> Function();

/// 满足点击统计条件触发回调类型
typedef LTOnClickTrigger = void Function();

/// 满足曝光统计条件触发回调类型
typedef LTOnExposureTrigger = void Function();

/// 有效重置统计记录的触发回调类型
typedef LTOnReset = void Function();

/// 上报数据类型
typedef LTOnReportData = ({
  String id,
  LTBindData? bindData,
});

/// 上报回调类型
typedef LTOnReport = void Function(LTOnReportData);

class LTDataMacro {
  /// 不限制触发次数
  static const int unlimitedTriggerTime = -1;
}

/// 跟踪类型
enum LTTrackingType {
  /// 点击
  click(1),

  /// 曝光
  exposure(2);

  final int value;

  static LTTrackingType? from(int? value) {
    if (value == null) return null;
    try {
      return LTTrackingType.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (e) {
      return null;
    }
  }

  const LTTrackingType(this.value);
}

/// 平台（设备）
enum LTPlatform {
  /// PC
  pc('1'),

  /// 触屏
  touch('2'),

  /// iOS
  ios('3'),

  /// Android
  android('4');

  final String value;

  const LTPlatform(this.value);
}

/// 曝光比例
enum LTExposureRatio {
  /// 一出现就曝光
  appear(0),

  /// 1/2 曝光
  half(50),

  /// 100% 曝光
  full(100);

  final double value;

  const LTExposureRatio(this.value);
}
