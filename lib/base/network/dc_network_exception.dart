import 'package:dio/dio.dart';

/// 网络请求异常类
class DCNetworkException implements Exception {
  /// 错误码
  final int? code;

  /// 错误信息
  final String message;

  /// 原始异常
  final dynamic originalError;

  /// 响应数据
  final Response? response;

  DCNetworkException({
    this.code,
    required this.message,
    this.originalError,
    this.response,
  });

  /// 从 DioException 创建异常
  factory DCNetworkException.fromDioException(DioException error) {
    String message;
    int? code;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时，请检查网络';
        code = -1;
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时，请检查网络';
        code = -2;
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时，请检查网络';
        code = -3;
        break;
      case DioExceptionType.badResponse:
        message = '服务器响应错误';
        code = error.response?.statusCode ?? -4;
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        code = -5;
        break;
      case DioExceptionType.connectionError:
        message = '网络连接失败，请检查网络';
        code = -6;
        break;
      case DioExceptionType.badCertificate:
        message = '证书验证失败';
        code = -7;
        break;
      case DioExceptionType.unknown:
        message = error.message ?? '未知错误';
        code = -8;
        break;
    }

    // 如果服务器返回了错误信息，优先使用服务器信息
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is String) {
        message = data;
      }
    }

    return DCNetworkException(
      code: code,
      message: message,
      originalError: error,
      response: error.response,
    );
  }

  @override
  String toString() {
    return 'DCNetworkException(code: $code, message: $message)';
  }
}

