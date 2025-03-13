import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/utils/log_utils.dart';

class Upgrade extends StatefulWidget {
  const Upgrade({
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
  State<Upgrade> createState() => _UpgradeState();
}

class _UpgradeState extends State<Upgrade> {
  // late final _list = [
  //   '通过APP扫描即可快速下载',
  //   '优化已知问题，使用体验更流畅',
  //   '新版本支持一键上传，体验飞速度',
  // ];

  // late final _list = widget.appendInformation.split('');
  _appUpdate() async {
    if (Platform.isIOS) {
      // const appStoreUrl =
      //     'https://apps.apple.com/cn/app/%E9%97%AA%E7%98%A6%E8%BD%BB%E6%96%AD%E9%A3%9F/id6477259144';

      // if (await canLaunch(appStoreUrl)) {
      //   await launch(appStoreUrl);
      // } else {
      //   HandleTool.showAppToastText('无法打开App Store链接,请联系客服');
      // }
      return;
    }

    if (widget.fileUrl.isEmpty) {
      Log.i("===== 无下载链接= ====");
      return;
    }

    UpdateModel model = UpdateModel(
      widget.fileUrl,
      "zpwApp.apk",
      "ic_launcher",
      'https://itunes.apple.com/cn/app/id${6477259144}?mt=8',
    );
    AzhonAppUpdate.update(model).then((value) => debugPrint('$value'));
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
                            )
                          ),
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
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: const Color(0xFF333333),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              // SizedBox(height: 10.w),
                              // Center(
                              //   child: RichText(
                              //       text: TextSpan(children: [
                              //     TextSpan(
                              //         text: widget.newVersion,
                              //         style: TextStyle(
                              //           fontSize: 13.sp,
                              //           color: const Color(0xFF666666),
                              //         ))
                              //   ])),
                              // ),
                              SizedBox(height: 8.w),
                              Container(
                                height: 130.w,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 6.w),
                                child: WebViewWidget(
                                    controller: WebViewController()
                                      ..setJavaScriptMode(
                                          JavaScriptMode.unrestricted)
                                      ..setNavigationDelegate(
                                        NavigationDelegate(
                                          onProgress: (int progress) {
                                            // Update loading bar.
                                          },
                                          onPageStarted: (String url) {},
                                          onPageFinished: (String url) {},
                                          onWebResourceError:
                                              (WebResourceError error) {},
                                          onNavigationRequest:
                                              (NavigationRequest request) {
                                            return NavigationDecision.navigate;
                                          },
                                        ),
                                      )
                                      ..loadHtmlString("""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
</head>
<body style="background-color:transparent;">
    ${widget.appendInformation}
</body>
</html>""")),

                                //       Padding(
                                //         padding: EdgeInsets.only(bottom: 8.w),
                                //         child: InAppWebView(
                                //           initialData: InAppWebViewInitialData(
                                //               data: """<!DOCTYPE html>
                                // <html lang="en">
                                // <head>
                                //     <meta charset="UTF-8">
                                //     <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                //     <title></title>
                                // </head>
                                // <body style="background-color:transparent;">
                                //     <p>1.新增支付和圈子文化</p><p>2.加油加油</p>
                                // </body>
                                // </html>"""),
                                //         ),
                                //       ),
                              ),
                              SizedBox(height: 8.w),
                              Row(
                                children: [
                                  if (!widget.forcedUpgrade)
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: Get.back,
                                      child: Container(
                                        height: 48.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                          border: Border.all(width: 1.w,color: const Color(0xFF191919)),
                                          // color: const Color(0xFFF4F5F9),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "下次再说",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF191919)),
                                        ),
                                      ),
                                    )),
                                  SizedBox(width: 22.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        _appUpdate();
                                      },
                                      child: Container(
                                        height: 48.w,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFF7EFAEF),
                                            Color(0xFF7FE1FB),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end:  Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.w),
                                         
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "立即更新",
                                          style: TextStyle(
                                            fontSize:  18.sp,
                                            color: const Color(0xFF191919),
                                            fontWeight: 
                                                FontWeight.w600
                                               ,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              //   Center(
                              //     child: CommButton(
                              //       title: '下次再说',
                              //       type: CommButtonType.cancel,
                              //       onTap: Get.back,
                              //     ),
                              //   )
                              // else
                              //   Center(
                              //     child: CommButton(
                              //       title: '立即更新',
                              //       onTap: () {
                              //         Get.back();
                              //         _appUpdate();
                              //       },
                              //     ),
                              //   ),
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
