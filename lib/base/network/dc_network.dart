import 'package:dio/dio.dart';
import 'package:ldc_tool/base/network/dc_network_config.dart';
import 'package:ldc_tool/base/network/dc_network_exception.dart';
import 'package:ldc_tool/base/network/dc_network_interceptor.dart';

/// 网络请求管理类
/// 基于 Dio 封装的网络请求工具，提供统一的请求接口
class DCNetwork {
  /// 私有构造函数
  DCNetwork._internal();

  /// 单例实例
  static final DCNetwork _instance = DCNetwork._internal();

  /// 获取单例实例
  static DCNetwork get instance => _instance;

  /// Dio 实例
  late Dio _dio;

  /// 网络配置
  final DCNetworkConfig config = DCNetworkConfig();

  /// 是否已初始化
  bool _isInitialized = false;

  /// 初始化网络请求
  /// [baseUrl] 基础 URL
  /// [connectTimeout] 连接超时时间（毫秒），默认 30000
  /// [receiveTimeout] 接收超时时间（毫秒），默认 30000
  /// [sendTimeout] 发送超时时间（毫秒），默认 30000
  /// [retryCount] 失败重试次数，默认 0
  /// [retryDelay] 重试间隔（毫秒），默认 1000
  /// [enableLog] 是否启用日志，默认 true
  void init({
    String? baseUrl,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
    int sendTimeout = 30000,
    int retryCount = 0,
    int retryDelay = 1000,
    bool enableLog = true,
  }) {
    if (_isInitialized) {
      return;
    }

    config.baseUrl = baseUrl;
    config.connectTimeout = connectTimeout;
    config.receiveTimeout = receiveTimeout;
    config.sendTimeout = sendTimeout;
    config.retryCount = retryCount;
    config.retryDelay = retryDelay;
    config.enableLog = enableLog;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        sendTimeout: Duration(milliseconds: sendTimeout),
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(DCNetworkConfigInterceptor(config: config));
    _dio.interceptors.add(DCNetworkRetryInterceptor(config: config, dio: _dio));
    _dio.interceptors.add(DCNetworkLogInterceptor(enableLog: enableLog));

    // 添加自定义拦截器
    for (final interceptor in config.interceptors) {
      _dio.interceptors.add(interceptor);
    }

    _isInitialized = true;
  }

  /// 更新基础 URL
  void updateBaseUrl(String baseUrl) {
    config.baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }

  /// 更新公共请求头
  void updateHeaders(Map<String, dynamic> headers) {
    config.updateHeaders(headers);
  }

  /// 设置单个请求头
  void setHeader(String key, dynamic value) {
    config.setHeader(key, value);
  }

  /// 移除请求头
  void removeHeader(String key) {
    config.removeHeader(key);
  }

  /// 更新默认参数
  void updateDefaultParams(Map<String, dynamic> params) {
    config.updateDefaultParams(params);
  }

  /// 设置单个默认参数
  void setDefaultParam(String key, dynamic value) {
    config.setDefaultParam(key, value);
  }

  /// 移除默认参数
  void removeDefaultParam(String key) {
    config.removeDefaultParam(key);
  }

  /// 添加拦截器
  void addInterceptor(Interceptor interceptor) {
    config.interceptors.add(interceptor);
    _dio.interceptors.add(interceptor);
  }

  /// 移除拦截器
  void removeInterceptor(Interceptor interceptor) {
    config.interceptors.remove(interceptor);
    _dio.interceptors.remove(interceptor);
  }

  /// 通用请求方法
  /// [path] 请求路径
  /// [method] 请求方法
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) async {
    if (!_isInitialized) {
      throw DCNetworkException(
        code: -100,
        message: 'DCNetwork 未初始化，请先调用 init() 方法',
      );
    }

    try {
      final requestOptions = options ?? Options();
      final extra = Map<String, dynamic>.from(requestOptions.extra ?? {});
      if (retryCount != null) {
        extra['retryCount'] = retryCount;
      }
      requestOptions.extra = extra;

      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions.copyWith(method: method),
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      throw DCNetworkException.fromDioException(e);
    } catch (e) {
      throw DCNetworkException(
        code: -99,
        message: '请求异常: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// GET 请求
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) {
    return request<T>(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryCount: retryCount,
    );
  }

  /// POST 请求
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) {
    return request<T>(
      path: path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryCount: retryCount,
    );
  }

  /// PUT 请求
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) {
    return request<T>(
      path: path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryCount: retryCount,
    );
  }

  /// DELETE 请求
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) {
    return request<T>(
      path: path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryCount: retryCount,
    );
  }

  /// PATCH 请求
  /// [path] 请求路径
  /// [data] 请求数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [retryCount] 重试次数（覆盖全局配置）
  Future<Response<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int? retryCount,
  }) {
    return request<T>(
      path: path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryCount: retryCount,
    );
  }

  /// 下载文件
  /// [url] 下载地址
  /// [savePath] 保存路径
  /// [onReceiveProgress] 下载进度回调
  /// [cancelToken] 取消令牌
  /// [options] 请求选项
  Future<Response> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    if (!_isInitialized) {
      throw DCNetworkException(
        code: -100,
        message: 'DCNetwork 未初始化，请先调用 init() 方法',
      );
    }

    try {
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw DCNetworkException.fromDioException(e);
    } catch (e) {
      throw DCNetworkException(
        code: -99,
        message: '下载异常: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// 上传文件
  /// [path] 请求路径
  /// [filePath] 文件路径
  /// [fileName] 文件名称
  /// [onSendProgress] 上传进度回调
  /// [cancelToken] 取消令牌
  /// [options] 请求选项
  Future<Response<T>> upload<T>({
    required String path,
    required String filePath,
    String? fileName,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    if (!_isInitialized) {
      throw DCNetworkException(
        code: -100,
        message: 'DCNetwork 未初始化，请先调用 init() 方法',
      );
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      throw DCNetworkException.fromDioException(e);
    } catch (e) {
      throw DCNetworkException(
        code: -99,
        message: '上传异常: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// 取消请求
  void cancel(CancelToken cancelToken) {
    cancelToken.cancel('请求已取消');
  }
}
