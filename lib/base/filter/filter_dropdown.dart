import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';

/// 筛选下拉弹窗工具类
class FilterDropdown {
  /// 当前打开的弹窗
  static OverlayEntry? _currentOverlayEntry;
  static Completer<dynamic>? _currentCompleter;

  /// 当前打开的筛选类型标识
  static String? _currentFilterType;

  /// 关闭当前打开的弹窗
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
  }

  /// 在指定位置下方显示筛选弹窗
  static Future<T?> showBelow<T>({
    required BuildContext context,
    required RenderBox anchorBox,
    String? title,
    required Widget child,
    bool showReset = true,
    bool showConfirm = true,
    String resetText = '重置',
    String confirmText = '确定',
    VoidCallback? onReset,
    VoidCallback? onConfirm,
    List<FilterTabItem>? leftTabs,
    int? selectedTabIndex,
    ValueChanged<int>? onTabChanged,
    double? maxHeight,
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

    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final position = anchorBox.localToGlobal(Offset.zero);
    final anchorHeight = anchorBox.size.height;

    // 计算弹窗位置和大小
    final availableHeight = size.height - position.dy - anchorHeight;
    final popupHeight =
        maxHeight ?? (availableHeight * 0.6).clamp(200.0, 600.0);
    final popupWidth = size.width;

    T? result;
    final completer = Completer<T?>();
    _currentCompleter = completer;

    void dismiss([T? value]) {
      result = value;
      if (_currentOverlayEntry != null) {
        _currentOverlayEntry!.remove();
        _currentOverlayEntry = null;
      }
      _currentFilterType = null;
      if (!completer.isCompleted) {
        completer.complete(value);
        _currentCompleter = null;
      }
    }

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
                onTap: () => dismiss(null),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            // 弹窗内容
            Positioned(
              left: 0,
              top: popupTop,
              width: popupWidth,
              height: popupHeight,
              child: Material(
                color: Colors.transparent,
                child: FilterOverlay(
                  title: title,
                  child: child,
                  showReset: showReset,
                  showConfirm: showConfirm,
                  resetText: resetText,
                  confirmText: confirmText,
                  customHeight: popupHeight,
                  onReset: onReset,
                  onConfirm: () {
                    onConfirm?.call();
                    dismiss(result);
                  },
                  onClose: () => dismiss(null),
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
