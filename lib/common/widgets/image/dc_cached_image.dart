import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ldc_tool/common/util/dc_log.dart';
import 'package:ldc_tool/common/widgets/image/dc_placeholder_view.dart';

class DCCachedImage extends StatelessWidget {
  const DCCachedImage(
    this.imageUrl, {
    super.key,
    this.headers,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.clearMemoryCacheWhenDispose = true,
    this.onLoading,
    this.onLoadCompleted,
    this.onLoadFailed,
  });

  /// 预加载图片
  static Future<bool> precacheCachedImage({
    required BuildContext context,
    required String url,
  }) async {
    try {
      await precacheImage(
        ExtendedNetworkImageProvider(url),
        context,
      );
      return true;
    } catch (e) {
      DCLog.e('预加载图片失败: $e');
      return false;
    }
  }

  final String imageUrl;

  final Map<String, String>? headers;

  final double? width;

  final double? height;

  final Color? color;

  final BlendMode? colorBlendMode;

  final BoxFit fit;

  final Widget? placeholder;

  final Widget? errorWidget;

  final bool clearMemoryCacheWhenDispose;

  final VoidCallback? onLoading;

  final VoidCallback? onLoadCompleted;

  final VoidCallback? onLoadFailed;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: placeholder ?? _defaultPlaceholder(),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: ExtendedImage.network(
        imageUrl,
        headers: headers,
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              onLoading?.call();
              return placeholder ?? _defaultPlaceholder();
            case LoadState.completed:
              onLoadCompleted?.call();
              return state.completedWidget;
            case LoadState.failed:
              onLoadFailed?.call();
              return errorWidget ?? _defaultPlaceholder();
          }
        },
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return const DCPlaceHolderView(
      fit: BoxFit.cover,
    );
  }
}
