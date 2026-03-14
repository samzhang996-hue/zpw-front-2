import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as gggg;
import 'package:zpw/utils/zpw_aes_util.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

import '../modules/main/model/zpw_user_info_bean.dart';
import '../modules/mine/zpw_mine_logic.dart';
import 'api/zpw_network_api.dart';
import 'exception/zpw_error_status.dart';
import 'exception/zpw_exception_handle.dart';
import 'zpw_interceptors.dart';
import 'zpw_net_response.dart';
import 'zpw_net_result.dart';

//设置默认的Header 不配置User-Agent 开眼API 403
Map<String, dynamic> zpwHeaders = {
  "Accept-Language": "zh_CN",
  "Content-Type": "application/json",
};

class ZpwDioUtils {
  static final ZpwDioUtils _zpwSingleInstance = ZpwDioUtils._internal();

  static ZpwDioUtils get instance => ZpwDioUtils();

  factory ZpwDioUtils() {
    return _zpwSingleInstance;
  }

  static Dio? _zpwDio;

  BaseOptions? _zpwOptions;

  ZpwAdapterInterceptor? zpwAdapterInterceptor;

  Dio getDio() {
    return _zpwDio!;
  }

  ZpwDioUtils._internal() {
    _zpwOptions = BaseOptions(
      baseUrl: kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug,
      connectTimeout: const Duration(seconds: 10),

      ///响应流前后两次接收数据的间隔
      receiveTimeout: const Duration(seconds: 15),

      ///如果返回的是json(content-type),dio默认自动转成json,无需手动转
      ///(https://github.com/flutterchina/dio/issues/30)
      responseType: ResponseType.plain,

      //默认的headers 配置
      headers: zpwHeaders,

      validateStatus: (status) {
        //是否使用http状态码进行判断，为true 表示不使用http状态码判断
        return true;
      },
    );
    _zpwDio = Dio(_zpwOptions);
    //添加cookie拦截器管理
    //   _zpwDio.interceptors.add(CookieManager(CookieJar()));

    //统一请求头拦截器
    _zpwDio?.interceptors.add(ZpwAuthInterceptor());

    //网络日志拦截器
    _zpwDio?.interceptors.add(ZpwLoggingInterceptor());
    zpwAdapterInterceptor = ZpwAdapterInterceptor();
    _zpwDio?.interceptors.add(zpwAdapterInterceptor!);
  }

  List<CancelToken> zpwTokenList = [];

