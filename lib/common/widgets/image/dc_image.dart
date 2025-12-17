import 'package:extended_image_library/extended_image_library.dart' show File;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

// 参数提供尽量与官方 Image 中的保持一致，不要新增第三方库新增的参数，方便日后替换

enum DCImageLoadType {
  asset,
  file,
}

class DCImageMacro {
  static const String noUseTip = '不要使用这个参数';
  static const double defaultScale = 1.0;
}

/// 有助于性能优化
class DCImage extends StatefulWidget {
  const DCImage.asset(
    String name, {
    super.key,
    this.bundle,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.scale,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    // 设置成true，可以避免图片加载时的闪烁
    // https://github.com/fluttercandies/extended_image/issues/502
    this.gaplessPlayback = true,
    this.isAntiAlias = false,
    this.package,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.clearMemoryCacheWhenDispose = true,
    @Deprecated(DCImageMacro.noUseTip) this.loadType = DCImageLoadType.asset,
    @Deprecated(DCImageMacro.noUseTip) File? file,
  })  : _file = file,
        _name = name;

  const DCImage.file(
    File file, {
    super.key,
    this.scale = DCImageMacro.defaultScale,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    // 设置成true，可以避免图片加载时的闪烁
    // https://github.com/fluttercandies/extended_image/issues/502
    this.gaplessPlayback = true,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.clearMemoryCacheWhenDispose = true,
    @Deprecated(DCImageMacro.noUseTip) this.loadType = DCImageLoadType.file,
    @Deprecated(DCImageMacro.noUseTip) String? name,
    @Deprecated(DCImageMacro.noUseTip) this.bundle,
    @Deprecated(DCImageMacro.noUseTip) this.package,
  })  : _name = name,
        _file = file;

  final DCImageLoadType loadType;
  final String? _name;
  final File? _file;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final AssetBundle? bundle;
  final double? scale;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final String? package;
  final FilterQuality filterQuality;
  final int? cacheWidth;
  final int? cacheHeight;
  final bool clearMemoryCacheWhenDispose;

  @override
  State<DCImage> createState() => _DCImageState();
}

class _DCImageState extends State<DCImage> {
  @override
  Widget build(BuildContext context) {
    switch (widget.loadType) {
      case DCImageLoadType.asset:
        assert(widget._name != null, 'name 不能为空');
        return ExtendedImage.asset(
          widget._name ?? '',
          bundle: widget.bundle,
          semanticLabel: widget.semanticLabel,
          excludeFromSemantics: widget.excludeFromSemantics,
          scale: widget.scale,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          opacity: widget.opacity,
          colorBlendMode: widget.colorBlendMode,
          fit: widget.fit,
          alignment: widget.alignment,
          repeat: widget.repeat,
          centerSlice: widget.centerSlice,
          matchTextDirection: widget.matchTextDirection,
          gaplessPlayback: widget.gaplessPlayback,
          isAntiAlias: widget.isAntiAlias,
          package: widget.package,
          filterQuality: widget.filterQuality,
          cacheWidth: widget.cacheWidth,
          cacheHeight: widget.cacheHeight,
          clearMemoryCacheWhenDispose: widget.clearMemoryCacheWhenDispose,
        );
      case DCImageLoadType.file:
        assert(widget._file != null, 'file 不能为空');
        return ExtendedImage.file(
          widget._file ?? File(''),
          scale: widget.scale ?? DCImageMacro.defaultScale,
          semanticLabel: widget.semanticLabel,
          excludeFromSemantics: widget.excludeFromSemantics,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          opacity: widget.opacity,
          colorBlendMode: widget.colorBlendMode,
          fit: widget.fit,
          alignment: widget.alignment,
          repeat: widget.repeat,
          centerSlice: widget.centerSlice,
          matchTextDirection: widget.matchTextDirection,
          gaplessPlayback: widget.gaplessPlayback,
          isAntiAlias: widget.isAntiAlias,
          filterQuality: widget.filterQuality,
          cacheWidth: widget.cacheWidth,
          cacheHeight: widget.cacheHeight,
          clearMemoryCacheWhenDispose: widget.clearMemoryCacheWhenDispose,
        );
    }
  }
}
