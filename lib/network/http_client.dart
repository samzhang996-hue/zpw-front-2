import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/aesUtil.dart';
import '../utils/handle_tool.dart';
import '../utils/log_utils.dart';
import 'api_config.dart';
import 'base_response.dart';

/// HTTP 客户端封装类
class HttpClient {
  // 单例模式
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;

  late Dio _dio;

  // Token 缓存（避免每次请求都从本地存储读取）
  String? _token;

  HttpClient._internal() {
    _dio = Dio();
    _initDio();
  }

  /// 初始化 Dio 配置
  void _initDio() {
    // 基础配置
    _dio.options = BaseOptions(
      baseUrl: kReleaseMode ? ApiConfig.releaseBaseUrl : ApiConfig.debugBaseUrl,
      connectTimeout: Duration(seconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(seconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(seconds: ApiConfig.sendTimeout),
      responseType: ResponseType.plain,
      headers: {
        "Accept-Language": "zh_CN",
        "Content-Type": "application/json",
      },
      validateStatus: (status) => true,
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 打印请求信息
          _logRequest(options);

          // 添加认证信息
          String token = await HandleTool.getDataWithKey("token");
          if (token.isNotEmpty) {
            options.headers['Authorization'] = token;
            _token = token;
          }

          // 添加系统设备信息
          options.headers['systemDevice'] = HandleTool.instance.getCurrentSystem();

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 打印响应信息
          _logResponse(response);
          return handler.next(response);
        },
        onError: (error, handler) {
          // 打印错误信息
          _logError(error);
          return handler.next(error);
        },
      ),
    );
  }

  /// 获取 Dio 实例
  Dio get dio => _dio;

  /// 设置基础 URL
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// 设置请求头
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// 设置 Token（登录成功后调用）
  void setToken(String token) {
    _token = token;
  }

  /// 清除 Token（登出时调用）
  void clearToken() {
    _token = null;
  }

  /// 从本地加载 Token（应用启动时调用）
  Future<void> loadToken() async {
    _token = await HandleTool.getDataWithKey("token");
  }

