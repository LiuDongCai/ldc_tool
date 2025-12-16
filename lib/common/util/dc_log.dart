import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 日志组件
/// 支持不同级别的日志输出，release 模式下只输出错误级别日志
class DCLog {
  DCLog._();

  static final DCLog _instance = DCLog._();

  /// 获取单例实例
  static DCLog get instance => _instance;

  /// Logger 实例，配置了输出格式
  late final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kReleaseMode ? Level.error : Level.trace,
  );

  /// Trace 级别日志（最详细）
  static void t(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;
    _formatAndLog(
      Level.trace,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Debug 级别日志
  static void d(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;
    _formatAndLog(
      Level.debug,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Info 级别日志
  static void i(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;
    _formatAndLog(
      Level.info,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Warning 级别日志
  static void w(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;
    _formatAndLog(
      Level.warning,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Error 级别日志（release 模式下也会输出）
  static void e(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _formatAndLog(
      Level.error,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Fatal 级别日志（最严重错误，release 模式下也会输出）
  static void f(
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _formatAndLog(
      Level.fatal,
      msg,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 格式化并输出日志
  static void _formatAndLog(
    Level level,
    String msg, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final formattedMsg = tag != null ? '[$tag] $msg' : msg;
    final logOutput = _instance._logger;

    switch (level) {
      case Level.trace:
        logOutput.t(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      case Level.debug:
        logOutput.d(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      case Level.info:
        logOutput.i(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      case Level.warning:
        logOutput.w(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      case Level.error:
        logOutput.e(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      case Level.fatal:
        logOutput.f(formattedMsg, error: error, stackTrace: stackTrace);
        break;
      default:
        logOutput.log(level, formattedMsg,
            error: error, stackTrace: stackTrace);
    }
  }
}
