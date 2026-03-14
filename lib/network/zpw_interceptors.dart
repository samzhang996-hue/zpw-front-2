import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

import 'exception/zpw_error_status.dart';

///头部管理拦截器
class ZpwAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // String token = await ZpwSpUtils.getString("token");
    // ZpwLog.d("token--$token");
    String token = await ZpwSpUtils.getString("token");
    String channel = await ZpwSpUtils.getString("channel");
    String projectId = await ZpwSpUtils.getString("projectId");
    // // String projectId = await getProjectId();
    // // String channel = await getChannelInfo();
    // await ZpwSpUtils.setString("channel", channel);
    // await ZpwSpUtils.setString("projectId", projectId);
    print("token--$token");
    options.headers["Accept"] = "application/json";
    options.headers["User-Agent"] = "insomnia/6.4.1";
    options.headers["Authorization"] = token;
    options.headers["projectId"] = projectId;
    options.headers["channel"] = channel;
    options.headers["version"] = ZpwHandleTool.instance.zpwLocalVersion;
    print("options.headers--${options.headers}");
    super.onRequest(options, handler);
  }
}

///日志拦截器设置
class ZpwLoggingInterceptor extends Interceptor {
  DateTime? zpwStartTime;
  DateTime? zpwEndTime;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    zpwStartTime = DateTime.now();
    ZpwLog.d("----------Request Start---------");

    ///用于拼接打印出请求的全路径
    if (options.queryParameters.isEmpty) {
      if (options.path.contains(options.baseUrl)) {
        ZpwLog.i("RequestUrl:${options.path}");
      } else {
        ZpwLog.i("RequestUrl:${options.baseUrl}${options.path}");
      }
    } else {
      ///如果queryParameters 不为空则拼接成完整的URl
      ZpwLog.i("RequestUrl:${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}");
    }
    // ZpwLog.d("RequestMethod:" + options.method);
    // ZpwLog.d("RequestHeaders:" + options.headers.toString());
    // ZpwLog.d("RequestContentType:" + options.contentType.toString());
    // ZpwLog.d("RequestData:${options.data.toString()}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    zpwEndTime = DateTime.now();
    //请求时长
    int duration = zpwEndTime!.difference(zpwStartTime!).inMilliseconds;
    ZpwLog.d("----------End 共用 $duration 毫秒---------");
//    ZpwLog.d(response.data);
    return super.onResponse(response, handler);
  }

  @override
  onTKError(DioError err) {
    ZpwLog.d("--------------Error-----------");
    return super.onError(err, ErrorInterceptorHandler());
  }
}

//解析数据的拦截器
class ZpwAdapterInterceptor extends Interceptor {
  static const String zpwMsg = "msg";
  static const String zpwSlash = "\"";
  static const String zpwMessage = "message";
  static const String zpwError = "validateError";

  static const String zpwDefault = "\"无返回信息\"";
  static const String zpwNotFound = "未查询到信息";

  static const String zpwFailureFormat = "{\"code\":%d,\"message\":\"%s\"}";
  static const String zpwSuccessFormat = "{\"code\":0,\"data\":%s,\"message\":\"\"}";

  Function(String)? zpwErrHandler;
  ZpwAdapterInterceptor({this.zpwErrHandler});
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
    if (zpwErrHandler != null) {
      zpwErrHandler!(err.toString());
    }
    return super.onError(err, handler);
  }

  @override
  Response adapterData(Response response) {
    String result;
    String content = response.data == null ? "" : response.data.toString();
    if (response.statusCode == ZpwErrorStatus.zpwSuccess) {
      if (content.isEmpty) {
        content = zpwDefault;
      }
      result = sprintf(zpwSuccessFormat, [content]);
      response.statusCode = ZpwErrorStatus.zpwSuccess;
    } else {
      result = sprintf(zpwFailureFormat, [response.statusCode, zpwNotFound]);
      response.statusCode = ZpwErrorStatus.zpwSuccess;
    }
    if (response.statusCode == ZpwErrorStatus.zpwSuccess) {
      ZpwLog.d("ResponseCode:${response.statusCode}");
    } else {
      ZpwLog.e("ResponseCode:${response.statusCode}");
    }
    ZpwLog.json(result);
    response.data = result;
    return response;
  }
}