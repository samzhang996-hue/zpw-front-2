import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/main.dart';
import 'package:zpw/modules/vip/view/custom_face_dialog_utils.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/network/network_util.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

class HandleTool {
  static final HandleTool _singleInstance = HandleTool._internal();

  static HandleTool get instance => HandleTool();

  factory HandleTool() {
    return _singleInstance;
  }

  /// init
  HandleTool._internal() {}

  bool isEnterRestPage = false;

  /// 是否登陆
  bool isLogin = false;

  /// 是否会员
  bool isMember = false;
  int type = 0;

  /// 是否购买30天会员
  bool isSignTask = false;
  bool isShow = false;
  int failCount = 0;
  bool isArCore = false;

  /// 记录一下日记日期
  String recordDate = "";

  String channel = "android";
  String headImg = "";

  // Map<String, dynamic> configData = <String, dynamic>{
  //   "QWYHXY": "",
  //   "QWYSXY": "",
  //   "QWHYXY": "",
  //   "PHONE": "",
  // }.obs;
  String yHxy = "http://imgser.zyykj168.com/xyhtml/ai_yhxy.html";
  String ySxy = "http://imgser.zyykj168.com/xyhtml/ai_ysxy.html";
  String hYxy = "http://imgser.zyykj168.com/xyhtml/ai_hyxy.html";
  String pHone = "4000732899";
  String gz = "http://imgser.zyykj168.com/xyhtml/SX_YK_GZSM.html";
  // /// 获取协议
  // getConfigWithKey() {
  //   QDSGet(Api.config_getConFigByTypeList,
  //       isShowProgress: false, params: {"key": "QWYHXY,QWYSXY,QWHYXY,PHONE"},
  //       success: (isSuccess, code, message, results) {
  //     if (isSuccess == true && results.isNotEmpty) {
  //       configData = results[0] as Map<String, dynamic>;
  //     }
  //     // Log.i("results=====>${results}");
  //   });
  // }
  Future<bool> compareTimesWithServer(String serverTimeString) async {
    // 获取当前设备时间
    DateTime currentTime = DateTime.now();

    // 将服务端时间字符串解析为 DateTime 对象
    // 注意：这里假设服务端时间已经是 UTC 时间，或者与设备时区一致
    // 如果不是，你可能需要进行时区转换
    DateTime serverTime = DateTime.parse(serverTimeString);

    // 比较两个时间
    bool result = currentTime.isBefore(serverTime);

    print('当前时间: ${currentTime.toLocal()}'); // 转换为本地时间显示，但比较时使用 UTC 或相同时区的时间
    print('服务端时间: $serverTime');
    print('比较结果: $result');

    return result;
  }

  getProtocolConfig() {
    SMWPost(Api.center_getProtocolConfig, isShowProgress: false,
        success: (isSuccess, code, message, results) {
      Log.d("config---$isSuccess----$results");
      if (isSuccess == true && results is List<dynamic> && results.isNotEmpty) {
        // 遍历 results 列表,提取 configType 和 configValue
        for (Map<String, dynamic> item in results) {
          int configType = item['configType'];
          String configValue = item['configValue'];
          // 根据 configType 获取对应的 configValue
          if (configType == 1) {
            // 用户协议 URL
            yHxy = configValue;
          } else if (configType == 4) {
            // 隐私政策 URL
            ySxy = configValue;
          } else if (configType == 5) {
            // 会员协议 URL
            hYxy = configValue;
          } else if (configType == 6) {
            // 手机号
            pHone = configValue;
          } else if (configType == 7) {
            // 规则
            gz = configValue;
          }
        }
      }
    });
  }

  static showAppToastText(String message,
      {ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(msg: message, gravity: gravity);
  }

  static String TKString(dynamic t) {
    if (t == null) {
      return "";
    }
    if (t is int || t is double) {
      return t.toString().isEmpty ? "0" : t.toString();
    } else if (t is String) {
      return t;
    }
    return t;
  }

  /// 存
  static saveDataWithKey(String key, Object object) async {
    String type = object.runtimeType.toString();
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "String") {
      await prefs.setString(key, object as String);
    } else if (type == "List<String>") {
      await prefs.setStringList(key, object as List<String>);
    }
    // Log.i("type====>${type}");
  }

