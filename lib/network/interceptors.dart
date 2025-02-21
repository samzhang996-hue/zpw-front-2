import 'package:dio/dio.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'exception/error_status.dart';
import 'package:sprintf/sprintf.dart';

///头部管理拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // String token = await SpUtils.getString("token");
    // Log.d("token--$token");
    String token = await SpUtils.getString("token");
    String projectId = await getProjectId();
    String channel = await getChannelInfo();
    print("token--$token");
    options.headers["Accept"] = "application/json";
    options.headers["User-Agent"] = "insomnia/6.4.1";
    options.headers["Authorization"] = token;
    options.headers["projectId"] = projectId;
    options.headers["channel"] = channel;
    super.onRequest(options, handler);
  }
}

///日志拦截器设置
class LoggingInterceptor extends Interceptor {
  DateTime? startTime;
  DateTime? endTime;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startTime = DateTime.now();
    Log.d("----------Request Start---------");

    ///用于拼接打印出请求的全路径
    if (options.queryParameters.isEmpty) {
      if (options.path.contains(options.baseUrl)) {
        Log.i("RequestUrl:${options.path}");
      } else {
        Log.i("RequestUrl:${options.baseUrl}${options.path}");
      }
    } else {
      ///如果queryParameters 不为空则拼接成完整的URl
      Log.i(
          "RequestUrl:${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}");
    }
    // Log.d("RequestMethod:" + options.method);
    // Log.d("RequestHeaders:" + options.headers.toString());
    // Log.d("RequestContentType:" + options.contentType.toString());
    // Log.d("RequestData:${options.data.toString()}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    endTime = DateTime.now();
    //请求时长
    int duration = endTime!.difference(startTime!).inMilliseconds;
    Log.d("----------End 共用 $duration 毫秒---------");
//    Log.d(response.data);
    return super.onResponse(response, handler);
  }

  @override
  onTKError(DioError err) {
    Log.d("--------------Error-----------");
    return super.onError(err, ErrorInterceptorHandler());
  }
}

//解析数据的拦截器
class AdapterInterceptor extends Interceptor {
  static const String MSG = "msg";
  static const String SLASH = "\"";
  static const String MESSAGE = "message";
  static const String ERROR = "validateError";

  static const String DEFAULT = "\"无返回信息\"";
  static const String NOT_FOUND = "未查询到信息";

  static const String FAILURE_FORMAT = "{\"code\":%d,\"message\":\"%s\"}";
  static const String SUCCESS_FORMAT =
      "{\"code\":0,\"data\":%s,\"message\":\"\"}";

  Function(String)? errHandler;
  AdapterInterceptor({this.errHandler});
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Response rp = adapterData(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    if (errHandler != null) {
      errHandler!(err.toString());
    }
    return super.onError(err, handler);
  }

  @override
  Response adapterData(Response response) {
    String result;
    String content = response.data == null ? "" : response.data.toString();
    if (response.statusCode == ErrorStatus.SUCCESS) {
      if (content.isEmpty) {
        content = DEFAULT;
      }
      result = sprintf(SUCCESS_FORMAT, [content]);
      response.statusCode = ErrorStatus.SUCCESS;
    } else {
      result = sprintf(FAILURE_FORMAT, [response.statusCode, NOT_FOUND]);
      response.statusCode = ErrorStatus.SUCCESS;
    }
    if (response.statusCode == ErrorStatus.SUCCESS) {
      Log.d("ResponseCode:${response.statusCode}");
    } else {
      Log.e("ResponseCode:${response.statusCode}");
    }
    Log.json(result);
    response.data = result;
    return response;
  }
}