  /// GET 请求
  Future<BaseResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showLoading = false,
    T Function(dynamic json)? fromJsonT,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      showLoading: showLoading,
      fromJsonT: fromJsonT,
    );
  }

  /// POST 请求
  Future<BaseResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showLoading = false,
    T Function(dynamic json)? fromJsonT,
    bool enableAES = false,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      showLoading: showLoading,
      fromJsonT: fromJsonT,
      enableAES: enableAES,
    );
  }

  /// PUT 请求
  Future<BaseResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showLoading = false,
    T Function(dynamic json)? fromJsonT,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      showLoading: showLoading,
      fromJsonT: fromJsonT,
    );
  }

  /// DELETE 请求
  Future<BaseResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showLoading = false,
    T Function(dynamic json)? fromJsonT,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      showLoading: showLoading,
      fromJsonT: fromJsonT,
    );
  }

  /// 统一请求方法
  Future<BaseResponse<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showLoading = false,
    T Function(dynamic json)? fromJsonT,
    bool enableAES = false,
  }) async {
    if (showLoading) {
      EasyLoading.show(status: '加载中...');
    }

    try {
      // AES 加密处理（如果需要）
      dynamic requestData = data;
      if (enableAES && data != null && _token != null && _token!.isNotEmpty) {
        requestData = _encryptData(data, _token!);
      }

      Response response;

      switch (method) {
        case 'GET':
          response = await _dio.get(path, queryParameters: queryParameters, options: options);
          break;
        case 'POST':
          response = await _dio.post(path, data: requestData, queryParameters: queryParameters, options: options);
          break;
        case 'PUT':
          response = await _dio.put(path, data: requestData, queryParameters: queryParameters, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete(path, data: requestData, queryParameters: queryParameters, options: options);
          break;
        default:
          throw Exception('不支持的请求方法: $method');
      }

      if (showLoading) {
        EasyLoading.dismiss();
      }

      // 处理响应
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      if (showLoading) {
        EasyLoading.dismiss();
      }

      // 返回错误响应
      return BaseResponse<T>(
        code: e.response?.statusCode ?? -1,
        message: _getErrorMessage(e),
        data: null,
      );
    } catch (e) {
      if (showLoading) {
        EasyLoading.dismiss();
      }

      return BaseResponse<T>(
        code: -1,
        message: '未知错误: $e',
        data: null,
      );
    }
  }

  /// 处理响应数据
  BaseResponse<T> _handleResponse<T>(Response response, T Function(dynamic json)? fromJsonT) {
    if (response.statusCode != 200) {
      return BaseResponse<T>(
        code: response.statusCode ?? -1,
        message: '请求失败',
        data: null,
      );
    }

    // 如果响应为空
    if (response.data == null || response.data.toString().isEmpty) {
      return BaseResponse<T>(
        code: 100,
        message: 'success',
        data: null,
      );
    }

    try {
      // 解析 JSON
      var jsonData = response.data is String ? jsonDecode(response.data) : response.data;

      if (jsonData is! Map<String, dynamic>) {
        return BaseResponse<T>(
          code: 0,
          message: '非标准格式响应',
          data: null,
        );
      }

      int code = jsonData['code'] as int? ?? 0;
      String message = jsonData['message'] as String? ?? '';
      var dataField = jsonData['data'];

      // AES 解密处理（如果数据是加密的字符串）
      if (dataField is String && _token != null && _token!.isNotEmpty) {
        try {
          dataField = _decryptData(dataField, _token!);
        } catch (e) {
        }
      }

      // 处理 Token 过期
      if (code == 1001) {
        _handleTokenExpired();
      }

      // 转换数据
      T? parsedData;
      if (dataField != null && fromJsonT != null) {
        if (dataField is List) {
          // 如果是列表，只取第一个元素（如果存在）
          parsedData = dataField.isNotEmpty ? fromJsonT(dataField[0]) : null;
        } else {
          parsedData = fromJsonT(dataField);
        }
      } else if (dataField != null) {
        parsedData = dataField as T?;
      }

      return BaseResponse<T>(
        code: code,
        message: message,
        data: parsedData,
      );
    } catch (e) {
      return BaseResponse<T>(
        code: -1,
        message: '数据解析失败',
        data: null,
      );
    }
  }

  /// AES 加密数据
  Map<String, dynamic> _encryptData(dynamic data, String token) {
    try {
      String dataJson = jsonEncode(data);
      String keyEn = token.split("-").first.substring(0, 16);
      Uint8List aes = AESUtil.tkAesEncrypt(dataJson, keyEn) as Uint8List;
      String hex = HexUtil.frombytesAsHexString(aes);
      return {"a": hex};
    } catch (e) {
      return data is Map<String, dynamic> ? data : {};
    }
  }

  /// AES 解密数据
  dynamic _decryptData(String encrypted, String token) {
    try {
      String keyDe = token.split("-").last.substring(0, 16);
      Uint8List u8s = HexUtil.createUint8ListFromHex(encrypted);
      String responseJson = AESUtil.tkAesDecrypt(base64Encode(u8s), keyDe);
      return jsonDecode(responseJson);
    } catch (e) {
      return encrypted;
    }
  }

  /// 处理 Token 过期
  void _handleTokenExpired() {
    // 清除本地 Token
    HandleTool.instance.token = "";
    HandleTool.instance.isMember = false;
    clearToken();

    // 这里可以添加跳转到登录页的逻辑
  }

  /// 获取错误信息
  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络连接';
      case DioExceptionType.sendTimeout:
        return '发送超时，请检查网络连接';
      case DioExceptionType.receiveTimeout:
        return '接收超时，请检查网络连接';
      case DioExceptionType.badResponse:
        return '服务器异常: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        String message = '网络连接失败';
        if (error.message?.contains('Software caused connection abort') == true ||
            error.message?.contains('Connection refused') == true) {
          message += '，请检查网络权限设置';
        }
        return message;
      case DioExceptionType.badCertificate:
        return '证书验证失败';
      case DioExceptionType.unknown:
        if (error.message?.contains('No address associated with hostname') == true ||
            error.message?.contains('Network is unreachable') == true) {
          return '网络不可用，请检查网络连接和权限设置';
        }
        return '网络请求失败，请稍后重试';
    }
  }

  /// 上传文件（支持 FormData 或文件路径）
  Future<BaseResponse<T>> upload<T>(
    String path,
    dynamic filePathOrFormData, {
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    bool showLoading = true,
    T Function(dynamic json)? fromJsonT,
  }) async {
    if (showLoading) {
      EasyLoading.show(status: '上传中...');
    }

    try {
      dynamic uploadData;

      // 判断是 FormData 还是文件路径
      if (filePathOrFormData is FormData) {
        uploadData = filePathOrFormData;
      } else if (filePathOrFormData is String && filePathOrFormData.isNotEmpty) {
        uploadData = FormData.fromMap({
          ...?data,
          fileKey: await MultipartFile.fromFile(filePathOrFormData),
        });
      } else {
        uploadData = data;
      }

      Response response = await _dio.post(path, data: uploadData, onSendProgress: onSendProgress);

      if (showLoading) {
        EasyLoading.dismiss();
      }

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      if (showLoading) {
        EasyLoading.dismiss();
      }

      return BaseResponse<T>(
        code: e.response?.statusCode ?? -1,
        message: _getErrorMessage(e),
        data: null,
      );
    }
  }

  /// 下载文件
  Future<bool> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      EasyLoading.show(status: '下载中...');
    }

    try {
      await _dio.download(urlPath, savePath, onReceiveProgress: onReceiveProgress);

      if (showLoading) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('下载完成');
      }

      return true;
    } on DioException catch (e) {
      if (showLoading) {
        EasyLoading.dismiss();
        EasyLoading.showError(_getErrorMessage(e));
      }
      return false;
    }
  }

  /// 打印请求日志
  void _logRequest(RequestOptions options) {

    // 打印查询参数
    if (options.queryParameters.isNotEmpty) {
      options.queryParameters.forEach((key, value) {
      });
    }

    // 打印请求头
    options.headers.forEach((key, value) {
    });


    // 打印请求体
    if (options.data != null) {
    }
  }

  /// 打印响应日志
  void _logResponse(Response response) {


    // 打印响应体
  }

  /// 打印错误日志
  void _logError(DioException error) {

    if (error.response != null) {
    }

  }
}
