import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as ffff;
import 'package:dio/src/multipart_file.dart' as ffff;
import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/main.dart';
import 'package:zpw/model/zpw_upload_bean.dart';
import 'package:zpw/modules/mine/about/about_logic.dart';
import 'package:zpw/modules/vip/view/custom_face_dialog_utils.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/network/zpw_net_result.dart';
import 'package:zpw/network/zpw_network_util.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_my_plugin.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';
import 'package:zpw/utils/zpw_upgrade.dart';

class ZpwHandleTool {
  static final ZpwHandleTool _zpwSingleInstance = ZpwHandleTool._internal();

  static ZpwHandleTool get instance => ZpwHandleTool();

  factory ZpwHandleTool() {
    return _zpwSingleInstance;
  }

  /// init
  ZpwHandleTool._internal() {}

  bool zpwIsEnterRestPage = false;

  /// 是否登陆
  bool zpwIsLogin = false;

  /// 是否会员
  bool zpwIsMember = false;
  int zpwType = 0;

  /// 是否购买30天会员
  bool zpwIsSignTask = false;
  // bool isShow = false;
  int zpwFailCount = 0;
  bool zpwIsArCore = false;

  /// 记录一下日记日期
  String zpwRecordDate = "";

  String zpwChannel = "android";
  String zpwHeadImg = "";
  String zpwToken = "";

  // Map<String, dynamic> configData = <String, dynamic>{
  //   "QWYHXY": "",
  //   "QWYSXY": "",
  //   "QWHYXY": "",
  //   "PHONE": "",
  // }.obs;
  String zpwYHxy = "http://imgser.zyykj168.com/xyhtml/ai_yhxy.html";
  String zpwYSxy = "http://imgser.zyykj168.com/xyhtml/ai_ysxy.html";
  String zpwHYxy = "http://imgser.zyykj168.com/xyhtml/ai_hyxy.html";
  String zpwPhone = "4000732899";
  String zpwGz = "http://imgser.zyykj168.com/xyhtml/SX_YK_GZSM.html";
  bool zpwChannelAds = false;
  bool zpwChannelLogin = false;

  String zpwLocalVersion = '';

  // 兼容旧属性名的 getter/setter
  String get hYxy => zpwHYxy;
  set hYxy(String value) => zpwHYxy = value;

  String get ySxy => zpwYSxy;
  set ySxy(String value) => zpwYSxy = value;

  String get yHxy => zpwYHxy;
  set yHxy(String value) => zpwYHxy = value;

  String get token => zpwToken;
  set token(String value) => zpwToken = value;

  bool get isMember => zpwIsMember;
  set isMember(bool value) => zpwIsMember = value;

  String get channel => zpwChannel;
  set channel(String value) => zpwChannel = value;

  bool get channelAds => zpwChannelAds;
  set channelAds(bool value) => zpwChannelAds = value;

  String get localVersion => zpwLocalVersion;
  set localVersion(String value) => zpwLocalVersion = value;

  String get headImg => zpwHeadImg;
  set headImg(String value) => zpwHeadImg = value;

  bool get channelLogin => zpwChannelLogin;
  set channelLogin(bool value) => zpwChannelLogin = value;

  String get pHone => zpwPhone;
  set pHone(String value) => zpwPhone = value;

  Future<Map<String, dynamic>> getMap() async {
    String idfa = "";
    String idfv = "";
    String ua = '';
    String imei = '';
    String deviceId = '';
    String channel = "AIJL300";
    String oaid = "";
    if (Platform.isAndroid) {
      String oaidStr = await ZpwSpUtils.getString("oaid");
      String deviceIdStr = await ZpwSpUtils.getString("deviceId");
      String channelStr = await ZpwSpUtils.getString("channel");
      oaid = oaidStr.isEmpty ? await getOAID() : oaidStr;
      deviceId = deviceIdStr.isEmpty ? await getDeviceId() : deviceIdStr;
      channel = channelStr.isEmpty ? await getChannelInfo() : channelStr;

      await ZpwSpUtils.setString("oaid", oaid);
      await ZpwSpUtils.setString("deviceId", deviceId);
      await ZpwSpUtils.setString("channel", channel);
    } else if (Platform.isIOS) {
      String deviceIdStr = await ZpwSpUtils.getString("deviceId");
      deviceId = deviceIdStr.isEmpty ? await FlutterUdid.udid : deviceIdStr;
      // deviceId = deviceIdStr.isEmpty ? "59245b9e42a7a51e1212" : deviceIdStr;
      ZpwSpUtils.setString("deviceId", deviceId);
      channel = "AIIOS";
    }
    ZpwHandleTool.instance.zpwChannel = channel;

    UmengCommonSdk.initCommon('', '67aeea638f232a05f113c1be', channel);
    UmengCommonSdk.setPageCollectionModeManual();
    ZpwLog.i('Device Info: $deviceId---$oaid----$channel-----${ZpwHandleTool.instance.zpwChannel}');
    if (Platform.isIOS) {
      idfa = await getIDFA();
      idfv = await getIDFV();
    }
    var androidID = '';
    if (Platform.isIOS) {
      androidID = deviceId;
    } else {
      androidID = await getAndroidID();
      if (androidID.isEmpty) {
        androidID = deviceId;
      }
      ua = await getUA();
    }

    Map<String, dynamic> dataMap = {
      "systemDevice": Platform.isAndroid ? "android" : "ios",
      "deviceCode": androidID,
      'oaid': oaid,
      'idfa': idfa,
      'imei': imei,
      'modelInfo': ua,
      "idfv": idfv,
    };
    return dataMap;
  }

