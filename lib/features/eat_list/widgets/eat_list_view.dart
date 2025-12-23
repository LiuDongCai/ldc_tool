import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_item_view.dart';

class EatListView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  EatListView({super.key});

  @override
  State<EatListView> createState() => _EatListViewState();
}

class _EatListViewState extends State<EatListView>
    with EatListLogicConsumerMixin<EatListView> {
  EatListState get state => logic.state;

  /// 餐馆列表
  List<EatModel> get eatList => state.eatList;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = GetBuilder<EatListLogic>(
      tag: logicTag,
      id: EatListUpdateId.eatList,
      builder: (_) {
        if (eatList.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        // 列表
        Widget resultWidget = ListView.separated(
          cacheExtent: double.maxFinite,
          controller: state.scrollController,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10.w),
          itemCount: eatList.length,
          itemBuilder: (BuildContext context, int index) {
            var model = eatList[index];
            return _buildItemWidget(model: model);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.w);
          },
        );
        return resultWidget;
      },
    );
    return resultWidget;
  }

  Widget _buildItemWidget({
    required EatModel model,
  }) {
    Widget resultWidget = EatListItemView(
      model: model,
    );
    // 卡片布局
    resultWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
        boxShadow: [
          BoxShadow(
            color: DCColors.dc516263.withAlpha(10),
            offset: Offset(0, 1.w), // 阴影xy轴偏移量
            blurRadius: 5.w, // 阴影模糊程度
            spreadRadius: -1.w, // 阴影扩散程度
          )
        ],
      ),
      child: resultWidget,
    );
    return resultWidget;
  }
}
