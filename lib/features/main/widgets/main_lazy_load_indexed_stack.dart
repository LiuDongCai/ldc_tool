/*
 * @Description: flutter 懒加载 切换保持状态
 * @Link: https://gist.github.com/CaiJingLong/a7f40303338c1b843949b64487072cf2
 */
import 'package:flutter/material.dart';

class MainLazyLoadIndexedStack extends StatefulWidget {
  final List<Widget> children;
  final int currentIndex;

  const MainLazyLoadIndexedStack({
    super.key,
    required this.children,
    required this.currentIndex,
  });

  @override
  State<MainLazyLoadIndexedStack> createState() =>
      MainLazyLoadIndexedStackState();
}

class MainLazyLoadIndexedStackState extends State<MainLazyLoadIndexedStack> {
  final initMap = <int, bool>{};

  List<Widget> pageList = [];

  @override
  void initState() {
    super.initState();
    initMap[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    final children = createChildren();
    pageList = children;
    return IndexedStack(
      children: pageList,
      index: widget.currentIndex,
    );
  }

  List<Widget> createChildren() {
    final result = <Widget>[];
    for (var i = 0; i < widget.children.length; ++i) {
      Widget w = widget.children[i];
      // 当前页面 ticker 开启，其他页面 ticker 关闭
      final enabledTicker = widget.currentIndex == i;
      w = TickerMode(
        enabled: enabledTicker,
        child: w,
      );
      if (initMap[i] == true) {
        result.add(w);
      } else {
        result.add(Container());
      }
    }
    return result;
  }

  @override
  void didUpdateWidget(MainLazyLoadIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      initMap[widget.currentIndex] = true;
      setState(() {});
    }
  }
}
