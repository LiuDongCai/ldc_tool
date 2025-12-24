import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';

typedef EatListLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatListLogic, W>;

typedef EatListLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatListLogic, W>;

/// 更新类型
enum EatListUpdateId {
  /// 餐馆列表
  eatList,

  /// 筛选栏
  filterBar
}

/// 筛选类型
enum EatListFilterType {
  /// 品类筛选
  mainType('mainType'),

  /// 区域筛选
  section('section'),

  /// 菜系筛选
  foodType('foodType'),

  /// 价格筛选
  priceType('priceType'),

  /// 更多筛选
  more('more'),

  /// 排序筛选
  sort('sort');

  final String type;

  const EatListFilterType(this.type);
}

/// 排序类型
enum EatListFilterSortType {
  /// 默认排序
  defaultSort,

  /// 评分从高到低
  scoreHighToLow,

  /// 评分从低到高
  scoreLowToHigh,
}

/// 更多筛选类型
enum EatListMoreFilterType {
  /// 返现平台
  cashback('返现平台');

  final String type;

  const EatListMoreFilterType(this.type);
}
