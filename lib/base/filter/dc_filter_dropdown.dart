import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 筛选下拉弹窗工具类
class DCFilterDropdown {
  /// 当前打开的弹窗
  static OverlayEntry? _currentOverlayEntry;
  static Completer<dynamic>? _currentCompleter;

  /// 主题颜色
  static Color themeColor = DCColors.dc42CC8F;

  /// 当前打开的筛选类型标识
  static String? _currentFilterType;

  /// 弹窗状态变化回调列表
  static final List<VoidCallback> _onStateChangedCallbacks = [];

  /// 添加弹窗状态变化监听
  static void addStateChangedListener(VoidCallback callback) {
    _onStateChangedCallbacks.add(callback);
  }

  /// 移除弹窗状态变化监听
  static void removeStateChangedListener(VoidCallback callback) {
    _onStateChangedCallbacks.remove(callback);
  }

  /// 通知状态变化
  static void _notifyStateChanged() {
    for (var callback in _onStateChangedCallbacks) {
      callback();
    }
  }

  /// 关闭当前打开的弹窗（内部方法）
  static void _dismissCurrent() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }
    if (_currentCompleter != null && !_currentCompleter!.isCompleted) {
      _currentCompleter!.complete(null);
      _currentCompleter = null;
    }
    _currentFilterType = null;
    _notifyStateChanged();
  }

  /// 当前是否有筛选弹窗正在打开
  static bool get isFilterDropdownOpen => _currentOverlayEntry != null;

  /// 获取当前打开的筛选类型
  static String? get currentFilterType => _currentFilterType;

  /// 关闭当前打开的筛选弹窗（公共方法，供外部调用）
  static void dismiss() {
    _dismissCurrent();
  }

  /// 在指定位置下方显示筛选弹窗
  static Future<T?> showBelow<T>({
    required BuildContext context,
    required RenderBox anchorBox,
    required Widget child,
    List<FilterTabItem>? leftTabs,
    int? selectedTabIndex,
    ValueChanged<int>? onTabChanged,
    String? filterType,
  }) {
    // 如果点击的是当前已打开的筛选类型，则关闭弹窗
    if (filterType != null && _currentFilterType == filterType) {
      _dismissCurrent();
      return Future<T?>.value(null);
    }

    // 先关闭当前打开的弹窗
    _dismissCurrent();

    // 设置当前筛选类型
    _currentFilterType = filterType;
    _notifyStateChanged();

    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final position = anchorBox.localToGlobal(Offset.zero);
    final anchorHeight = anchorBox.size.height;

    // 计算弹窗位置和大小
    final popupWidth = size.width;

    final completer = Completer<T?>();
    _currentCompleter = completer;

    _currentOverlayEntry = OverlayEntry(
      builder: (context) {
        // 计算遮罩层位置（从弹窗顶部到屏幕底部）
        final popupTop = position.dy + anchorHeight;
        final maskTop = popupTop;
        final maskHeight = size.height - maskTop;

        Widget resultWidget = Stack(
          children: [
            // 遮罩层（只覆盖弹窗下方区域）
            Positioned(
              left: 0,
              top: maskTop,
              width: popupWidth,
              height: maskHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _dismissCurrent(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            // 弹窗内容
            Positioned(
              left: 0,
              top: popupTop,
              width: popupWidth,
              child: Material(
                color: Colors.transparent,
                child: FilterOverlay(
                  child: child,
                  leftTabs: leftTabs,
                  selectedTabIndex: selectedTabIndex,
                  onTabChanged: onTabChanged,
                ),
              ),
            ),
          ],
        );
        return resultWidget;
      },
    );

    overlay.insert(_currentOverlayEntry!);

    // 返回 Future，等待弹窗关闭
    return completer.future;
  }
}
