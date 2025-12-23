import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

mixin EatListStateFilter on EatListCommonState {
  /// 餐馆列表（筛选后）
  List<EatModel> eatList = [];

  /// 选中的品类名称
  String get selectedMainTypeName => EatMainType.values
      .firstWhere((element) => element.type == selectedMainType)
      .name;

  /// 选中的品类ID
  int selectedMainType = EatMainType.all.type;

  /// 选中的区域ID列表,0表示不限
  int selectedSectionId = 0;

  /// 选中的区域名称
  String get selectedSectionName {
    if (selectedSectionId == 0) return '区域';
    return SectionType.values
        .firstWhere(
          (element) => element.type == selectedSectionId,
        )
        .name;
  }

  /// 选中的菜系ID列表
  List<String> selectedFoodTypeIds = [];

  /// 选中的菜系名称
  String get selectedFoodTypeName {
    if (selectedFoodTypeIds.isEmpty) return '菜系';
    return selectedFoodTypeIds
        .map((id) => FoodType.values
            .firstWhere((element) => element.type == int.tryParse(id))
            .name)
        .join(',');
  }

  /// 选中的返现平台ID列表
  List<String> selectedCashbackIds = [];

  /// 排序类型
  EatListFilterSortType sortType = EatListFilterSortType.defaultSort;
}
