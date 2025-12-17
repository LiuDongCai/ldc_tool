import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/features/main/logic/main_logic.dart';
import 'package:ldc_tool/features/main/header/main_header.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with MainLogicPutMixin<MainPage> {
  @override
  MainLogic dcInitLogic() => MainLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<MainLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          body: Container(),
        );
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with MainLogicConsumerMixin<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
