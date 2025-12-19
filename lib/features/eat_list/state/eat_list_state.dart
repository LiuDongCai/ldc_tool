import 'package:flutter/material.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';

class EatListState {
  /// 餐馆列表
  List<EatModel> eatList = [];

  /// 滚动控制器
  ScrollController scrollController = ScrollController();

  /// 点餐大类
  EatMainType eatMainType = EatMainType.main;
}
