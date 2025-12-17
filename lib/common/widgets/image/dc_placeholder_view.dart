import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/widgets/image/dc_cached_image.dart';
import 'package:ldc_tool/common/widgets/image/dc_image.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

/// 当前设备分辨率
double get _pixelRatio => ScreenUtil().pixelRatio ?? 3;

/// 计算缓存尺寸
int? _cacheSize(double? size) {
  if (size == null) return null;
  return (size * _pixelRatio).round();
}

/// 默认占位图
class DCPlaceHolderView extends StatelessWidget {
  final BoxFit? fit;

  /// 如果空話默認使用 Assets.image.common.nhPlaceholder
  final String? placeholderImagePath;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 指定解析图片的宽（让 flutter 引擎以指定大小解析图片，减少内存消耗）
  final double? cacheWidth;

  int? get _cacheWidth => _cacheSize(cacheWidth);

  /// 指定解析图片的高（让 flutter 引擎以指定大小解析图片，减少内存消耗）
  final double? cacheHeight;

  int? get _cacheHeight => _cacheSize(cacheHeight);

  final AlignmentGeometry alignment;

  /// 通用占用图的像素: 375 × 281
  Size get _sizeOfCommonPlaceholder {
    return const Size(375, 281);
  }

  const DCPlaceHolderView({
    Key? key,
    this.fit = BoxFit.cover,
    this.placeholderImagePath,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DCImage.asset(
      placeholderImagePath ?? Assets.image.common.dcCommonError.path,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: _cacheWidth ?? _sizeOfCommonPlaceholder.width.round(),
      cacheHeight: _cacheHeight ?? _sizeOfCommonPlaceholder.height.round(),
      alignment: alignment,
    );
  }
}

class DCCachedNetworkImagePlaceHolderView extends StatelessWidget {
  final BoxFit? fit;

  final String? placeholderImagePath;

  final String? errorPlaceholderImagePath;

  final String imageUrl;

  final Widget? placeholder;

  final double? width;

  final double? height;

  const DCCachedNetworkImagePlaceHolderView(
    this.imageUrl, {
    Key? key,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.width,
    this.height,

    /// 錯誤圖片
    this.errorPlaceholderImagePath,
    this.placeholderImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DCCachedImage(
      imageUrl,
      placeholder: placeholder ??
          DCPlaceHolderView(
            placeholderImagePath: placeholderImagePath,
          ),
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      errorWidget: DCPlaceHolderView(
        placeholderImagePath: errorPlaceholderImagePath ?? placeholderImagePath,
      ),
    );
  }
}
