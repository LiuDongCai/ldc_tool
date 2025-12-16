import 'package:ldc_tool/base/light_tracking/core/define.dart';

class TLDataManager {
  /// 私有构造函数
  TLDataManager._internal();

  /// 单例实例
  static final TLDataManager _instance = TLDataManager._internal();

  /// 提供一个全局访问点
  static TLDataManager get instance => _instance;

  /// 监听器
  final Map<String, Function()> _gotDataListeners = {};

  /// 是否正在获取数据中
  bool isGettingData = false;

  /// 埋点应用 ID
  List<String> appIds = const [];

  /// 平台
  List<LTPlatform> platforms = const [];

  /// 对接外部的GA上报
  LTOnReport? onReport;

  /// 是否为调试模式
  bool isDebug = false;

  /// 初始化
  void setup({
    required List<String> appIds,
    required List<LTPlatform> platforms,
    required LTOnReport? onReport,
    bool isDebug = false,
  }) {
    this.appIds = appIds;
    this.platforms = platforms;
    this.onReport = onReport;
    this.isDebug = isDebug;
  }
}

/// 监听器管理
extension TLDataManagerForGotDataListener on TLDataManager {
  /// 添加监听
  void addGotDataListener(
    String id,
    Function() listener,
  ) {
    _gotDataListeners[id] = listener;
  }

  /// 移除监听
  void removeGotDataListener(String id) {
    _gotDataListeners.remove(id);
  }

  bool exitGotDataListener(String id) {
    return _gotDataListeners[id] != null;
  }
}