  /// 删除
  static deleteDataWithKey(String key, {String? type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// 取
  static getDataWithKey(String key, {String? type}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    /// 默认取字符串
    if (type == null) {
      return prefs.getString(key) ?? "";
    }

    if (type == "List") {
      return prefs.getStringList(key) ?? <String>[];
    }

    Log.i("type====>$type");
  }

  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行 ；locale：当前手机语言；textScaleFactor：手机系统可以设置字体大小（默认1.0）
  static double calculateTextHeight(String value, fontSize,
      FontWeight fontWeight, double maxWidth, int maxLines) {
    value = filterText(value);
    TextPainter painter = TextPainter(

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(navigatorKey.currentContext!),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.height;
  }

  static String filterText(String text) {
    String tag = '<br>';
    while (text.contains('<br>')) {
      // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }

  /// 秒转时分秒
  static String second2HMS(int sec, {bool isEasy = true}) {
    String hms = "00:00";
    if (!isEasy) hms = "00时00分00秒";
    if (sec > 0) {
      int h = sec ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      hms = "${zeroFill(m)}:${zeroFill(s)}";
      if (h > 0) {
        hms = "${zeroFill(h)}:${zeroFill(m)}:${zeroFill(s)}";
      }
      // if(h)
      // Log.i("hms=====>${h}");
      if (!isEasy) hms = "${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
    }
    return hms;
  }

  ///补零
  static String zeroFill(int i) {
    return i >= 10 ? "$i" : "0$i";
  }

  String dateTimeTrans({bool isNeed = false}) {
    String timeZone = 'Asia/Shanghai';
    final detroit = tz.getLocation(timeZone);
    DateTime now = tz.TZDateTime.now(detroit);

    // DateTime now = DateTime.now().toUtc();
    String month = now.month < 10 ? "0${now.month}" : now.month.toString();
    String day = now.day < 10 ? "0${now.day}" : now.day.toString();
    String date = "${now.year}-$month-$day";
    if (isNeed == true) {
      String hour = now.hour < 10 ? "0${now.hour}" : now.hour.toString();
      String minute =
          now.minute < 10 ? "0${now.minute}" : now.minute.toString();
      String second =
          now.second < 10 ? "0${now.second}" : now.second.toString();
      date = "$date $hour:$minute:$second";
    }
    return date;
  }

  /// 查询版本更新
  packagesGetForcePackage({bool isShowProgress = false}) async {
    String channel = await SpUtils.getString("channel");
    if (Platform.isAndroid) {
      channel = channel.isEmpty ? await getChannelInfo(3) : channel;
    } else {
      channel = "AIIOS";
    }
    String projectId = await getChannelInfo(2);
    Map<String, dynamic> map = {
      "channel": channel,
      "projectId": projectId,
    };

    Log.i("map====>$map");

    QDSGet(Api.appPackage_latestPackage,
        isShowProgress: isShowProgress,
        params: map, success: (isSuccess, code, message, results) {
      Log.i("版本=====>$results $channel");
      if (isSuccess && results.isNotEmpty) {
        /// 获取本地版本
        isCheckUpdateAction(results.first as Map);
      }
    });
  }

  SMWPost<T>(String url,
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
  QDSGet<T>(String url,
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

  Future<T?> QDSUpload<T>(
    String url, {
    Object? params,
    onModel,
  }) {
    return DioUtils.instance.upload<T>(
      url,
      params: params,
      onModel: onModel,
    );
  }

  /// 检查是否更新
  isCheckUpdateAction(Map map) async {
    if (map["versionCode"] == null) {
      Log.i("===== 没有更新信息=======");
      HandleTool.showAppToastText("当前已是最新版本");
      if (isShow) {
        isShow = false;
      }
      return;
    }

    String versionCode = map["versionCode"] ?? "";
    String version = map["version"].toString();
    String isForce = map["isForce"].toString();
    String fileUrl = map["fileUrl"] ?? "";
    String appendInformation = map["appendInformation"] ?? "";

    /// 本地
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    String localBuildnumber = packageInfo.buildNumber;

    /// 比对
    int localNum = int.parse("${localVersion.replaceAll(".", "")}");
    int serviceNum =
        int.parse("${version.replaceAll(".", "").replaceAll(" ", "")}");
    if (serviceNum > localNum) {
      // Log.i("22233111");
      /// 需要更新
      _showUpdateDialog(isForce == "1" ? true : false, versionCode,
          appendInformation, fileUrl);
    } else {
      if (isShow) {
        HandleTool.showAppToastText("当前已是最新版本");
        isShow = false;
      }

      Log.i("===== 1没有更新信息 $localVersion $localBuildnumber=======");
    }
  }

  ///Flutter侧处理升级对话框
  ///[forcedUpgrade] 是否强制升级
  _showUpdateDialog(bool forcedUpgrade, String newVersion,
      String appendInformation, String fileUrl) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: !forcedUpgrade,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !forcedUpgrade,
          child: AlertDialog(
            title: CommText(
              text: "发现新版本 $newVersion",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            content: CommText(
                fontSize: 15,
                textColor: ColorPlate.sixThreeColor,
                text: appendInformation),
            actions: <Widget>[
              if (!forcedUpgrade)
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        // color: ColorPlate.themeColor,
                        border: Border.all(color: const Color(0xffA2AAAE)),
                        borderRadius: BorderRadius.circular(15)),
                    child: CommText(
                      text: "取消",
                      fontSize: 14,
                      textColor: const Color(0xffA2AAAE),
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  _appUpdate(fileUrl);
                },
                child: Container(
                  height: 30,
                  width: 80,
                  margin: const EdgeInsets.only(left: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorPlate.themeColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: CommText(
                    text: "升级",
                    fontSize: 14,
                    textColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _appUpdate(String url) {
    if (url.isEmpty) {
      Log.i("===== 无下载链接= ====");
      return;
    }

    UpdateModel model = UpdateModel(
      url,
      "qdsApp.apk",
      "ic_launcher",
      'https://itunes.apple.com/cn/app/id${6477259144}?mt=8',
    );
    AzhonAppUpdate.update(model).then((value) => debugPrint('$value'));
  }

  /// 返回当前系统
  getCurrentSystem() {
    String systemDevice = "none";
    if (Platform.isIOS) {
      systemDevice = "ios";
    } else if (Platform.isAndroid) {
      systemDevice = "android";
    }

    return systemDevice;
  }

  Future<String> _imageToBase64(String imagePath) async {
    // 读取图片文件
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();

    // 将图片字节转换为Base64字符串
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  void checkImgAndSave(String? path, {void Function()? success}) async {
    if (path == null) {
      return;
    }
    if (path.isNotEmpty == true) {
      // getApplicationCacheDirectory()

      final cacheDir = await getApplicationCacheDirectory();
      File old = File(path);
      final fileExtension = extension(Uri.parse(path).path);
      final myHeadImg = "my_ai_www_head$fileExtension";
      final filePath = '${cacheDir.path}/$myHeadImg';
      old.copySync(filePath);
      SpUtils.setString("my_ai_head", filePath);
      Log.e("filePath:$filePath");
      File xx = File(filePath);
      Log.e("xx:${xx.existsSync()}");
      HandleTool.instance.headImg = filePath;
      // CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
      // return;
      final imgBase64 = await _imageToBase64(path);

      final params = {"imgBase64": imgBase64};
      HandleTool.instance.SMWPost(
        Api.imgHaveFace,
        params: params,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            success?.call();
          } else {
            CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
          }
        },
      );

      return;
    }
  }
}
