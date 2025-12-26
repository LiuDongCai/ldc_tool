import 'package:flutter/material.dart';
import 'package:ldc_tool/features/home/state/home_state_banner.dart';
import 'package:ldc_tool/features/home/state/home_state_menu.dart';

class HomeState extends HomeCommonState with HomeStateMenu, HomeStateBanner {}

class HomeCommonState {
  /// 頁面overlay上下文
  BuildContext? pageOverlayContext;
}
