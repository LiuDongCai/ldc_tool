import 'package:dio/dio.dart';
import 'package:ldc_tool/base/network/dc_network_config.dart';
import 'package:ldc_tool/common/util/dc_log.dart';

/// 日志拦截器
class DCNetworkLogInterceptor extends Interceptor {
  /// 是否启用日志
  final bool enableLog;

  DCNetworkLogInterceptor({
    this.enableLog = true,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (enableLog) {
      DCLog.d(
        '请求: ${options.method} ${options.uri}',
        tag: 'DCNetwork',
      );
      if (options.queryParameters.isNotEmpty) {
        DCLog.d(
          '请求参数: ${options.queryParameters}',
          tag: 'DCNetwork',
        );
      }
      if (options.data != null) {
        DCLog.d(
          '请求体: ${options.data}',
          tag: 'DCNetwork',
        );
      }
      if (options.headers.isNotEmpty) {
        DCLog.d(
          '请求头: ${options.headers}',
          tag: 'DCNetwork',
        );
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (enableLog) {
      DCLog.d(
        '响应: ${response.statusCode} ${response.requestOptions.uri}',
        tag: 'DCNetwork',
      );
      DCLog.d(
        '响应数据: ${response.data}',
        tag: 'DCNetwork',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (enableLog) {
      DCLog.e(
        '请求错误: ${err.type} ${err.requestOptions.uri}',
        tag: 'DCNetwork',
        error: err,
        stackTrace: err.stackTrace,
      );
      if (err.response != null) {
        DCLog.e(
          '错误响应: ${err.response?.statusCode} ${err.response?.data}',
          tag: 'DCNetwork',
        );
      }
    }
    super.onError(err, handler);
  }
}

/// 公共请求头和默认参数拦截器
class DCNetworkConfigInterceptor extends Interceptor {
  /// 网络配置
  final DCNetworkConfig config;

  DCNetworkConfigInterceptor({
    required this.config,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // 添加公共请求头
    if (config.commonHeaders.isNotEmpty) {
      options.headers.addAll(config.commonHeaders);
    }

    // 添加默认参数
    if (config.defaultParams.isNotEmpty) {
      if (options.method == 'GET') {
        // GET 请求：合并到 queryParameters
        options.queryParameters.addAll(config.defaultParams);
      } else {
        // POST/PUT/DELETE 等请求：合并到 data
        if (options.data is Map) {
          (options.data as Map).addAll(config.defaultParams);
        } else if (options.data == null) {
          options.data = Map<String, dynamic>.from(config.defaultParams);
        } else {
          // 如果 data 不是 Map，则无法合并默认参数
          // 这种情况下，默认参数会被忽略
        }
      }
    }

    super.onRequest(options, handler);
  }
}

/// 重试拦截器
class DCNetworkRetryInterceptor extends Interceptor {
  /// 网络配置
  final DCNetworkConfig config;

  /// Dio 实例
  final Dio dio;

  DCNetworkRetryInterceptor({
    required this.config,
    required this.dio,
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // 如果重试次数为 0，直接返回错误
    if (config.retryCount <= 0) {
      super.onError(err, handler);
      return;
    }

    // 获取重试次数（从请求选项中获取，如果没有则使用配置的默认值）
    final retryCount = err.requestOptions.extra['retryCount'] as int? ??
        config.retryCount;
    final currentRetry = err.requestOptions.extra['currentRetry'] as int? ?? 0;

    // 如果已经达到最大重试次数，直接返回错误
    if (currentRetry >= retryCount) {
      super.onError(err, handler);
      return;
    }

    // 判断是否需要重试
    // 只对网络错误、超时错误进行重试
    final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;

    if (!shouldRetry) {
      super.onError(err, handler);
      return;
    }

    // 延迟后重试
    Future.delayed(
      Duration(milliseconds: config.retryDelay * (currentRetry + 1)),
      () async {
        try {
          // 更新重试次数
          err.requestOptions.extra['currentRetry'] = currentRetry + 1;

          DCLog.d(
            '重试请求: ${err.requestOptions.uri} (${currentRetry + 1}/$retryCount)',
            tag: 'DCNetwork',
          );

          // 重新发送请求
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              extra: err.requestOptions.extra,
            ),
          );

          handler.resolve(response);
        } catch (e) {
          // 重试失败，继续错误处理
          if (e is DioException) {
            handler.reject(e);
          } else {
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: e,
              ),
            );
          }
        }
      },
    );
  }
}

