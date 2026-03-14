import 'dart:io';

import 'package:dio/dio.dart';

import 'zpw_error_status.dart';

class ZpwExceptionHandle {
  static ZpwNetError handleException(dynamic error) {
    print(error);
    if (error is DioException) {
      if (error.type == DioExceptionType.unknown ||
          error.type == DioExceptionType.badResponse) {
        dynamic e = error.error;

        ///网络异常
        if (e is SocketException) {
          return ZpwNetError(ZpwErrorStatus.zpwSocketError, "网络异常，请检查网络...");
        }

        ///服务器异常
        if (e is HttpException) {
          return ZpwNetError(ZpwErrorStatus.zpwServerError, "服务器异常...");
        }
        //默认返回网络异常
        return ZpwNetError(ZpwErrorStatus.zpwNetworkError, "网络异常，请检查网络...");

        ///各种超时
      }
          else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return ZpwNetError(ZpwErrorStatus.zpwTimeoutError, "连接超时...");

        ///取消请求操作
      } else if (error.type == DioExceptionType.cancel) {
        return ZpwNetError(ZpwErrorStatus.zpwCancelError, "");

        //其他异常
      } else {
        return ZpwNetError(ZpwErrorStatus.zpwUnknownError, "未知异常...");
      }
    } else {
      return ZpwNetError(ZpwErrorStatus.zpwUnknownError, "未知异常...");
    }
  }
}

class ZpwNetError {
  int zpwCode;
  String zpwMsg;

  ZpwNetError(this.zpwCode, this.zpwMsg);
}