import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Log {
  static const perform = MethodChannel("x_log");

  static var logger = Logger();

  static d(String msg) {
    logger.d(msg);
  }

  static w(String msg) {
    logger.w(msg);
  }

  static i(String msg) {
    logger.i(msg);
  }

  static e(String msg) {
    logger.e(msg);
  }

  static json(
    String msg,
  ) {
    try {
      logger.f(msg);
    } catch (e) {
      d(msg);
    }
  }
}
