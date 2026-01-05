import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/game/logic/game_logic.dart';
import 'package:ldc_tool/features/game/header/game_header.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> with GameLogicPutMixin<GamePage> {
  @override
  GameLogic dcInitLogic() => GameLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<GameLogic>(
      tag: logicTag,
      builder: (_) {
        Widget resultWidget = Center(
          child: Text(
            'Game 待开发...',
            style: TextStyle(
              fontSize: 16.sp,
              color: DCColors.dcFF8000,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        resultWidget = Scaffold(
          body: resultWidget,
        );
        return resultWidget;
      },
    );
  }
}
