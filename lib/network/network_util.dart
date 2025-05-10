import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as gggg;
import 'package:zpw/utils/aesUtil.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/sp_utils.dart';

import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import 'api/network_api.dart';
import 'exception/error_status.dart';
import 'exception/exception_handle.dart';
import 'interceptors.dart';
import 'net_response.dart';

//设置默认的Header 不配置User-Agent 开眼API 403
Map<String, dynamic> headers = {
  "Accept-Language": "zh_CN",
  "Content-Type": "application/json",
};

class DioUtils {
  static final DioUtils _singleInstance = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleInstance;
  }

  static Dio? _dio;

  BaseOptions? _options;

  AdapterInterceptor? adapterInterceptor;

  Dio getDio() {
    return _dio!;
  }

  DioUtils._internal() {
    _options = BaseOptions(
      baseUrl: kReleaseMode ? Api.API_BASE_URL_RELEASE : Api.API_BASE_URL_DEBUG,
      connectTimeout: const Duration(seconds: 10),

      ///响应流前后两次接收数据的间隔
      receiveTimeout: const Duration(seconds: 15),

      ///如果返回的是json(content-type),dio默认自动转成json,无需手动转
      ///(https://github.com/flutterchina/dio/issues/30)
      responseType: ResponseType.plain,

      //默认的headers 配置
      headers: headers,

      validateStatus: (status) {
        //是否使用http状态码进行判断，为true 表示不使用http状态码判断
        return true;
      },
    );
    _dio = Dio(_options);
    //添加cookie拦截器管理
    //   _dio.interceptors.add(CookieManager(CookieJar()));

    //统一请求头拦截器
    _dio?.interceptors.add(AuthInterceptor());

    //网络日志拦截器
    _dio?.interceptors.add(LoggingInterceptor());
    adapterInterceptor = AdapterInterceptor();
    _dio?.interceptors.add(adapterInterceptor!);
  }

  List<CancelToken> tokenList = [];

  Future get<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? successTotalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, CancelToken? cancelToken, bool isCancleToken = false}) async {
    Log.d("net-----------$url");
    // if (url == Api.appPackage_latestPackage) {
    //   _dio?.options.baseUrl = Api.API_COMM;
    // } else {
    _dio?.options.baseUrl = kReleaseMode ? Api.API_BASE_URL_RELEASE : Api.API_BASE_URL_DEBUG;
    // }

    if (isShowProgress) {
      EasyLoading.show();
    }
    adapterInterceptor?.errHandler = (e) {
      if (success != null) {
        success(false, 0, e, []);
      }
      EasyLoading.dismiss();
    };

    _dio?.options = _options!;
    // _dio?.options.headers["Authorization"] =
    //     await HandleTool.getDataWithKey("token");
    _dio?.options.headers["systemDevice"] = HandleTool.instance.getCurrentSystem();
    String token = _dio?.options.headers["Authorization"] ?? "";
    params ??= {};
    var response;
    response = await _dio?.get(url, queryParameters: params);
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
        List result = aexDectory(response!, token);
        // Log.i("result==${resData}==${result}");

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
          _tokenExpired(code);
          if (success != null) {
            success(false, 1, message, result as List<T>);
          }
        }
      } else {
        Log.i("==502===response==error=====${response?.data}");
        if (success != null) {
          success(false, response.statusCode, response?.data, []);
        }
      }
    } catch (e) {
      if (isShowError) {
        // HandleTool.showAppToastText(e.toString());
      }
      Log.i("=====response==error=====${e.toString()}");
      if (success != null) {
        success(false, 0, e.toString(), []);
      }
    }
  }

  Future post<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? successTotalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, CancelToken? cancelToken, bool isCancleToken = false}) async {
    // if (url == Api.appPackage_latestPackage) {
    //   _dio?.options.baseUrl = Api.API_COMM;
    // } else {
    _dio?.options.baseUrl = kReleaseMode ? Api.API_BASE_URL_RELEASE : Api.API_BASE_URL_DEBUG;
    // }
    Log.d("url---$url");
    if (isShowProgress) {
      EasyLoading.show();
    }

    // Tool.instance1.
    ///=====>取消之前的请求
    if (isCancleToken == true) {
      tokenList.forEach((element) {
        if (element != null) {
          element.cancel("取消重复请求");
        }
      });
    }
    adapterInterceptor?.errHandler = (e) {
      Log.i("eeee=====$e");
      if (e.contains("DioException [connection error]")) {
        return;
      }

      success!(false, -2222, e.toString(), []);
      if (e.contains('取消重复请求') == true) {
        // Tool.showToastText("cancle");
      }
      EasyLoading.dismiss();
    };
    _dio?.options.headers["Authorization"] = await HandleTool.getDataWithKey("token");
    _dio?.options.headers["systemDevice"] = HandleTool.instance.getCurrentSystem();
    _dio?.options = _options!;
    String token = _dio?.options.headers["Authorization"] ?? "";
    params ??= {};

    Log.i("token===>$token");

    if (cancelToken != null) {
      tokenList.add(cancelToken);
    }

    try {
      var response;

      response = await _dio?.post(url,
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
          tokenList.remove(cancelToken);
          List result = aexDectory(response!, token);
          // Log.i("resData=111====${result}");
          var resData = jsonDecode(response.data);
          var code = resData['code'];
          if (code == 100) {
            if (onModel == null) {
              if (success != null) {
                success(true, 1, "", result as List<T>);
              }
            } else {
              // Log.i("result======${result}");
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
            _tokenExpired(code);
            if (isShowProgress == true) {
              HandleTool.showAppToastText(resData["message"]);
            }
            EasyLoading.dismiss();
            Log.i("=response==error= $url"
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
          tokenList.remove(cancelToken);
          if (isShowError) {
            HandleTool.showAppToastText(response.data);
          }
          if (success != null) {
            success(false, response.statusCode, response.data, []);
          }
        }
        EasyLoading.dismiss();
      } catch (e) {
        tokenList.remove(cancelToken);
        EasyLoading.dismiss();
        if (isShowError) {
          if (e.toString().contains("Bad state: Future already completed")) {
          } else {
            HandleTool.showAppToastText(e.toString());
          }
        }
        if (e.toString().contains("Bad state: Future already completed")) {
        } else {
          Log.i("=response==error=====${e.toString()} $url");
        }

        if (success != null) {
          success(false, 0, e.toString(), []);
        }
      }
    } on DioException catch (e) {
      tokenList.remove(cancelToken);
      if (success != null) {
        if (e.type == DioExceptionType.connectionError) {
          success(false, -1111, e.message ?? "", []);
        } else {
          success(false, 0, e.message ?? "", []);
        }
      }
      Log.i("=response==error====${e.type} $url");
    }
  }

  void _tokenExpired(int code) {
    if (code == 1001) {
      SpUtils.setString("token", "");
      HandleTool.instance.token = "";
      final logic = gggg.Get.find<MineLogic>();
      logic.state.userInfoBean = UserInfoBean();
      HandleTool.instance.isMember = false;
      logic.update();
    }
  }

  Future<T?> upload<T>(
    String url, {
    Object? params,
    onModel,
  }) async {
    _dio?.options.baseUrl = kReleaseMode ? Api.API_BASE_URL_RELEASE : Api.API_BASE_URL_DEBUG;
    EasyLoading.show();
    _dio?.options.headers["Authorization"] = await HandleTool.getDataWithKey("token");
    _dio?.options = _options!;
    params ??= {};

    print("_dio?.options:${_dio?.options.headers}");

    // return null;
    try {
      var response;
      response = await _dio?.post(url, data: params);
      EasyLoading.dismiss();
      print("resData:$response");
      try {
        if (response.statusCode == 200) {
          var resData = jsonDecode(response.data);
          var code = resData['code'];
          var message = resData['message'];
          print("resData:$resData");
          if (code == 500) {
            HandleTool.showAppToastText(message);
            return null;
          }

          if (code == 100) {
            var data = resData['data'];
            return onModel(data);
          }
          _tokenExpired(code);
        }
      } catch (e) {
        EasyLoading.dismiss();
        Log.i("=response==error====${e.runtimeType} $url");
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Log.i("=response==error====${e.type} $url");
    }
    return null;
  }

  ///将返回的数据进行统一处理并解析成对应的Bean
  Future<BaseResponse<T>> _request<T>(String method, String url, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    String dataJson = "";
    if (data != null) {
      dataJson = jsonEncode(data);
    }

    String token = _dio?.options.headers["token"];
    String keyEn = token.split("-").first.substring(0, 16);
    Uint8List aes = AESUtil.tkAesEncrypt(dataJson, keyEn) as Uint8List;
    String hex = HexUtil.frombytesAsHexString(aes);
    print("=====hex======$hex");
    _dio?.options = _options!;
    var r = await _dio?.get(url + "?a=$hex");
    var response = await _dio?.request(url, data: {"a": hex}, queryParameters: queryParameters, options: _setOptions(method, options!), cancelToken: cancelToken);
    try {
      // String keyDe = token.split("-").last.substring(0,16);
      // Uint8List u8s = HexUtil.createUint8ListFromHex(response.data ?? "");
      // String responseJson = AESUtil.tkAesDecrypt(base64Encode(u8s) ,keyDe);
      // print("===rsponse=====$responseJson");
      return BaseResponse(ErrorStatus.REQUEST_DATA_OK, "success", response?.data);
    } catch (e) {
      return BaseResponse(ErrorStatus.PARSE_ERROR, "数据解析异常", []);
    }
  }

  Future requestDataFuture<T>(Method method, String url, {Function(T t)? onSuccess, Function(List<T> list)? onSuccessList, Function(int code, String msg)? onError, dynamic params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, bool isList = false}) async {
    String requestMethod = _getMethod(method);

    return await _request<T>(requestMethod, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken).then((BaseResponse<T> result) {
      if (result.code == ErrorStatus.REQUEST_DATA_OK) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            // onSuccess(result.data);
          }
        }
      } else {
        _onError(result.code ?? 0, result.message ?? "error", onError!);
      }
    }, onError: (e) {
      _cancelLog(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError!);
    });
  }

  BaseResponse parseError() {
    return BaseResponse(ErrorStatus.PARSE_ERROR, "数据解析错误", []);
  }

  ///用于配置Options
  Options _setOptions(String method, Options options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    options.headers = headers;
    return options;
  }

  ///请求单个对象的操作
  Future<BaseResponse<T>> request<T>(String method, String url, {Map<String, dynamic>? params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    var response = await _request<T>(method, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
    return response;
  }

  requestData<T>(Method method, String url, {Function(T t)? onSuccess, Function(List<T> t)? onSuccessList, Function(int code, String msg)? onError, Map<String, dynamic>? params, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options, bool isList = false}) async {
    String requestMethod = _getMethod(method);
    try {
      var result = await _request<T>(requestMethod, url, data: params, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      if (result.code == ErrorStatus.REQUEST_DATA_OK) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            // onSuccess(result.data);
          }
        }
      } else {
        _onError(result.code ?? 0, result.message ?? "error", onError!);
      }
    } catch (e) {
      _cancelLog(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError!);
    }
  }

  _cancelLog(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      Log.i("取消网络请求：$url");
    }
  }

  _onError(int code, String msg, Function(int code, String msg) onError) {
    if (onError != null) {
      onError(code, msg);
    }
    // Toast.show(msg);
  }

  //用于获取当前的请求类型
  String _getMethod(Method method) {
    String netMethod;
    switch (method) {
      case Method.get:
        netMethod = "GET";
        break;
      case Method.post:
        netMethod = "POST";
        break;
      case Method.put:
        netMethod = "PUT";
        break;
      case Method.delete:
        netMethod = "DELETE";
        break;
    }
    return netMethod;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

Map<String, dynamic> aexEntory(Map<String, dynamic> params, String token) {
  String dataJson = "";
  Map<String, dynamic>? dataParams;
  if (params != null) {
    dataJson = jsonEncode(params);
    String keyEn = token.split("-").first.substring(0, 16);
    Uint8List aes = AESUtil.tkAesEncrypt(dataJson, keyEn) as Uint8List;
    String hex = HexUtil.frombytesAsHexString(aes);
    dataParams = {"a": hex};
  }
  return dataParams ?? {};
}

List aexDectory(Response response, String token) {
  var resData = jsonDecode(response.data);
  // Log.i("data1112233===${resData}");
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

    // Log.i("data1112233===${resData}");

    if (resData is List) {
      result = resData;
    } else {
      result = [resData];
    }
  }

  // Log.i("+========${result}");

  return result;
}

enum Method {
  get,
  post,
  put,
  delete,
}