  /// 判断为null 或者空字符串
  bool isEmpty(dynamic data) {
    switch (data) {
      case int _:
        return data == 0;
      case String _:
        return data.isEmpty;
      default:
        return true;
    }
  }

  /// 判断为null 或者空字符串
  bool isNotEmpty(dynamic data) {
    return !isEmpty(data);
  }

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

  Future<void> getProtocolConfig({bool isShowProgress = false}) {
    final tempComplete = Completer<void>();
    SMWPost(ZpwApi.zpwCenterGetProtocolConfig, isShowProgress: isShowProgress, success: (isSuccess, code, message, results) {
      ZpwLog.d("config---$isSuccess----$results");
      if (isSuccess == true && results is List<dynamic> && results.isNotEmpty) {
        // 遍历 results 列表,提取 configType 和 configValue
        for (Map<String, dynamic> item in results) {
          int configType = item['configType'];
          String configValue = item['configValue'];
          // 根据 configType 获取对应的 configValue
          if (configType == 1) {
            // 用户协议 URL
            zpwYHxy = configValue;
          } else if (configType == 4) {
            // 隐私政策 URL
            zpwYSxy = configValue;
          } else if (configType == 5) {
            // 会员协议 URL
            zpwHYxy = configValue;
          } else if (configType == 6) {
            // 手机号
            zpwPhone = configValue;
          } else if (configType == 7) {
            // 规则
            zpwGz = configValue;
          } else if (configType == 17) {
            zpwChannelAds = configValue == "0";
          } else if (configType == 18) {
            zpwChannelLogin = configValue == "1";
          }
        }
        // ZpwLog.e("ZpwHandleTool.instance.zpwChannelAds----1----:${ZpwHandleTool.instance.zpwChannelAds}");
        return tempComplete.complete();
      }
    });
    return tempComplete.future;
  }

