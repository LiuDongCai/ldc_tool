import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ldc_tool/base/light_tracking/core/click_manager.dart';
import 'package:ldc_tool/base/light_tracking/core/define.dart';
import 'package:ldc_tool/base/light_tracking/widget/light_tracking_widget.dart';

class LTGestureDetector extends StatefulWidget {
  /// 元素ID（elementId）
  final String id;

  /// 子部件
  final Widget child;

  /// 需要绑定的数据
  final LTBindData? bindData;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 重写曝光次数（不传为无限）
  final int? overrideTime;

  /// 触发点击回调
  ///
  /// 当满足点击条件时，则会触发回调（不包括处理缓存）
  final LTOnClickTrigger? onTrigger;

  const LTGestureDetector({
    super.key,
    required this.id,
    required this.child,
    this.bindData,
    this.onTap,
    this.overrideTime,
    this.onTrigger,
  });

  @override
  State<LTGestureDetector> createState() => _LTGestureDetectorState();
}

class _LTGestureDetectorState extends State<LTGestureDetector> {
  TLClickManager? clickManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    clickManager = LightTrackingInheritedModel.clickManagerOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 上报点击事件
        clickManager?.report(
          elementId: widget.id,
          bindData: widget.bindData,
          overrideTime: widget.overrideTime,
          onTrigger: widget.onTrigger,
        );
        // 回调外部点击事件
        widget.onTap?.call();
      },
      child: widget.child,
    );
  }
}
