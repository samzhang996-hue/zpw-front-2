import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

class ZpwUpgrade extends StatefulWidget {
  const ZpwUpgrade({
    super.key,
    required this.forcedUpgrade,
    required this.newVersion,
    required this.appendInformation,
    required this.fileUrl,
  });

  final bool forcedUpgrade;
  final String newVersion;
  final String appendInformation;
  final String fileUrl;

  @override
  State<ZpwUpgrade> createState() => _ZpwUpgradeState();
}

class _ZpwUpgradeState extends State<ZpwUpgrade> {
  bool _zpwIsUpdating = false; // 是否正在更新
  double _zpwProgress = 0.0; // 下载进度
  String zpwMsg = "版本更新中，请耐心等待";
  @override
  void initState() {
    super.initState();
    // 提前请求安装权限
    _requestInstallPermission();
  }

  // 请求安装权限
  Future<void> _requestInstallPermission() async {
    if (Platform.isAndroid) {
      await Permission.requestInstallPackages.request();
    }
  }

  // 开始下载
  Future<void> _startDownload() async {
    if (Platform.isAndroid) {
      // 请求存储权限
      if (await Permission.storage.request().isGranted) {
        setState(() {
          _zpwIsUpdating = true;
        });

        // 获取下载目录
        final directory = await getExternalStorageDirectory();
        final path = directory?.path;

        if (path == null) {
          ZpwLog.e("无法获取下载目录");
          return;
        }

        // APK 文件路径
        final filePath = '$path/zpwApp.apk';

        // 使用 Dio 下载文件
        final dio = Dio();
        try {
          await dio.download(
            widget.fileUrl,
            filePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                setState(() {
                  _zpwProgress = received / total; // 更新下载进度
                  zpwMsg = "版本更新中，请耐心等待";
                });
              }
            },
          );
          if (_zpwProgress == 1.0) {
            setState(() {
              zpwMsg = "下载完成,等待安装中"; // 更新下载进度
            });
          }
          // 下载完成后安装 APK
          await _installApk(filePath);
        } catch (e) {
          ZpwLog.e("下载或安装失败: $e");
          setState(() {
            _zpwIsUpdating = false;
            zpwMsg = "安装失败"; // 更新下载进度
          });
        }
      } else {
        ZpwLog.e("存储权限被拒绝");
      }
    } else if (Platform.isIOS) {
      // iOS 不支持直接下载 APK
      ZpwLog.i("iOS 不支持直接下载 APK，请跳转到 App Store");
    }
  }

  // 安装 APK 文件
  Future<void> _installApk(String filePath) async {
    ZpwLog.i("apk--------------11$filePath");
    if (Platform.isAndroid) {
      // 请求安装未知来源应用的权限
      final result = await Permission.requestInstallPackages.request();
      if (result.isGranted) {
        const types = {
          '.apk': 'application/vnd.android.package-archive',
          '.exe': 'application/octet-stream',
        };
        final extension = p.extension(filePath);
        await OpenFile.open(filePath, type: types[extension]);
        // ZpwLog.i("apk--------------$filePath");

        // // 确保文件完全写入
        // await Future.delayed(Duration(seconds: 1));

        // // 检查文件是否存在
        // final file = File(filePath);
        // if (await file.exists()) {
        //   // 使用 install_plugin 安装 APK
        //   try {
        //     await InstallPlugin.installApk(filePath);
        //     ZpwLog.i("APK 安装成功");
        //   } catch (e) {
        //     ZpwLog.e("APK 安装失败: $e");
        //   }
        // } else {
        //   ZpwLog.e("文件不存在: $filePath");
        // }
      } else {
        ZpwLog.e("安装未知来源应用的权限被拒绝");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.forcedUpgrade,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'upgrade.png'.comm,
                          fit: BoxFit.cover,
                          width: 295.w,
                          height: 154.w,
                        ),
                        Container(
                          width: 295.w,
                          height: 231.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.w),
                                bottomRight: Radius.circular(10.w),
                              )),
                        )
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.w),
                        child: SizedBox(
                          height: 430.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 140.w),
                              Center(
                                child: Text(
                                  '${widget.newVersion}更新通知',
                                  style: TextStyle(fontSize: 18.sp, color: const Color(0xFF333333), fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 8.w),
                              Container(
                                height: 130.w,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 6.w),
                                child: Html(
                                  data: widget.appendInformation,
                                  onLinkTap: (url, attributes, element) async {
                                    if (url != null) {
                                      final Uri uri = Uri.parse(url);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    }
                                  },
                                ),
//                                 WebViewWidget(
//                                     controller: WebViewController()
//                                       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//                                       ..setNavigationDelegate(
//                                         NavigationDelegate(
//                                           onProgress: (int progress) {},
//                                           onPageStarted: (String url) {},
//                                           onPageFinished: (String url) {},
//                                           onWebResourceError: (WebResourceError error) {},
//                                           onNavigationRequest: (NavigationRequest request) {
//                                             return NavigationDecision.navigate;
//                                           },
//                                         ),
//                                       )
//                                       ..loadHtmlString("""<!DOCTYPE html>
// <html lang="en">
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title></title>
// </head>
// <body style="background-color:transparent;">
//     ${widget.appendInformation}
// </body>
// </html>""")),
                              ),
                              SizedBox(height: 8.w),
                              if (!_zpwIsUpdating) // 如果不在更新中，显示按钮
                                Row(
                                  children: [
                                    if (!widget.forcedUpgrade)
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: Get.back,
                                        child: Container(
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.w),
                                            border: Border.all(width: 1.w, color: const Color(0xFF191919)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "下次再说",
                                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: const Color(0xFF191919)),
                                          ),
                                        ),
                                      )),
                                    if (!widget.forcedUpgrade) SizedBox(width: 22.w),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          ZpwLog.d("sj----------${widget.forcedUpgrade}");
                                          _startDownload(); // 开始下载
                                        },
                                        child: Container(
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF7EFAEF),
                                                Color(0xFF7FE1FB),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(30.w),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "立即更新",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: const Color(0xFF191919),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_zpwIsUpdating) // 如果在更新中，显示进度条
                                Column(
                                  children: [
                                    Text(
                                      '${(_zpwProgress * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                                    ),
                                    LinearProgressIndicator(
                                      value: _zpwProgress,
                                      backgroundColor: Color(0xffDEDEDE),
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7EE8F7)),
                                      minHeight: 10.w,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    SizedBox(height: 8.w),
                                    Text(
                                      zpwMsg,
                                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                                    ),
                                  ],
                                ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.w),
            ],
          ),
        ),
      ),
    );
  }
}