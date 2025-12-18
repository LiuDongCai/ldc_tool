import 'package:flutter/material.dart';
import 'package:ldc_tool/features/eat/state/eat_state_banner.dart';
import 'package:ldc_tool/features/eat/state/eat_state_menu.dart';

class EatState extends EatCommonState with EatStateMenu, EatStateBanner {}

class EatCommonState {
  /// 頁面overlay上下文
  BuildContext? pageOverlayContext;
}
