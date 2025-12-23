import 'package:flutter/material.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

mixin EatListStateList on EatListCommonState {
  /// 滚动控制器
  ScrollController scrollController = ScrollController();
}
