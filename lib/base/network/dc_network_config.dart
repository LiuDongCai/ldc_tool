import 'package:dio/dio.dart';

/// 网络请求配置类
/// 用于配置公共请求头、默认参数、重试次数等
class DCNetworkConfig {
  /// 基础 URL
  String? baseUrl;

  /// 连接超时时间（毫秒）
  int connectTimeout = 30000;

  /// 接收超时时间（毫秒）
  int receiveTimeout = 30000;

  /// 发送超时时间（毫秒）
  int sendTimeout = 30000;

  /// 公共请求头
  Map<String, dynamic> commonHeaders = {};

  /// 默认请求参数
  Map<String, dynamic> defaultParams = {};

  /// 失败重试次数
  int retryCount = 0;

  /// 重试间隔（毫秒）
  int retryDelay = 1000;

  /// 是否启用日志
  bool enableLog = true;

  /// 拦截器列表
  List<Interceptor> interceptors = [];

  /// 更新公共请求头
  void updateHeaders(Map<String, dynamic> headers) {
    commonHeaders.addAll(headers);
  }

  /// 设置单个请求头
  void setHeader(String key, dynamic value) {
    commonHeaders[key] = value;
  }

  /// 移除请求头
  void removeHeader(String key) {
    commonHeaders.remove(key);
  }

  /// 更新默认参数
  void updateDefaultParams(Map<String, dynamic> params) {
    defaultParams.addAll(params);
  }

  /// 设置单个默认参数
  void setDefaultParam(String key, dynamic value) {
    defaultParams[key] = value;
  }

  /// 移除默认参数
  void removeDefaultParam(String key) {
    defaultParams.remove(key);
  }

  /// 清空所有配置
  void clear() {
    commonHeaders.clear();
    defaultParams.clear();
    interceptors.clear();
  }
}

