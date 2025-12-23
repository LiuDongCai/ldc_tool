/// 筛选选项模型
class FilterOption {
  /// 选项ID
  final String id;

  /// 选项名称
  final String name;

  /// 是否选中
  final bool isSelected;

  /// 子选项（用于三级筛选）
  final List<FilterOption>? children;

  FilterOption({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.children,
  });

  /// 复制并更新选中状态
  FilterOption copyWith({
    String? id,
    String? name,
    bool? isSelected,
    List<FilterOption>? children,
  }) {
    return FilterOption(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      children: children ?? this.children,
    );
  }
}

/// 筛选组模型
class FilterGroup {
  /// 组标题
  final String title;

  /// 选项列表
  final List<FilterOption> options;

  /// 是否多选
  final bool isMultiSelect;

  FilterGroup({
    required this.title,
    required this.options,
    this.isMultiSelect = false,
  });
}

/// 三级筛选数据模型
class ThreeLevelFilterData {
  /// 第一级数据（如：城市）
  final List<FilterOption> level1;

  /// 第二级数据（如：区域）
  final List<FilterOption>? level2;

  /// 第三级数据（如：生活圈）
  final List<FilterOption>? level3;

  /// 当前选中的第一级ID
  final String? selectedLevel1Id;

  /// 当前选中的第二级ID
  final String? selectedLevel2Id;

  /// 当前选中的第三级ID
  final String? selectedLevel3Id;

  ThreeLevelFilterData({
    required this.level1,
    this.level2,
    this.level3,
    this.selectedLevel1Id,
    this.selectedLevel2Id,
    this.selectedLevel3Id,
  });

  /// 复制并更新选中状态
  ThreeLevelFilterData copyWith({
    List<FilterOption>? level1,
    List<FilterOption>? level2,
    List<FilterOption>? level3,
    String? selectedLevel1Id,
    String? selectedLevel2Id,
    String? selectedLevel3Id,
  }) {
    return ThreeLevelFilterData(
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      selectedLevel1Id: selectedLevel1Id ?? this.selectedLevel1Id,
      selectedLevel2Id: selectedLevel2Id ?? this.selectedLevel2Id,
      selectedLevel3Id: selectedLevel3Id ?? this.selectedLevel3Id,
    );
  }
}

/// 价格范围模型
class PriceRange {
  /// 最低价格
  final double? minPrice;

  /// 最高价格
  final double? maxPrice;

  /// 单位
  final String unit;

  PriceRange({
    this.minPrice,
    this.maxPrice,
    this.unit = '万/坪',
  });
}
