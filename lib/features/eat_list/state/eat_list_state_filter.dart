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
    if (selectedFoodTypeIds.contains('0')) return '菜系';
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

  // /// 价格数据
  // List<DCPriceRangeOption> priceDataList = [
  //   DCPriceRangeOption(
  //     id: '1',
  //     name: '10-30元',
  //     range: DCPriceRange(minPrice: 10, maxPrice: 30),
  //   ),
  //   DCPriceRangeOption(
  //     id: '2',
  //     name: '30-50元',
  //     range: DCPriceRange(minPrice: 30, maxPrice: 50),
  //   ),
  //   DCPriceRangeOption(
  //     id: '3',
  //     name: '50-100元',
  //     range: DCPriceRange(minPrice: 50, maxPrice: 100),
  //   ),
  //   DCPriceRangeOption(
  //     id: '4',
  //     name: '100-200元',
  //     range: DCPriceRange(minPrice: 100, maxPrice: 200),
  //   ),
  //   DCPriceRangeOption(
  //     id: '5',
  //     name: '200-500元',
  //     range: DCPriceRange(minPrice: 200, maxPrice: 500),
  //   ),
  //   DCPriceRangeOption(
  //     id: '6',
  //     name: '500元以上',
  //     range: DCPriceRange(minPrice: 500),
  //   ),
  // ];

  // /// 选中的价格列表
  // DCPriceRangeOption? selectedPriceRange;

  // /// 选中的价格名称
  // String get selectedPriceName {
  //   if (selectedPriceRange == null) return '价格';
  //   final minPrice = selectedPriceRange?.range.minPrice;
  //   final maxPrice = selectedPriceRange?.range.maxPrice;
  //   if (minPrice == null && maxPrice == null) return '价格';
  //   if (minPrice == null) return '$maxPrice元以上';
  //   if (maxPrice == null) return '$minPrice元以下';
  //   return '$minPrice-$maxPrice元';
  // }
}
