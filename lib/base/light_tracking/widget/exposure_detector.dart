import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ldc_tool/base/light_tracking/core/define.dart';
import 'package:ldc_tool/base/light_tracking/core/exposure_manager.dart';
import 'package:ldc_tool/base/light_tracking/widget/light_tracking_widget.dart';

class LTExposureDetector extends StatefulWidget {
  /// 元素ID（elementId）
  final String id;

  /// 需要绑定的数据
  final LTBindData? bindData;

  /// 子部件
  final Widget child;

  /// 重写曝光比例
  final LTExposureRatio? overrideRatio;

  /// 重写曝光次数（不传为无限）
  final int? overrideTime;

  /// 触发曝光回调
  ///
  /// 当满足曝光条件时，则会触发回调（不包括处理缓存）
  final LTOnExposureTrigger? onTrigger;

  /// 有效重置记录回调
  ///
  /// 当不满足曝光条件，且未达次数限制时，则会进行重置，有效重复时触发回调
  final LTOnReset? onReset;

  /// 曝光检测间隔
  ///
  /// 注: 请不要在外部使用，仅单元测试使用
  @protected
  @visibleForTesting
  static Duration? exposureDetectionInterval =
      VisibilityDetectorController.instance.updateInterval;

  const LTExposureDetector({
    super.key,
    required this.id,
    required this.child,
    this.bindData,
    this.overrideRatio,
    this.overrideTime,
    this.onTrigger,
    this.onReset,
  });

  @override
  State<LTExposureDetector> createState() => _LTExposureDetectorState();
}

class _LTExposureDetectorState extends State<LTExposureDetector> {
  TLExposureManager? exposureManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    exposureManager = LightTrackingInheritedModel.exposureManagerOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: _buildDetector(),
        ),
      ],
    );
  }

  Widget _buildDetector() {
    return VisibilityDetector(
      // 对于不同的页面，key 需要保持唯一
      key: ValueKey('${exposureManager.hashCode}_${widget.id}'),
      onVisibilityChanged: (info) {
        final visiblePercentage = info.visibleFraction;
        // 上报曝光
        exposureManager?.report(
          elementId: widget.id,
          visiblePercentage: visiblePercentage,
          bindData: widget.bindData,
          overrideRatio: widget.overrideRatio,
          overrideTime: widget.overrideTime,
          onTrigger: widget.onTrigger,
          onReset: widget.onReset,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
