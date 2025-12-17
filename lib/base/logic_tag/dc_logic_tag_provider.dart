part of dc_logic_tag;

class DCLogicTagProvider<T> extends StatefulWidget {
  const DCLogicTagProvider({
    super.key,
    required this.child,
    this.logicTag,
    this.onInit,
  });

  final Widget child;

  final String? logicTag;

  final Function(String tag)? onInit;

  @override
  State<DCLogicTagProvider> createState() => _DCLogicTagProviderState<T>();

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  //
  // 该方法面对 StatefulWidget 时，会依赖当前 widget 的状态，请在 build 方法中使用，
  // 不要在 initState 中使用，否则会抛异常，这是正常的！
  // 如果你一定要在 initState 中取 logicTag，请使用 tag 方法
  static String standardTag(BuildContext context) {
    return DCLogicTagProviderInheritedWidget.standardTag(context);
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static String tag(BuildContext context) {
    return DCLogicTagProviderInheritedWidget.tag(context);
  }
}

class _DCLogicTagProviderState<T> extends State<DCLogicTagProvider> {
  String logicTag = '';

  @override
  void initState() {
    super.initState();

    // 由 DCLogicTag 取值，是为了兼容以前的写法
    logicTag = widget.logicTag ?? DCTool.getUniqueId(count: 10);

    // 把 logicTag 传给外部
    widget.onInit?.call(logicTag);
  }

  @override
  Widget build(BuildContext context) {
    return DCLogicTagProviderInheritedWidget(
      child: widget.child,
      logicTag: logicTag,
    );
  }
}

/// 仅包裹于页面的根视图，其它Widget请不要包裹
///
/// haveCreateTag: 如果你的页面使用了 DCLogicTag.of<T>().newValue 去创建了tag，
///                那么这里需要传 true，内部做了兼容
class DCLogicTagProviderInheritedWidget extends InheritedWidget {
  const DCLogicTagProviderInheritedWidget({
    super.key,
    required super.child,
    required this.logicTag,
  });

  /// 唯一标识
  final String logicTag;

  @override
  bool updateShouldNotify(
      covariant DCLogicTagProviderInheritedWidget oldWidget) {
    return oldWidget.logicTag != logicTag;
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static DCLogicTagProviderInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        DCLogicTagProviderInheritedWidget>();
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static DCLogicTagProviderInheritedWidget? element(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<
        DCLogicTagProviderInheritedWidget>();
    final widget = element?.widget;
    if (widget is! DCLogicTagProviderInheritedWidget) {
      return null;
    }
    return widget;
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  //
  // 该方法面对 StatefulWidget 时，会依赖当前 widget 的状态，请在 build 方法中使用，
  // 不要在 initState 中使用，否则会抛异常，这是正常的！
  // 如果你一定要在 initState 中取 logicTag，请使用 tag 方法
  static String standardTag(BuildContext context) {
    final logicTag = DCLogicTagProviderInheritedWidget.of(context)?.logicTag;
    assert(
      logicTag != null,
      "你的用法有问题, 请确保有正确使用DCLogicTagProvider!",
    );
    return logicTag ?? '';
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static String tag(BuildContext context) {
    final logicTag =
        DCLogicTagProviderInheritedWidget.element(context)?.logicTag;
    assert(
      logicTag != null,
      "你的用法有问题, 请确保有正确使用DCLogicTagProvider!",
    );
    return logicTag ?? '';
  }
}

extension StateDCLogicTag on State {
  /// 获取 dcLag
  ///
  /// 用法: dcLag();
  String dcTag() {
    return DCLogicTagProvider.tag(context);
  }

  /// 获取 tag
  ///
  /// 用法: standardTag();
  String dcStandardTag() {
    return DCLogicTagProvider.standardTag(context);
  }
}

extension BuildContextDCLogicTag on BuildContext {
  /// 获取 tag
  ///
  /// 用法: context.dcLag();
  String dcTag() {
    return DCLogicTagProvider.tag(this);
  }

  /// 获取 tag
  ///
  /// 用法: context.dcStandardTag();
  String dcStandardTag() {
    return DCLogicTagProvider.standardTag(this);
  }
}