  Future get<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? successTotalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, CancelToken? cancelToken, bool isCancleToken = false}) async {
    ZpwLog.d("net-----------$url");
    // if (url == ZpwApi.zpwAppPackageLatestPackage) {
    //   _zpwDio?.options.baseUrl = ZpwApi.zpwApiComm;
    // } else {
    _zpwDio?.options.baseUrl = kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug;
    // }

    if (isShowProgress) {
      EasyLoading.show();
    }
    zpwAdapterInterceptor?.zpwErrHandler = (e) {
      if (success != null) {
        success(false, 0, e, []);
      }
      EasyLoading.dismiss();
    };

    _zpwDio?.options = _zpwOptions!;
    // _zpwDio?.options.headers["Authorization"] =
    //     await ZpwHandleTool.getDataWithKey("token");
    _zpwDio?.options.headers["systemDevice"] = ZpwHandleTool.instance.getCurrentSystem();
    String token = _zpwDio?.options.headers["Authorization"] ?? "";
    params ??= {};
    var response;
    response = await _zpwDio?.get(url, queryParameters: params);
    EasyLoading.dismiss();
    if (response?.statusCode == 200 && response?.data.isEmpty) {
      if (success != null) {
        success(true, 0, "empty", []);
      }
      return;
    }
    try {
      //请求响应成功
      if (response?.statusCode == 200) {
        var resData = jsonDecode(response?.data);
        List result = zpwAexDectory(response!, token);
        // ZpwLog.i("result==${resData}==${result}");

        var code = resData['code'];
        var message = resData['message'];

        if (code == 100) {
          if (onModel == null) {
            if (success != null) {
              success(true, 1, "", result as List<T>);
            }
          } else {
            final values = result.map((e) => onModel(e) as T).toList();
            if (success != null) {
              success(true, 1, "", values);
            }
          }
        } else {
          _zpwTokenExpired(code);
          if (success != null) {
            success(false, 1, message, result as List<T>);
          }
        }
      } else {
        ZpwLog.i("==502===response==error=====${response?.data}");
        if (success != null) {
          success(false, response.statusCode, response?.data, []);
        }
      }
    } catch (e) {
      if (isShowError) {
        // ZpwHandleTool.showAppToastText(e.toString());
      }
      ZpwLog.i("=====response==error=====${e.toString()}");
      if (success != null) {
        success(false, 0, e.toString(), []);
      }
    }
  }

  Future post<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? successTotalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, CancelToken? cancelToken, bool isCancleToken = false}) async {
    // if (url == ZpwApi.zpwAppPackageLatestPackage) {
    //   _zpwDio?.options.baseUrl = ZpwApi.zpwApiComm;
    // } else {
    _zpwDio?.options.baseUrl = kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug;
    // }
    ZpwLog.d("url---$url");
    if (isShowProgress) {
      EasyLoading.show();
    }

    // Tool.instance1.
    ///=====>取消之前的请求
    if (isCancleToken == true) {
      zpwTokenList.forEach((element) {
        if (element != null) {
          element.cancel("取消重复请求");
        }
      });
    }
    zpwAdapterInterceptor?.zpwErrHandler = (e) {
      ZpwLog.i("eeee=====$e");
      if (e.contains("DioException [connection error]")) {
        return;
      }

      success!(false, -2222, e.toString(), []);
      if (e.contains('取消重复请求') == true) {
        // Tool.showToastText("cancle");
      }
      EasyLoading.dismiss();
    };
    _zpwDio?.options.headers["Authorization"] = await ZpwHandleTool.getDataWithKey("token");
    _zpwDio?.options.headers["systemDevice"] = ZpwHandleTool.instance.getCurrentSystem();
    _zpwDio?.options = _zpwOptions!;
    String token = _zpwDio?.options.headers["Authorization"] ?? "";
    params ??= {};

    ZpwLog.i("token===>$token");

    if (cancelToken != null) {
      zpwTokenList.add(cancelToken);
    }

    try {
      var response;

      response = await _zpwDio?.post(url,
          data: params,
          // queryParameters: params,
          cancelToken: cancelToken);

      if (response.statusCode == 200 && response.data.toString().isEmpty) {
        if (success != null) {
          success(true, 1, "empty", []);
        }
        return;
      }
      try {
        if (response.statusCode == 200) {
          zpwTokenList.remove(cancelToken);
          List result = zpwAexDectory(response!, token);
          // ZpwLog.i("resData=111====${result}");
          var resData = jsonDecode(response.data);
          var code = resData['code'];
          if (code == 100) {
            if (onModel == null) {
              if (success != null) {
                success(true, 1, "", result as List<T>);
              }
            } else {
              // ZpwLog.i("result======${result}");
              final values = result.map((e) => onModel(e) as T).toList();
              if (success != null) {
                success(true, 1, "", values);
              }
            }
            var data = resData['data'];
            if (data is Map) {
              int totalCount = data['totalCount'] ?? 0;
              if (successTotalCount != null) {
                successTotalCount(totalCount);
              }
            }
          } else {
            _zpwTokenExpired(code);
            if (isShowProgress == true) {
              ZpwHandleTool.showAppToastText(resData["message"]);
            }
            EasyLoading.dismiss();
            ZpwLog.i("=response==error= $url"
                "== ${response.data}====="
                "==$params");
            if (onModel == null) {
              if (success != null) {
                success(false, code, "", result as List<T>);
              }
            } else {
              final values = result.map((e) => onModel(e) as T).toList();
              if (success != null) {
                success(false, code, "", values);
              }
            }
          }
        } else {
          zpwTokenList.remove(cancelToken);
          if (isShowError) {
            ZpwHandleTool.showAppToastText(response.data);
          }
          if (success != null) {
            success(false, response.statusCode, response.data, []);
          }
        }
        EasyLoading.dismiss();
      } catch (e) {
        zpwTokenList.remove(cancelToken);
        EasyLoading.dismiss();
        if (isShowError) {
          ZpwHandleTool.showAppToastText(e.toString());
        }
        ZpwLog.i("=response==error=====${e.toString()} $url");
        if (success != null) {
          success(false, 0, e.toString(), []);
        }
      }
    } on DioException catch (e) {
      zpwTokenList.remove(cancelToken);
      if (success != null) {
        if (e.type == DioExceptionType.connectionError) {
          success(false, -1111, e.message ?? "", []);
        } else {
          success(false, 0, e.message ?? "", []);
        }
      }
      ZpwLog.i("=response==error====${e.type} $url");
    }
  }

  void _zpwTokenExpired(int code) {
    if (code == 1001) {
      ZpwSpUtils.setString("token", "");
      ZpwHandleTool.instance.token = "";
      final logic = gggg.Get.find<MineLogic>();
      logic.state.userInfoBean = UserInfoBean();
      ZpwHandleTool.instance.isMember = false;
      logic.update();
    }
  }

  /// async/await 版本的 POST 请求
  Future<ZpwNetResult<T>> postAsync<T>(
    String url, {
    Map<String, dynamic>? params,
    T Function(Map<String, dynamic>)? onModel,
    bool isShowProgress = true,
    bool isShowError = true,
  }) async {
    _zpwDio?.options.baseUrl = kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug;
    ZpwLog.d("url---$url");

    if (isShowProgress) {
      EasyLoading.show();
    }

    _zpwDio?.options.headers["Authorization"] = await ZpwHandleTool.getDataWithKey("token");
    _zpwDio?.options.headers["systemDevice"] = ZpwHandleTool.instance.getCurrentSystem();
    _zpwDio?.options = _zpwOptions!;
    String token = _zpwDio?.options.headers["Authorization"] ?? "";
    params ??= {};

    ZpwLog.i("token===>$token");

    try {
      var response = await _zpwDio?.post(url, data: params);

      if (response?.statusCode == 200 && response?.data.toString().isEmpty == true) {
        EasyLoading.dismiss();
        return ZpwNetResult<T>(isSuccess: true, code: 1, message: "empty", data: []);
      }

      if (response?.statusCode == 200) {
        EasyLoading.dismiss();
        List result = zpwAexDectory(response!, token);
        var resData = jsonDecode(response.data);
        var code = resData['code'];
        var message = resData['message'] ?? "";

        if (code == 100) {
          if (onModel == null) {
            return ZpwNetResult<T>(isSuccess: true, code: code, message: message, data: result as List<T>);
          } else {
            final values = result.map((e) => onModel(e) as T).toList();
            return ZpwNetResult<T>(isSuccess: true, code: code, message: message, data: values);
          }
        } else {
          _zpwTokenExpired(code);
          if (isShowError) {
            ZpwHandleTool.showAppToastText(message);
          }
          if (onModel == null) {
            return ZpwNetResult<T>(isSuccess: false, code: code, message: message, data: result as List<T>);
          } else {
            final values = result.map((e) => onModel(e) as T).toList();
            return ZpwNetResult<T>(isSuccess: false, code: code, message: message, data: values);
          }
        }
      } else {
        EasyLoading.dismiss();
        if (isShowError) {
          ZpwHandleTool.showAppToastText(response?.data?.toString() ?? "");
        }
        return ZpwNetResult<T>(isSuccess: false, code: response?.statusCode ?? -1, message: response?.data?.toString() ?? "", data: []);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      ZpwLog.i("=response==error====${e.type} $url");
      return ZpwNetResult<T>(isSuccess: false, code: -1, message: e.message ?? "", data: []);
    } catch (e) {
      EasyLoading.dismiss();
      ZpwLog.i("=response==error=====${e.toString()} $url");
      return ZpwNetResult<T>(isSuccess: false, code: -1, message: e.toString(), data: []);
    }
  }

  /// async/await 版本的 GET 请求
  Future<ZpwNetResult<T>> getAsync<T>(
    String url, {
    Map<String, dynamic>? params,
    T Function(Map<String, dynamic>)? onModel,
    bool isShowProgress = true,
    bool isShowError = true,
  }) async {
    _zpwDio?.options.baseUrl = kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug;
    ZpwLog.d("net-----------$url");

    if (isShowProgress) {
      EasyLoading.show();
    }

    _zpwDio?.options = _zpwOptions!;
    _zpwDio?.options.headers["systemDevice"] = ZpwHandleTool.instance.getCurrentSystem();
    String token = _zpwDio?.options.headers["Authorization"] ?? "";
    params ??= {};

    try {
      var response = await _zpwDio?.get(url, queryParameters: params);
      EasyLoading.dismiss();

      if (response?.statusCode == 200 && response?.data.isEmpty) {
        return ZpwNetResult<T>(isSuccess: true, code: 0, message: "empty", data: []);
      }

      if (response?.statusCode == 200) {
        var resData = jsonDecode(response?.data);
        List result = zpwAexDectory(response!, token);
        var code = resData['code'];
        var message = resData['message'] ?? "";

        if (code == 100) {
          if (onModel == null) {
            return ZpwNetResult<T>(isSuccess: true, code: code, message: message, data: result as List<T>);
          } else {
            final values = result.map((e) => onModel(e) as T).toList();
            return ZpwNetResult<T>(isSuccess: true, code: code, message: message, data: values);
          }
        } else {
          _zpwTokenExpired(code);
          return ZpwNetResult<T>(isSuccess: false, code: code, message: message, data: result as List<T>);
        }
      } else {
        ZpwLog.i("==502===response==error=====${response?.data}");
        return ZpwNetResult<T>(isSuccess: false, code: response?.statusCode ?? -1, message: response?.data?.toString() ?? "", data: []);
      }
    } catch (e) {
      EasyLoading.dismiss();
      ZpwLog.i("=====response==error=====${e.toString()}");
      return ZpwNetResult<T>(isSuccess: false, code: -1, message: e.toString(), data: []);
    }
  }

  Future<T?> upload<T>(
    String url, {
    Object? params,
    onModel,
  }) async {
    _zpwDio?.options.baseUrl = kReleaseMode ? ZpwApi.zpwApiBaseUrlRelease : ZpwApi.zpwApiBaseUrlDebug;
    EasyLoading.show();
    _zpwDio?.options.headers["Authorization"] = await ZpwHandleTool.getDataWithKey("token");
    _zpwDio?.options = _zpwOptions!;
    params ??= {};

    print("_zpwDio?.options:${_zpwDio?.options.headers}");

    // return null;
    try {
      var response;
      response = await _zpwDio?.post(url, data: params);
      EasyLoading.dismiss();
      print("resData:$response");
      try {
        if (response.statusCode == 200) {
          var resData = jsonDecode(response.data);
          var code = resData['code'];
          var message = resData['message'];
          print("resData:$resData");
          if (code == 500) {
            ZpwHandleTool.showAppToastText(message);
            return null;
          }

          if (code == 100) {
            var data = resData['data'];
            return onModel(data);
          }
          _zpwTokenExpired(code);
        }
      } catch (e) {
        EasyLoading.dismiss();
        ZpwLog.i("=response==error====${e.runtimeType} $url");
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      ZpwLog.i("=response==error====${e.type} $url");
    }
    return null;
  }

  ///将返回的数据进行统一处理并解析成对应的Bean
  Future<ZpwBaseResponse<T>> _zpwRequest<T>(String method, String url, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    String dataJson = "";
    if (data != null) {
      dataJson = jsonEncode(data);
    }

    String token = _zpwDio?.options.headers["token"];
    String keyEn = token.split("-").first.substring(0, 16);
    Uint8List aes = ZpwAESUtil.zpwTkAesEncrypt(dataJson, keyEn) as Uint8List;
    String hex = ZpwHexUtil.zpwFrombytesAsHexString(aes);
    print("=====hex======$hex");
    _zpwDio?.options = _zpwOptions!;
    var r = await _zpwDio?.get(url + "?a=$hex");
    var response = await _zpwDio?.request(url, data: {"a": hex}, queryParameters: queryParameters, options: _zpwSetOptions(method, options!), cancelToken: cancelToken);
    try {
      // String keyDe = token.split("-").last.substring(0,16);
      // Uint8List u8s = HexUtil.createUint8ListFromHex(response.data ?? "");
      // String responseJson = AESUtil.tkAesDecrypt(base64Encode(u8s) ,keyDe);
      // print("===rsponse=====$responseJson");
      return ZpwBaseResponse(ZpwErrorStatus.zpwRequestDataOk, "success", response?.data);
    } catch (e) {
      return ZpwBaseResponse(ZpwErrorStatus.zpwParseError, "数据解析异常", []);
    }
  }

  Future zpwRequestDataFuture<T>(ZpwMethod method, String url, {Function(T t)? onSuccess, Function(List<T> list)? onSuccessList, Function(int code, String msg)? onError, dynamic params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, bool isList = false}) async {
    String requestMethod = _zpwGetMethod(method);

    return await _zpwRequest<T>(requestMethod, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken).then((ZpwBaseResponse<T> result) {
      if (result.zpwCode == ZpwErrorStatus.zpwRequestDataOk) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.zpwListData);
          }
        } else {
          if (onSuccess != null) {
            // onSuccess(result.data);
          }
        }
      } else {
        _zpwOnError(result.zpwCode ?? 0, result.zpwMessage ?? "error", onError!);
      }
    }, onError: (e) {
      _zpwCancelLog(e, url);
      ZpwNetError error = ZpwExceptionHandle.handleException(e);
      _zpwOnError(error.zpwCode, error.zpwMsg, onError!);
    });
  }

  ZpwBaseResponse zpwParseError() {
    return ZpwBaseResponse(ZpwErrorStatus.zpwParseError, "数据解析错误", []);
  }

  ///用于配置Options
  Options _zpwSetOptions(String method, Options options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    options.headers = zpwHeaders;
    return options;
  }

  ///请求单个对象的操作
  Future<ZpwBaseResponse<T>> zpwRequest<T>(String method, String url, {Map<String, dynamic>? params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    var response = await _zpwRequest<T>(method, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    return response;
  }

  zpwRequestData<T>(ZpwMethod method, String url, {Function(T t)? onSuccess, Function(List<T> t)? onSuccessList, Function(int code, String msg)? onError, Map<String, dynamic>? params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, bool isList = false}) async {
    String requestMethod = _zpwGetMethod(method);
    try {
      var result = await _zpwRequest<T>(requestMethod, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      if (result.zpwCode == ZpwErrorStatus.zpwRequestDataOk) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.zpwListData);
          }
        } else {
          if (onSuccess != null) {
            // onSuccess(result.data);
          }
        }
      } else {
        _zpwOnError(result.zpwCode ?? 0, result.zpwMessage ?? "error", onError!);
      }
    } catch (e) {
      _zpwCancelLog(e, url);
      ZpwNetError error = ZpwExceptionHandle.handleException(e);
      _zpwOnError(error.zpwCode, error.zpwMsg, onError!);
    }
  }

  _zpwCancelLog(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      ZpwLog.i("取消网络请求：$url");
    }
  }

  _zpwOnError(int code, String msg, Function(int code, String msg) onError) {
    if (onError != null) {
      onError(code, msg);
    }
    // Toast.show(msg);
  }

  //用于获取当前的请求类型
  String _zpwGetMethod(ZpwMethod method) {
    String netMethod;
    switch (method) {
      case ZpwMethod.zpwGet:
        netMethod = "GET";
        break;
      case ZpwMethod.zpwPost:
        netMethod = "POST";
        break;
      case ZpwMethod.zpwPut:
        netMethod = "PUT";
        break;
      case ZpwMethod.zpwDelete:
        netMethod = "DELETE";
        break;
    }
    return netMethod;
  }
}

