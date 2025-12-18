/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImageGen {
  const $AssetsImageGen();

  /// Directory path: assets/image/common
  $AssetsImageCommonGen get common => const $AssetsImageCommonGen();

  /// Directory path: assets/image/eat
  $AssetsImageEatGen get eat => const $AssetsImageEatGen();
}

class $AssetsImageCommonGen {
  const $AssetsImageCommonGen();

  /// File path: assets/image/common/dc_common_error.png
  AssetGenImage get dcCommonError =>
      const AssetGenImage('assets/image/common/dc_common_error.png');

  /// List of all assets
  List<AssetGenImage> get values => [dcCommonError];
}

class $AssetsImageEatGen {
  const $AssetsImageEatGen();

  /// File path: assets/image/eat/eat_banner1.png
  AssetGenImage get eatBanner1 =>
      const AssetGenImage('assets/image/eat/eat_banner1.png');

  /// File path: assets/image/eat/eat_banner2.png
  AssetGenImage get eatBanner2 =>
      const AssetGenImage('assets/image/eat/eat_banner2.png');

  /// File path: assets/image/eat/eat_banner3.png
  AssetGenImage get eatBanner3 =>
      const AssetGenImage('assets/image/eat/eat_banner3.png');

  /// List of all assets
  List<AssetGenImage> get values => [eatBanner1, eatBanner2, eatBanner3];
}

class Assets {
  const Assets._();

  static const $AssetsImageGen image = $AssetsImageGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
