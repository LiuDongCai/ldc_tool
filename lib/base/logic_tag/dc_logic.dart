part of dc_logic_tag;

typedef DCLogicCreate<T extends GetxController> = T Function();

/// 获取 logic
///
/// 用法: DCLogic.of<MyGetxLogic>(context);
class DCLogic {
  /// 获取 logic
  ///
  /// 对应 DCLogicTagProvider.standardTag
  /// 注: 请仅在 build 方法中使用，不要在 initState/dispose 方法中使用，会报错！
  static T standardOf<T extends GetxController>(BuildContext context) {
    final tag = DCLogicTagProviderInheritedWidget.standardTag(context);
    return Get.find<T>(tag: tag);
  }

  /// 获取 logic
  ///
  /// 对应 DCLogicTagProvider.tag
  /// 注: 请不要在 dispose 方法中使用，会报错！
  static T of<T extends GetxController>(BuildContext context) {
    final tag = DCLogicTagProviderInheritedWidget.tag(context);
    return Get.find<T>(tag: tag);
  }
}

/// 用于提供 logic 的 Widget
class DCLogicProvider<T extends GetxController> extends StatefulWidget {
  const DCLogicProvider({
    super.key,
    required this.child,
    this.logicTag,
    this.initLogic,
    this.onDispose,
    @Deprecated('请不要使用这个参数') this.createLogicFn,
  });

  const DCLogicProvider.put(
    this.createLogicFn, {
    super.key,
    required this.child,
    this.logicTag,
    this.onDispose,
    @Deprecated('请不要使用这个参数') this.initLogic,
  });

  final Widget child;

  final String? logicTag;

  final T Function(String tag)? initLogic;

  final Function(BuildContext context, T? logic, String logicTag)? onDispose;

  final DCLogicCreate<T>? createLogicFn;

  @override
  State<DCLogicProvider> createState() => _DCLogicProviderState<T>();
}

class _DCLogicProviderState<T extends GetxController>
    extends State<DCLogicProvider<T>> {
  /// 记录当前的 logic
  T? logic;

  /// 记录当前的 logicTag
  late String logicTag;

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DCLogicTagProvider<T>(
      child: widget.child,
      logicTag: widget.logicTag,
      onInit: (tag) {
        logicTag = tag;

        T? _logic;
        if (widget.createLogicFn != null) {
          _logic = widget.createLogicFn!();
        } else if (widget.initLogic != null) {
          _logic = widget.initLogic!(tag);
        }

        if (_logic == null) return;
        logic = Get.put<T>(
          _logic,
          tag: tag,
        );
      },
    );
  }
}

mixin DCLogicPutStateMixin<T extends GetxController, W extends StatefulWidget>
    on State<W> implements DCLogicPutStateMixinBuilder<T> {
  /// 记录当前的 logic
  late T logic;

  /// 记录当前的 logicTag
  late String logicTag;

  /// 同步 ticker
  void _syncTicker(
    bool tickingEnabled,
    BuildContext ctx,
  ) {
    if (!mounted) return;
    // print('tickingEnabled: $tickingEnabled logic: $logic');
    if (logic is GetTickerProviderStateMixin) {
      final _logic = logic as GetTickerProviderStateMixin;
      _logic.didChangeDependencies(ctx);
    } else if (logic is GetSingleTickerProviderStateMixin) {
      final _logic = logic as GetSingleTickerProviderStateMixin;
      _logic.didChangeDependencies(ctx);
    }
  }

  @override
  String? dcCustomLogicTag() {
    return null;
  }

  @override
  void initState() {
    super.initState();

    logicTag = dcCustomLogicTag.call() ?? DCTool.getUniqueId(count: 10);
    logic = dcInitLogic();

    // 在这里 put，logic 的 onInit 方法就会走 这样在使用时就可以在 initState 里放心使用
    // logic.onInit 里初始化的数据了
    Get.put<T>(
      logic,
      tag: logicTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = DCLogicTagProvider<T>(
      child: dcBuildBody(context),
      logicTag: logicTag,
    );

    // 同步 ticker
    resultWidget = Stack(
      children: [
        resultWidget,
        Positioned(
          left: 0,
          top: 0,
          child: DCLogicPutSyncTickerProvider(
            onTickerSync: _syncTicker,
          ),
        ),
      ],
    );

    return resultWidget;
  }
}

/// 同步 ticker 状态
class DCLogicPutSyncTickerProvider extends StatelessWidget {
  final void Function(
    bool tickingEnabled,
    BuildContext ctx,
  ) onTickerSync;

  const DCLogicPutSyncTickerProvider({
    super.key,
    required this.onTickerSync,
  });

  @override
  Widget build(BuildContext context) {
    final tickingEnabled = TickerMode.of(context);
    onTickerSync(
      tickingEnabled,
      context,
    );
    return const SizedBox.shrink();
  }
}

abstract class DCLogicPutStateMixinBuilder<T extends GetxController> {
  /// 初始化 logic
  T dcInitLogic();

  /// 自定义 logicTag
  String? dcCustomLogicTag();

  /// 构建 body
  Widget dcBuildBody(BuildContext context);
}

class DCLogicConsumer<T extends GetxController> extends StatefulWidget {
  const DCLogicConsumer.get(
    this.createLogicFn, {
    super.key,
    required this.builder,
    this.onInitState,
    this.onDispose,
  });

  final DCLogicCreate<T>? createLogicFn;

  final Widget Function(BuildContext context, T logic, String logicTag) builder;

  final Function(BuildContext context, T logic, String logicTag)? onInitState;

  final Function(BuildContext context, T logic, String logicTag)? onDispose;

  @override
  State<DCLogicConsumer> createState() => _DCLogicConsumerState<T>();
}

class _DCLogicConsumerState<T extends GetxController>
    extends State<DCLogicConsumer<T>>
    with DCLogicConsumerStateMixin<T, DCLogicConsumer<T>> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context, logic, logicTag);
  }

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, logic, logicTag);
  }
}

mixin DCLogicConsumerStateMixin<T extends GetxController,
    W extends StatefulWidget> on State<W> {
  /// 记录当前的 logic
  late T logic;

  /// 记录当前的 logicTag
  late String logicTag;

  @override
  void initState() {
    super.initState();

    logicTag = dcTag();
    logic = dcLogic<T>();
  }
}

extension StateDCLogic on State {
  /// 获取 logic
  ///
  /// 用法: logic<MyGetxLogic>();
  T dcLogic<T extends GetxController>() {
    return DCLogic.of<T>(context);
  }

  /// 获取 logic
  ///
  /// 用法: standardLogic<MyGetxLogic>();
  T dcStandardLogic<T extends GetxController>() {
    return DCLogic.standardOf<T>(context);
  }
}

extension BuildContextDCLogic on BuildContext {
  /// 获取 logic
  ///
  /// 用法: context.logic<MyGetxLogic>();
  T dcLogic<T extends GetxController>() {
    return DCLogic.of<T>(this);
  }

  /// 获取 logic
  ///
  /// 用法: context.standardLogic<MyGetxLogic>();
  T dcStandardLogic<T extends GetxController>() {
    return DCLogic.standardOf<T>(this);
  }
}