  static showAppToastText(String message, {ToastGravity gravity = ToastGravity.CENTER}) {
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
    // ZpwLog.i("type====>${type}");
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

    ZpwLog.i("type====>$type");
  }

  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行 ；locale：当前手机语言；textScaleFactor：手机系统可以设置字体大小（默认1.0）
  static double calculateTextHeight(String value, fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
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
      // ZpwLog.i("hms=====>${h}");
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
      String minute = now.minute < 10 ? "0${now.minute}" : now.minute.toString();
      String second = now.second < 10 ? "0${now.second}" : now.second.toString();
      date = "$date $hour:$minute:$second";
    }
    return date;
  }

  /// 查询版本更新
  packagesGetForcePackage({bool isShowProgress = false, bool isSetting = false}) async {
    String channel = await ZpwSpUtils.getString("channel");
    if (Platform.isAndroid) {
      channel = channel.isEmpty ? await getChannelInfo() : channel;
    } else {
      channel = "AIIOS";
    }
    String projectId = await getProjectId();
    Map<String, dynamic> map = {
      "channel": channel,
      "projectId": projectId,
    };

    ZpwLog.i("map====>$map");

    QDSGet(ZpwApi.zpwAppPackageLatestPackage, isShowProgress: isShowProgress, params: map, success: (isSuccess, code, message, results) {
      ZpwLog.i("版本=====>$results $channel");
      if (isSuccess && results.isNotEmpty) {
        ZpwLog.d("app-------------${results.first}");

        /// 获取本地版本
        isCheckUpdateAction(results.first as Map, isShowProgress, isSetting);
      }
    });
  }

  SMWPost<T>(String url, {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? totalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, bool isCancleToken = false}) {
    ///创建取消标志
    CancelToken cancelToken = CancelToken();
    ZpwDioUtils.instance.post<T>(url, success: (isSuccess, code, message, resulsts) {
      if (code == -1004) {
        ZpwHandleTool.deleteDataWithKey("token");
      } else {
        if (success != null) {
          success(isSuccess, code, message, resulsts);
        }
      }
    }, successTotalCount: totalCount, params: params, onModel: onModel, isShowProgress: isShowProgress, isShowError: isShowError, cancelToken: cancelToken, isCancleToken: isCancleToken);
  }

  /// async/await 版本的 POST 请求
  Future<ZpwNetResult<T>> SMWPostAsync<T>(
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

  /// get (回调式)
  QDSGet<T>(String url, {Function(bool isSuccess, int code, String message, List<T> results)? success, Function(int totalCount)? totalCount, Map<String, dynamic>? params, onModel, bool isShowError = true, bool isShowProgress = true, bool isCancleToken = false}) {
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
    }, successTotalCount: totalCount, params: params, onModel: onModel, isShowProgress: isShowProgress, isShowError: isShowError, cancelToken: cancelToken, isCancleToken: isCancleToken);
  }

  /// async/await 版本的 GET 请求
  Future<ZpwNetResult<T>> QDSGetAsync<T>(
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

  /// upload (已经是 async/await 版本)
  Future<T?> QDSUpload<T>(
    String url, {
    Object? params,
    onModel,
  }) {
    return ZpwDioUtils.instance.upload<T>(
      url,
      params: params,
      onModel: onModel,
    );
  }

  /// 检查是否更新
  isCheckUpdateAction(Map map, bool isShowProgress, bool isSetting) async {
    if (map["versionCode"] == null) {
      ZpwLog.i("===== 没有更新信息=======");
      if (isShowProgress) {
        ZpwHandleTool.showAppToastText("当前已是最新版本");
      }
      return;
    }

    String versionCode = map["versionCode"] ?? "";
    String version = map["version"].toString();
    String isForce = map["isForce"].toString();
    String fileUrl = map["fileUrl"] ?? "";
    String appendInformation = map["notice"] ?? "";

    /// 本地
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    String localBuildnumber = packageInfo.buildNumber;

    // 去掉版本号中的 "V"（不区分大小写）并按小数点拆分
    List<String> localVersionParts = localVersion.split(".");
    List<String> serviceVersionParts = versionCode.toUpperCase().replaceAll("V", "").split(".");

    // 将每个部分转换为整数
    List<int> localVersionNumbers = localVersionParts.map((part) => int.parse(part)).toList();
    List<int> serviceVersionNumbers = serviceVersionParts.map((part) => int.parse(part)).toList();

    // 对比每个部分
    bool needUpdate = false;
    for (int i = 0; i < serviceVersionNumbers.length; i++) {
      if (i >= localVersionNumbers.length) {
        // 如果服务端版本号部分多于本地，则需要更新
        needUpdate = true;
        break;
      }
      if (serviceVersionNumbers[i] > localVersionNumbers[i]) {
        // 如果服务端当前部分大于本地，则需要更新
        needUpdate = true;
        break;
      } else if (serviceVersionNumbers[i] < localVersionNumbers[i]) {
        // 如果服务端当前部分小于本地，则不需要更新
        break;
      }
      // 如果相等，则继续对比下一部分
    }

    if (needUpdate) {
      if (isSetting) {
        final g = Get.find<AboutLogic>();
        g.isUpdate.value = true;
        return;
      }

      /// 需要更新
      showUpdateDialog(isForce == "1" ? true : false, versionCode, appendInformation, fileUrl);
    } else {
      if (isShowProgress) {
        ZpwHandleTool.showAppToastText("当前已是最新版本");
      }

      ZpwLog.i("===== 1没有更新信息 $localVersion $localBuildnumber=======");
    }
  }

  ///Flutter侧处理升级对话框
  ///[forcedUpgrade] 是否强制升级
  showUpdateDialog(bool forcedUpgrade, String newVersion, String appendInformation, String fileUrl) {
    Get.dialog(
      ZpwUpgrade(
        forcedUpgrade: forcedUpgrade,
        newVersion: newVersion,
        appendInformation: appendInformation,
        fileUrl: fileUrl,
      ),
      barrierDismissible: forcedUpgrade,
    );
    // showDialog(
    //   context: navigatorKey.currentContext!,
    //   barrierDismissible: !forcedUpgrade,
    //   builder: (BuildContext context) {
    //     return PopScope(
    //       canPop: !forcedUpgrade,
    //       child: AlertDialog(
    //         title: ZpwCommText(
    //           text: "发现新版本 $newVersion",
    //           fontSize: 16,
    //           fontWeight: FontWeight.bold,
    //         ),
    //         content: ZpwCommText(fontSize: 15, textColor: ZpwColorPlate.sixThreeColor, text: appendInformation),
    //         actions: <Widget>[
    //           if (!forcedUpgrade)
    //             InkWell(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Container(
    //                 height: 30,
    //                 width: 80,
    //                 alignment: Alignment.center,
    //                 decoration: BoxDecoration(
    //                     // color: ZpwColorPlate.themeColor,
    //                     border: Border.all(color: const Color(0xffA2AAAE)),
    //                     borderRadius: BorderRadius.circular(15)),
    //                 child: ZpwCommText(
    //                   text: "取消",
    //                   fontSize: 14,
    //                   textColor: const Color(0xffA2AAAE),
    //                 ),
    //               ),
    //             ),
    //           InkWell(
    //             onTap: () {
    //               _appUpdate(fileUrl);
    //             },
    //             child: Container(
    //               height: 30,
    //               width: 80,
    //               margin: const EdgeInsets.only(left: 15),
    //               alignment: Alignment.center,
    //               decoration: BoxDecoration(color: ZpwColorPlate.themeColor, borderRadius: BorderRadius.circular(15)),
    //               child: ZpwCommText(
    //                 text: "升级",
    //                 fontSize: 14,
    //                 textColor: Colors.white,
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  _appUpdate(String url) {
    if (url.isEmpty) {
      ZpwLog.i("===== 无下载链接= ====");
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

  void checkImgAndSave(String? path, {void Function(String headImageUrl)? success, bool bindDefaultImg = true}) async {
    if (path == null) {
      return;
    }
    if (path.isNotEmpty == true) {
      // getApplicationCacheDirectory()

      final formData = ffff.FormData.fromMap({
        "file": await ffff.MultipartFile.fromFile(path),
      });
      final bean = await ZpwHandleTool.instance.QDSUpload<ZpwUploadBean>(ZpwApi.zpwUploadFile, params: formData, onModel: (v) => ZpwUploadBean.fromJson(v));
      if (bean == null) {
        ZpwHandleTool.showAppToastText("上传失败,请重试");
        return;
      }

      if (!bindDefaultImg) {
        success?.call(bean.url ?? '');
        return;
      }

      ZpwHandleTool.instance.SMWPost('${ZpwApi.zpwBindDefaultImg}?imgUrl=${bean.url}', isShowProgress: true, success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          ZpwHandleTool.instance.zpwHeadImg = '${bean.url}';
          success?.call(bean.url ?? '');
        } else {
          CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
        }
      });

      // final cacheDir = await getApplicationCacheDirectory();
      // File old = File(path);
      // final fileExtension = extension(Uri.parse(path).path);
      // final myHeadImg = "my_ai_www_head$fileExtension";
      // final filePath = '${cacheDir.path}/$myHeadImg';
      // old.copySync(filePath);
      // ZpwSpUtils.setString("my_ai_head", filePath);
      // ZpwLog.e("filePath:$filePath");
      // File xx = File(filePath);
      // ZpwLog.e("xx:${xx.existsSync()}");
      // ZpwHandleTool.instance.zpwHeadImg = filePath;
      // // CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
      // // return;
      // final imgBase64 = await _imageToBase64(path);

      // final params = {"imgBase64": imgBase64};
      // ZpwHandleTool.instance.SMWPost(
      //   Api.imgHaveFace,
      //   params: params,
      //   success: (isSuccess, code, message, results) {
      //     if (isSuccess == true && results.isNotEmpty) {
      //       success?.call();
      //     } else {
      //       CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
      //     }
      //   },
      // );

      // return;
    }
  }

  /// async/await 版本的 checkImgAndSave
  Future<String?> checkImgAndSaveAsync(String? path, {bool bindDefaultImg = true}) async {
    if (path == null || path.isEmpty) {
      return null;
    }

    final formData = ffff.FormData.fromMap({
      "file": await ffff.MultipartFile.fromFile(path),
    });
    final bean = await ZpwHandleTool.instance.QDSUpload<ZpwUploadBean>(ZpwApi.zpwUploadFile, params: formData, onModel: (v) => ZpwUploadBean.fromJson(v));
    if (bean == null) {
      ZpwHandleTool.showAppToastText("上传失败,请重试");
      return null;
    }

    if (!bindDefaultImg) {
      return bean.url ?? '';
    }

    final result = await ZpwHandleTool.instance.SMWPostAsync(
      '${ZpwApi.zpwBindDefaultImg}?imgUrl=${bean.url}',
      isShowProgress: true,
    );
    if (result.isSuccess && result.hasData) {
      ZpwHandleTool.instance.zpwHeadImg = '${bean.url}';
      return bean.url ?? '';
    } else {
      return null;
    }
  }
}