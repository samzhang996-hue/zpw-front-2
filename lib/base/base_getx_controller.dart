// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zpw/network/network_util.dart';
import 'package:zpw/utils/handle_tool.dart';

class BaseGetxController extends GetxController {
  /// post 请求
  Post<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)?
          success,
      Function(int totalCount)? totalCount,
      Map<String, dynamic>? params,
      onModel,
      bool isShowError = true,
      bool isShowProgress = true,
      bool isCancleToken = false}) {
    ///创建取消标志
    CancelToken cancelToken = CancelToken();
    DioUtils.instance.post<T>(url,
        success: (isSuccess, code, message, resulsts) {
      if (code == -1004) {
        HandleTool.deleteDataWithKey("token");
      } else {
        if (success != null) {
          success(isSuccess, code, message, resulsts);
        }
      }
    },
        successTotalCount: totalCount,
        params: params,
        onModel: onModel,
        isShowProgress: isShowProgress,
        isShowError: isShowError,
        cancelToken: cancelToken,
        isCancleToken: isCancleToken);
  }

  /// get
  get<T>(String url,
      {Function(bool isSuccess, int code, String message, List<T> results)?
          success,
      Function(int totalCount)? totalCount,
      Map<String, dynamic>? params,
      onModel,
      bool isShowError = true,
      bool isShowProgress = true,
      bool isCancleToken = false}) {
    ///创建取消标志
    CancelToken cancelToken = CancelToken();
    DioUtils.instance.get<T>(url, success: (isSuccess, code, message, results) {
      if (code == -1004) {
        HandleTool.deleteDataWithKey("token");
      } else {
        if (success != null) {
          success(isSuccess, code, message, results);
        }
      }
    },
        successTotalCount: totalCount,
        params: params,
        onModel: onModel,
        isShowProgress: isShowProgress,
        isShowError: isShowError,
        cancelToken: cancelToken,
        isCancleToken: isCancleToken);
  }
}
