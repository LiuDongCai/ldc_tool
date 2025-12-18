import 'package:hive_ce/hive_ce.dart';
import 'package:ldc_tool/common/util/dc_log.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// 缓存组件
/// 基于 Hive CE 封装的本地缓存工具类
/// 支持多 Box（命名空间）管理，提供便捷的 CRUD 操作
/// 支持设置过期时间
class DCCache {
  DCCache._();

  static final DCCache _instance = DCCache._();

  /// 获取单例实例
  static DCCache get instance => _instance;

  /// 是否已初始化
  bool _isInitialized = false;

  /// 已打开的 Box 缓存
  final Map<String, Box> _boxes = {};

  /// 默认 Box 名称
  static const String _defaultBoxName = 'dc_cache_default';

  /// 初始化缓存
  /// 需要在应用启动时调用，通常在 main.dart 中调用
  /// [path] 可选，指定 Hive 数据存储路径，不传则自动使用应用文档目录
  Future<void> init({String? path}) async {
    if (_isInitialized) {
      DCLog.w('DCCache 已经初始化，跳过重复初始化');
      return;
    }

    try {
      String finalPath;
      if (path != null) {
        finalPath = path;
      } else {
        // 自动获取应用文档目录
        final directory = await getApplicationDocumentsDirectory();
        finalPath = directory.path;
        DCLog.d('DCCache 自动获取应用文档目录: $finalPath');
      }

      // 确保目录存在
      final dir = Directory(finalPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        DCLog.d('DCCache 创建目录: $finalPath');
      }

      Hive.init(finalPath);
      _isInitialized = true;
      DCLog.i('DCCache 初始化成功，路径: $finalPath');

      // 自动打开默认 Box，方便后续使用
      await _openBox();
    } catch (e, stackTrace) {
      _isInitialized = false;
      DCLog.e(
        'DCCache 初始化失败',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 打开 Box（如果已打开则直接返回）
  /// [boxName] Box 名称，用于区分不同的缓存命名空间
  /// 如果不传则使用默认 Box
  Future<Box> _openBox({String? boxName}) async {
    if (!_isInitialized) {
      throw Exception('DCCache 未初始化，请先调用 init() 方法');
    }

    final name = boxName ?? _defaultBoxName;

    // 如果 Box 已经打开，直接返回
    if (_boxes.containsKey(name)) {
      return _boxes[name]!;
    }

    try {
      final box = await Hive.openBox(name);
      _boxes[name] = box;
      DCLog.d('DCCache 打开 Box: $name');
      return box;
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 打开 Box 失败: $name',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 存储数据
  /// [key] 存储的键
  /// [value] 存储的值（支持 Hive 支持的所有类型）
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// [expireDuration] 可选，过期时长（从当前时间开始计算），不传则永不过期
  /// [expireAt] 可选，过期时间点，不传则永不过期
  /// 注意：expireDuration 和 expireAt 同时设置时，expireAt 优先级更高
  Future<void> put(
    String key,
    dynamic value, {
    String? boxName,
    Duration? expireDuration,
    DateTime? expireAt,
  }) async {
    try {
      final box = await _openBox(boxName: boxName);

      // 计算过期时间戳
      int? expireTimestamp;
      if (expireAt != null) {
        expireTimestamp = expireAt.millisecondsSinceEpoch;
      } else if (expireDuration != null) {
        expireTimestamp =
            DateTime.now().add(expireDuration).millisecondsSinceEpoch;
      }

      // 如果有过期时间，使用包装类存储
      if (expireTimestamp != null) {
        final cacheItem = _CacheItem(
          value: value,
          expireAt: expireTimestamp,
        );
        await box.put(key, cacheItem.toMap());
        DCLog.d(
            'DCCache 存储数据（带过期时间）: $key, 过期时间: ${DateTime.fromMillisecondsSinceEpoch(expireTimestamp)}');
      } else {
        // 没有过期时间，直接存储
        await box.put(key, value);
        DCLog.d('DCCache 存储数据: $key');
      }
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 存储数据失败: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 检查并解析缓存值（处理过期时间）
  /// 返回解析后的值，如果过期则返回 null
  dynamic _parseCacheValue(
    dynamic value,
    String key,
    Box box,
  ) {
    // 检查是否是带过期时间的格式（Map 且包含 expireAt）
    if (value is Map && value.containsKey('expireAt')) {
      try {
        final cacheItem = _CacheItem.fromMap(value);
        if (cacheItem.isExpired) {
          // 数据已过期，删除并返回 null
          box.delete(key);
          DCLog.d('DCCache 数据已过期并删除: $key');
          return null;
        }
        // 数据未过期，返回实际值
        return cacheItem.value;
      } catch (e) {
        DCLog.w('DCCache 解析过期数据失败: $key, 返回原始值');
        return value;
      }
    }
    // 不是带过期时间的格式，直接返回
    return value;
  }

  /// 读取数据（同步方法）
  /// [key] 读取的键
  /// [defaultValue] 可选，如果键不存在时返回的默认值
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回存储的值，如果不存在或已过期则返回 null 或 defaultValue
  /// 注意：如果 Box 未打开，会返回 defaultValue，建议先调用 put 方法或使用 getAsync 方法
  T? get<T>(
    String key, {
    T? defaultValue,
    String? boxName,
  }) {
    try {
      final box = _boxes[boxName ?? _defaultBoxName];
      if (box == null) {
        DCLog.w(
            'DCCache Box 未打开: ${boxName ?? _defaultBoxName}，返回默认值。建议先调用 put 方法或使用 getAsync 方法');
        return defaultValue;
      }

      final rawValue = box.get(key);
      if (rawValue == null) {
        DCLog.d('DCCache 读取数据为空: $key');
        return defaultValue;
      }

      // 检查并处理过期时间
      final value = _parseCacheValue(rawValue, key, box);
      if (value == null) {
        return defaultValue;
      }

      // 类型转换
      if (value is T) {
        return value;
      }

      DCLog.w('DCCache 类型不匹配: $key, 期望: $T, 实际: ${value.runtimeType}');
      return defaultValue;
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 读取数据失败: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  /// 读取数据（异步方法，会自动打开 Box）
  /// [key] 读取的键
  /// [defaultValue] 可选，如果键不存在时返回的默认值
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回存储的值，如果不存在或已过期则返回 null 或 defaultValue
  /// 如果 Box 未打开，会自动打开后再读取
  Future<T?> getAsync<T>(
    String key, {
    T? defaultValue,
    String? boxName,
  }) async {
    try {
      final box = await _openBox(boxName: boxName);
      final rawValue = box.get(key);
      if (rawValue == null) {
        DCLog.d('DCCache 读取数据为空: $key');
        return defaultValue;
      }

      // 检查并处理过期时间
      final value = _parseCacheValue(rawValue, key, box);
      if (value == null) {
        return defaultValue;
      }

      // 类型转换
      if (value is T) {
        return value;
      }

      DCLog.w('DCCache 类型不匹配: $key, 期望: $T, 实际: ${value.runtimeType}');
      return defaultValue;
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 读取数据失败: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  /// 删除数据
  /// [key] 要删除的键
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  Future<void> delete(
    String key, {
    String? boxName,
  }) async {
    try {
      final box = await _openBox(boxName: boxName);
      await box.delete(key);
      DCLog.d('DCCache 删除数据: $key');
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 删除数据失败: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 清空 Box 中的所有数据
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  Future<void> clear({String? boxName}) async {
    try {
      final box = await _openBox(boxName: boxName);
      await box.clear();
      DCLog.d('DCCache 清空数据: ${boxName ?? _defaultBoxName}');
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 清空数据失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 检查键是否存在
  /// [key] 要检查的键
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回 true 表示存在，false 表示不存在
  bool containsKey(
    String key, {
    String? boxName,
  }) {
    try {
      final box = _boxes[boxName ?? _defaultBoxName];
      if (box == null) {
        return false;
      }
      return box.containsKey(key);
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 检查键失败: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// 获取 Box 中的所有键
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回键的列表
  List<String> getAllKeys({String? boxName}) {
    try {
      final box = _boxes[boxName ?? _defaultBoxName];
      if (box == null) {
        return [];
      }
      return box.keys.cast<String>().toList();
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 获取所有键失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// 获取 Box 中所有键值对的数量
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回键值对的数量
  int getLength({String? boxName}) {
    try {
      final box = _boxes[boxName ?? _defaultBoxName];
      if (box == null) {
        return 0;
      }
      return box.length;
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 获取长度失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  /// 关闭 Box
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 关闭后需要重新打开才能使用
  Future<void> closeBox({String? boxName}) async {
    try {
      final name = boxName ?? _defaultBoxName;
      final box = _boxes[name];
      if (box != null) {
        await box.close();
        _boxes.remove(name);
        DCLog.d('DCCache 关闭 Box: $name');
      }
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 关闭 Box 失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 关闭所有 Box
  Future<void> closeAllBoxes() async {
    try {
      final boxNames = _boxes.keys.toList();
      for (final name in boxNames) {
        await closeBox(boxName: name);
      }
      DCLog.d('DCCache 关闭所有 Box');
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 关闭所有 Box 失败',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 删除 Box（物理删除文件）
  /// [boxName] Box 名称
  /// 删除后需要重新打开才能使用
  Future<void> deleteBox(String boxName) async {
    try {
      // 先关闭 Box
      await closeBox(boxName: boxName);
      // 删除 Box 文件
      await Hive.deleteBoxFromDisk(boxName);
      DCLog.d('DCCache 删除 Box: $boxName');
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 删除 Box 失败: $boxName',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 清理过期数据
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回清理的过期数据数量
  Future<int> clearExpired({String? boxName}) async {
    try {
      final box = await _openBox(boxName: boxName);
      int clearedCount = 0;
      final keys = box.keys.toList();

      for (final key in keys) {
        final rawValue = box.get(key);
        if (rawValue is Map && rawValue.containsKey('expireAt')) {
          try {
            final cacheItem = _CacheItem.fromMap(rawValue);
            if (cacheItem.isExpired) {
              await box.delete(key);
              clearedCount++;
            }
          } catch (e) {
            // 解析失败，跳过
            continue;
          }
        }
      }

      if (clearedCount > 0) {
        DCLog.d('DCCache 清理过期数据: $clearedCount 条');
      }
      return clearedCount;
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 清理过期数据失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 监听 Box 的变化
  /// [boxName] 可选，指定 Box 名称，不传则使用默认 Box
  /// 返回 Stream，可以监听 Box 中数据的变化
  Stream<BoxEvent> watch({
    String? boxName,
    String? key,
  }) {
    try {
      final box = _boxes[boxName ?? _defaultBoxName];
      if (box == null) {
        throw Exception('Box 未打开: ${boxName ?? _defaultBoxName}');
      }

      if (key != null) {
        return box.watch(key: key);
      } else {
        return box.watch();
      }
    } catch (e, stackTrace) {
      DCLog.e(
        'DCCache 监听失败: ${boxName ?? _defaultBoxName}',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

/// 缓存数据包装类（内部使用）
/// 用于存储数据和过期时间
class _CacheItem {
  final dynamic value;
  final int? expireAt; // 过期时间戳（毫秒），null 表示永不过期

  _CacheItem({
    required this.value,
    this.expireAt,
  });

  /// 检查是否过期
  bool get isExpired {
    if (expireAt == null) return false;
    return DateTime.now().millisecondsSinceEpoch > expireAt!;
  }

  /// 转换为 Map（用于 Hive 存储）
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'expireAt': expireAt,
    };
  }

  /// 从 Map 创建（用于 Hive 读取）
  static _CacheItem fromMap(Map<dynamic, dynamic> map) {
    return _CacheItem(
      value: map['value'],
      expireAt: map['expireAt'] as int?,
    );
  }
}
