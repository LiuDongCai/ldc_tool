import 'package:ldc_tool/common/util/dc_tool.dart';
import 'package:ldc_tool/features/main/logic/main_logic.dart';

class MainLogicHelper {
  static final MainLogicHelper _instance = MainLogicHelper._internal();

  static MainLogicHelper get instance => _instance;

  MainLogicHelper._internal();

  /// 默认初始化，不使用 late 原因避免过早调用出异常
  MainLogic logic = MainLogic();

  String logicTag = DCTool.getUniqueId();
}
