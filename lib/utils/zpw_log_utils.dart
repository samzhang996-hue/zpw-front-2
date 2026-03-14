import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ZpwLog {
  static const zpwPerform = MethodChannel("x_log");

  static var zpwLogger = Logger();

  static d(String msg) {
    zpwLogger.d(msg);
  }

  static w(String msg) {
    zpwLogger.w(msg);
  }

  static i(String msg) {
    zpwLogger.i(msg);
  }

  static e(String msg) {
    zpwLogger.e(msg);
  }

  static json(
    String msg,
  ) {
    try {
      zpwLogger.f(msg);
    } catch (e) {
      d(msg);
    }
  }
}