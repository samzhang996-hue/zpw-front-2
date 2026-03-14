// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zpw/network/zpw_network_util.dart';
import 'package:zpw/network/zpw_net_result.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwBaseGetxController extends GetxController {
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
    ZpwDioUtils.instance.post<T>(url,
        success: (isSuccess, code, message, resulsts) {
      if (code == -1004) {
        ZpwHandleTool.deleteDataWithKey("token");
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
    ZpwDioUtils.instance.get<T>(url, success: (isSuccess, code, message, results) {
      if (code == -1004) {
        ZpwHandleTool.deleteDataWithKey("token");
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

  /// async/await 版本的 POST 请求
  Future<ZpwNetResult<T>> postAsync<T>(
    String url, {
    Map<String, dynamic>? params,
    T Function(Map<String, dynamic>)? onModel,
    bool isShowProgress = true,
    bool isShowError = true,
  }) async {
    final result = await ZpwDioUtils.instance.postAsync<T>(
      url,
      params: params,
      onModel: onModel,
      isShowProgress: isShowProgress,
      isShowError: isShowError,
    );
    if (result.code == -1004) {
      ZpwHandleTool.deleteDataWithKey("token");
    }
    return result;
  }

  /// async/await 版本的 GET 请求
  Future<ZpwNetResult<T>> getAsync<T>(
    String url, {
    Map<String, dynamic>? params,
    T Function(Map<String, dynamic>)? onModel,
    bool isShowProgress = true,
    bool isShowError = true,
  }) async {
    final result = await ZpwDioUtils.instance.getAsync<T>(
      url,
      params: params,
      onModel: onModel,
      isShowProgress: isShowProgress,
      isShowError: isShowError,
    );
    if (result.code == -1004) {
      ZpwHandleTool.deleteDataWithKey("token");
    }
    return result;
  }
}