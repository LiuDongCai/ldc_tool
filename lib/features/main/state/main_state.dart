import 'package:flutter/material.dart';
import 'package:ldc_tool/features/main/header/main_header.dart';
import 'package:ldc_tool/features/main/widgets/main_lazy_load_indexed_stack.dart';

class MainState {
  /// MainLazyLoadIndexedStack 的 key
  GlobalKey<MainLazyLoadIndexedStackState> mainKey = GlobalKey();

  /// 当前选中的底部导航栏索引
  int currentIndex = 0;

  /// 底部导航栏集合
  List<MainBottomNavigationBarType> bottomNavigationBarTypeList = [
    MainBottomNavigationBarType.home,
    MainBottomNavigationBarType.eat,
    MainBottomNavigationBarType.game,
    MainBottomNavigationBarType.mine,
  ];

  /// 底部导航栏集合的 key
  Map<MainBottomNavigationBarType, GlobalKey> globalKeys = {
    MainBottomNavigationBarType.home: GlobalKey(),
    MainBottomNavigationBarType.eat: GlobalKey(),
    MainBottomNavigationBarType.game: GlobalKey(),
    MainBottomNavigationBarType.mine: GlobalKey(),
  };

  /// 当前选中的底部导航栏类型
  MainBottomNavigationBarType get currentBottomNavigationBarType {
    if (currentIndex < 0 ||
        currentIndex >= bottomNavigationBarTypeList.length) {
      return MainBottomNavigationBarType.home;
    }
    return bottomNavigationBarTypeList[currentIndex];
  }

  /// 所有页面（未加载的页面取到的是Container）
  List<Widget> get pageList => mainKey.currentState?.pageList ?? [];

  /// 当前页面
  Widget? get currentPage {
    if (currentIndex < 0 || currentIndex >= pageList.length) {
      return null;
    }
    return pageList[currentIndex];
  }

  /// 当前页面的State
  State<StatefulWidget>? get currentPageState {
    if (currentIndex < 0 || currentIndex >= globalKeys.length) {
      return null;
    }
    return globalKeys[currentIndex]?.currentState;
  }
}
