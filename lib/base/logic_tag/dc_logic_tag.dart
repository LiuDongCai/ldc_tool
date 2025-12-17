library dc_logic_tag;

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/util/dc_tool.dart';

part 'dc_logic.dart';
part 'dc_logic_tag_provider.dart';

class DCLogicTag<T> {
  static final Map<String, List<String>> _tagStack = {};

  static final Map<int, String> _logicTagStack = {};

  static DCLogicTag of<T>({
    dynamic logic,
    BuildContext? context,
  }) {
    return DCLogicTag<T>._(
      logicKey: logic?.hashCode,
      context: context,
    );
  }

  DCLogicTag._({
    this.logicKey,
    this.context,
  });

  int? logicKey;

  BuildContext? context;

  // "${T}" 的警告不用理会 https://stackoverflow.com/questions/55835258/get-the-name-of-a-dart-class-as-a-type-or-string
  String get _tagKey => "$T${T.hashCode}";

  /// 获取tag value，用于在各种地方获取controller的时候，比如Get.find(tag:) / GetBuilder(tag:)
  String? get value {
    if (context != null) {
      final contextLogicTag =
          DCLogicTagProviderInheritedWidget.of(context!)?.logicTag;
      if (contextLogicTag != null) {
        return contextLogicTag;
      }
    }
    if (logicKey != null) {
      final val = _logicTagStack[logicKey!];
      if (val != null) {
        return val;
      }
    }
    var values = _tagStack[_tagKey] ?? [];
    // 兼容异常情况
    assert(values.isNotEmpty);
    if (values.isEmpty) {
      return newValue;
    }
    var val = values.last;
    return val;
  }

  /// 创建新的tag value，用在Get.put(tag:)的时候
  String? get newValue {
    var newVal = "${_tagKey}_${Random().nextInt(100000).toString()}";
    var values = _tagStack[_tagKey] ?? [];
    values.add(newVal);
    _tagStack[_tagKey] = values;
    if (logicKey != null) {
      _logicTagStack[logicKey!] = newVal;
    }
    return newVal;
  }

  /// 在controller onClose里调用/或者页面dispose
  void dispose() {
    var values = _tagStack[_tagKey];
    if (values == null) {
      return;
    }

    if (values.isNotEmpty) {
      if (logicKey != null) {
        final value = _logicTagStack[logicKey];
        values.remove(value);
        _logicTagStack.remove(logicKey);
      } else {
        values.removeLast();
      }
    }
  }
}
