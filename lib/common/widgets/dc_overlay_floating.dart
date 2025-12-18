import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 页面内可拖动的悬浮窗，允许被其他视图遮挡～
class DCOverlayFloating extends StatefulWidget {
  /// 子组件(被拖拽的视图)
  final Widget child;

  /// 视图宽度
  final double width;

  /// 视图高度
  final double height;

  /// 点击回调
  final GestureTapCallback? onTap;

  /// 父组件宽度
  final double? parentWidth;

  /// 父组件高度
  final double? parentHeight;

  /// 初始位置偏移量
  final Offset? offset;

  /// 离左侧的距离
  final double left;

  /// 离顶部的距离
  final double top;

  /// 离右侧的距离
  final double right;

  /// 离底部的距离
  final double bottom;

  /// 偏移量回调
  final Function(Offset offset)? onOffsetChanged;

  const DCOverlayFloating({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.onTap,
    this.parentHeight,
    this.parentWidth,
    this.offset,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.onOffsetChanged,
  });

  @override
  DCOverlayFloatingState createState() => DCOverlayFloatingState();
}

class DCOverlayFloatingState extends State<DCOverlayFloating> {
  Widget? get child => widget.child;

  double get width => widget.width;

  double get height => widget.height;

  double get parentWidth => widget.parentWidth ?? 1.sw;

  double get parentHeight => widget.parentHeight ?? 1.sh;

  double get left => widget.left;

  double get top => widget.top;

  double get right => widget.right;

  double get bottom => widget.bottom;

  Offset _offset = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _offset = widget.offset ?? _offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onTap: widget.onTap,
        onPanUpdate: (detail) {
          setState(() {
            _offset = _calOffset(_offset, detail.delta);
          });
        },
        onPanEnd: (detail) {
          setState(
            () {
              double dy = _offset.dy;
              if (_offset.dy < top) {
                dy = top;
              } else if (_offset.dy > parentHeight - height - bottom) {
                dy = parentHeight - height - bottom;
              }
              // 移动位置小于父组件宽度一半，吸附在左侧
              if (_offset.dx < parentWidth / 2 - width / 2) {
                _offset = Offset(left, dy);
              } else {
                // 移动位置大于父组件宽度一半，吸附在右侧
                _offset = Offset(parentWidth - width - right, dy);
              }
            },
          );
          widget.onOffsetChanged?.call(_offset);
        },
        child: child,
      ),
    );
  }

  /// 计算偏移量
  Offset _calOffset(Offset offset, Offset nextOffset) {
    double dx = 0;
    // 水平方向偏移量不能小于0不能大于父级组件宽度
    if (offset.dx + nextOffset.dx <= 0) {
      dx = 0;
    } else if (offset.dx + nextOffset.dx >= (parentWidth - width)) {
      dx = parentWidth - width;
    } else {
      dx = offset.dx + nextOffset.dx;
    }
    double dy = 0;
    // 垂直方向偏移量不能小于0不能大于父级组件高度
    if (offset.dy + nextOffset.dy >= (parentHeight - height)) {
      dy = parentHeight - height;
    } else if (offset.dy + nextOffset.dy <= 0) {
      dy = 0;
    } else {
      dy = offset.dy + nextOffset.dy;
    }
    return Offset(
      dx,
      dy,
    );
  }
}
