import 'dart:convert';
import 'dart:developer';

// ==== JsonToDart ====

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();

  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    try {
      return json.decode(value.toString()) as T?;
    } catch (e) {
      return null;
    }
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else if ({"": ""} is T) {
        final map = FFConvert.convert<T>(value) ?? <String, dynamic>{};
        return map as T;
      } else if ([] is T) {
        final map = FFConvert.convert<T>(value) ?? [];
        return map as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

// ==== Json2Dart Safe Convert ====

int asInt(Map<String, dynamic>? json, String key, {int defaultValue = 0}) {
  if (json == null || !json.containsKey(key)) return defaultValue;
  var value = json[key];
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is bool) return value ? 1 : 0;
  if (value is String) {
    return int.tryParse(value) ??
        double.tryParse(value)?.toInt() ??
        defaultValue;
  }
  return defaultValue;
}

double asDouble(Map<String, dynamic>? json, String key,
    {double defaultValue = 0.0}) {
  if (json == null || !json.containsKey(key)) return defaultValue;
  var value = json[key];
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool asBool(Map<String, dynamic>? json, String key,
    {bool defaultValue = false}) {
  if (json == null || !json.containsKey(key)) return defaultValue;
  var value = json[key];
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value == 0 ? false : true;
  if (value is double) return value == 0 ? false : true;
  if (value is String) {
    if (value == "1" || value.toLowerCase() == "true") return true;
    if (value == "0" || value.toLowerCase() == "false") return false;
  }
  return defaultValue;
}

String asString(Map<String, dynamic>? json, String key,
    {String defaultValue = ""}) {
  if (json == null || !json.containsKey(key)) return defaultValue;
  var value = json[key];
  if (value == null) return defaultValue;
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toString();
  if (value is bool) return value ? "true" : "false";
  return defaultValue;
}

Map<String, dynamic> asMap(Map<String, dynamic>? json, String key,
    {Map<String, dynamic>? defaultValue}) {
  if (json == null || !json.containsKey(key)) {
    return defaultValue ?? <String, dynamic>{};
  }
  var value = json[key];
  if (value == null) return defaultValue ?? <String, dynamic>{};
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map<String, dynamic>((key, value) => MapEntry("$key", value));
  }
  return defaultValue ?? <String, dynamic>{};
}

List asList(Map<String, dynamic>? json, String key, {List? defaultValue}) {
  if (json == null || !json.containsKey(key)) return defaultValue ?? [];
  var value = json[key];
  if (value == null) return defaultValue ?? [];
  if (value is List) return value;
  return defaultValue ?? [];
}

int? asIntOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) return null;
  var value = json[key];
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is bool) return value ? 1 : 0;
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

double? asDoubleOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) return null;
  var value = json[key];
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) return double.tryParse(value);
  return null;
}

bool? asBoolOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) return null;
  var value = json[key];
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value == 0 ? false : true;
  if (value is double) return value == 0 ? false : true;
  if (value is String) {
    if (value == "1" || value.toLowerCase() == "true") return true;
    if (value == "0" || value.toLowerCase() == "false") return false;
  }
  return null;
}

String? asStringOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) return null;
  var value = json[key];
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toString();
  if (value is bool) return value ? "true" : "false";
  return null;
}

Map<String, dynamic>? asMapOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) {
    return null;
  }
  var value = json[key];
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map<String, dynamic>((key, value) => MapEntry("$key", value));
  }
  return null;
}

List? asListOrNull(Map<String, dynamic>? json, String key) {
  if (json == null || !json.containsKey(key)) return null;
  var value = json[key];
  if (value == null) return null;
  if (value is List) return value;
  return null;
}

/// 将复杂对象转换为可编码的 JSON 结构
Map<String, dynamic> toEncodableJson(Map<String, dynamic> obj) {
  final result = <String, dynamic>{};
  obj.forEach((key, value) {
    if (value is String || value is num || value is bool || value == null) {
      result[key] = value;
    } else if (value is List) {
      result[key] = value.map((e) {
        if (e is String || e is num || e is bool || e == null) {
          return e;
        } else if (e is Map<String, dynamic>) {
          return toEncodableJson(e);
        } else {
          try {
            return json.encode(e);
          } on JsonUnsupportedObjectError catch (e) {
            log('toEncodableJson error with ${e.unsupportedObject.runtimeType}');
            result[key] = value.toString();
          }
        }
      }).toList();
    } else if (value is Map<String, dynamic>) {
      result[key] = toEncodableJson(value);
    } else {
      try {
        result[key] = json.encode(value);
      } on JsonUnsupportedObjectError catch (e) {
        log('toEncodableJson error with ${e.unsupportedObject.runtimeType}');
        result[key] = value.toString();
      }
    }
  });
  return result;
}
