import 'package:flutter/material.dart';
import 'package:ldc_tool/base/light_tracking/core/click_manager.dart';
import 'package:ldc_tool/base/light_tracking/core/exposure_manager.dart';

class LightTrackingProvider extends StatefulWidget {
  const LightTrackingProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LightTrackingProvider> createState() => _LightTrackingProviderState();
}

class _LightTrackingProviderState extends State<LightTrackingProvider> {
  // ==================== 存储管理对象 ====================

  /// 曝光管理对象
  final _exposureManager = TLExposureManager();

  /// 点击管理对象
  final _clickManager = TLClickManager();

  @override
  void dispose() {
    _exposureManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightTrackingInheritedModel(
      exposureManager: _exposureManager,
      clickManager: _clickManager,
      child: widget.child,
    );
  }
}

enum LightTrackingProviderAspect {
  // 曝光管理对象
  exposureManager,
  // 点击管理对象
  clickManager,
}

class LightTrackingInheritedModel
    extends InheritedModel<LightTrackingProviderAspect> {
  const LightTrackingInheritedModel({
    super.key,
    required super.child,
    required this.exposureManager,
    required this.clickManager,
  });

  /// 曝光管理对象
  final TLExposureManager exposureManager;

  /// 点击管理对象
  final TLClickManager clickManager;

  static LightTrackingInheritedModel? _of(
    BuildContext context, [
    LightTrackingProviderAspect? aspect,
  ]) {
    final provider = InheritedModel.inheritFrom<LightTrackingInheritedModel>(
      context,
      aspect: aspect,
    );
    assert(
      provider != null,
      "请正确使用 LightTrackingProvider !",
    );
    return provider;
  }

  /// 获取曝光管理对象
  static TLExposureManager exposureManagerOf(BuildContext context) {
    return _of(
          context,
          LightTrackingProviderAspect.exposureManager,
        )?.exposureManager ??
        TLExposureManager();
  }

  /// 获取点击管理对象
  static TLClickManager clickManagerOf(BuildContext context) {
    return _of(
          context,
          LightTrackingProviderAspect.clickManager,
        )?.clickManager ??
        TLClickManager();
  }

  @override
  bool updateShouldNotify(
    covariant LightTrackingInheritedModel oldWidget,
  ) {
    return exposureManager != oldWidget.exposureManager;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant LightTrackingInheritedModel oldWidget,
    Set<LightTrackingProviderAspect> dependencies,
  ) {
    return dependencies.any(
      (LightTrackingProviderAspect dependency) => switch (dependency) {
        LightTrackingProviderAspect.exposureManager =>
          exposureManager != oldWidget.exposureManager,
        LightTrackingProviderAspect.clickManager =>
          clickManager != oldWidget.clickManager,
      },
    );
  }
}