Map<String, dynamic> zpwParseData(String data) {
  return json.decode(data);
}

Map<String, dynamic> zpwAexEntory(Map<String, dynamic> params, String token) {
  String dataJson = "";
  Map<String, dynamic>? dataParams;
  if (params != null) {
    dataJson = jsonEncode(params);
    String keyEn = token.split("-").first.substring(0, 16);
    Uint8List aes = ZpwAESUtil.zpwTkAesEncrypt(dataJson, keyEn) as Uint8List;
    String hex = ZpwHexUtil.zpwFrombytesAsHexString(aes);
    dataParams = {"a": hex};
  }
  return dataParams ?? {};
}

List zpwAexDectory(Response response, String token) {
  var resData = jsonDecode(response.data);
  // ZpwLog.i("data1112233===${resData}");
  List result = [];
  if (resData['code'] != 100) {
  } else {
    if (resData['data'] != null) {
      var data = resData['data'];

      if (data is String) {
        resData = data;
      } else if (data is bool) {
        resData = data == true ? "1" : "0";
      } else if (data is int) {
        resData = data;
      } else if (data is double) {
        resData = data;
      } else if (data is List) {
        resData = data;
      } else {
        if (data['list'] == null && data['totalCount'] == 0) {
          data['list'] = [];
        }

        if (data['list'] != null) {
          resData = data['list'];
        } else {
          resData = data;
        }
      }
    }

    // ZpwLog.i("data1112233===${resData}");

    if (resData is List) {
      result = resData;
    } else {
      result = [resData];
    }
  }

  // ZpwLog.i("+========${result}");

  return result;
}

enum ZpwMethod {
  zpwGet,
  zpwPost,
  zpwPut,
  zpwDelete,
}