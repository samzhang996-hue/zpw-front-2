import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'splash_logic.dart';

class SplashPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<SplashPage> getState() => _SplashPageState();
}

class _SplashPageState extends BaseWidgetState<SplashPage> {
  final logic = Get.put(SplashLogic());
  final state = Get.find<SplashLogic>().state;

  // late VideoPlayerController _controller;

  @override
  void dispose() {
    // _controller.dispose();
    Get.delete<SplashPage>();
    // TODO: implement dispose
    super.dispose();
    logic.stopPolling();
  }

  @override
  void initState() {
    super.initState();
    SpUtils.getBool("isAgreed").then((value) {
      if (value == null || !value) {
        if (Platform.isIOS) {
          logic.loginWithDeviceInfo();
        } else {
          // 未同意的逻辑处理
          WidgetsBinding.instance?.addPostFrameCallback((_) async {
            final bool? agreed = await showDialog(
              context: context,
              barrierDismissible: false, // 阻止用户点击弹窗外部关闭弹窗
              builder: (BuildContext context) {
                return const UserAgreementDialog();
              },
            );

            // if (mounted) {
            //   setState(() {
            //     // 在对话框关闭后恢复视频播放
            //     if (_controller.value.isPlaying == false) {
            //       _controller.play();
            //     }
            //   });
            // }
            if (agreed != null && agreed) {
              // 用户同意了协议，执行相应操作
              logic.loginWithDeviceInfo();
            } else {
              // 用户选择不同意，退出应用程序
              SystemNavigator.pop();
            }
          });
        }
      } else {
        logic.loginWithDeviceInfo();
      }
    });
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset("splash.png".comm, fit: BoxFit.fill),
        ),
        Positioned(
          bottom: 20,
          width: Get.width,
          child: Center(
            child: Column(
              children: [
                const Text('应用启动中...', style: TextStyle(color: ColorPlate.themeColor, fontSize: 14)),
                const SizedBox(height: 10),
                Container(
                  width: 256,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    border: const GradientBoxBorder(gradient: const LinearGradient(colors: [Color(0xff7EFAEF), Color(0xff7FE1FB)]), width: 3),
                  ),
                  height: 20,
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Obx(
                        () => AnimatedContainer(
                          width: constraints.maxWidth * logic.progress.value,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            gradient: const LinearGradient(colors: [Color(0xff7EFAEF), Color(0xff7FE1FB)]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // return Container(
    //   height: double.infinity,
    //   width: double.infinity,
    //   child: _controller.value.isInitialized
    //       ? AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: VideoPlayer(_controller),
    //         )
    //       : Container(
    //           child: Container(
    //               height: double.infinity,
    //               width: double.infinity,
    //               child: Image.asset(
    //                 "splash.png".comm,
    //                 fit: BoxFit.fill,
    //               ))), // 使用屏幕高度的百分比
    // );
  }
}

///用户协议
class UserAgreementDialog extends GetWidget {
  const UserAgreementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(SplashLogic());
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 设置圆角半径为10.0
      ),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '个人信息保护',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff1A1A1A)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "欢迎使用本产品，在使用产品服务前，请仔细阅读并理解",
                      style: TextStyle(fontSize: 13, color: Color(0xff818181), fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: "《隐私政策》",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorPlate.themeColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          String htmlStr = HandleTool.instance.ySxy;
                          if (htmlStr.length > 0) {
                            Get.to(
                              MyWebViewPage(
                                titleStr: "隐私政策",
                                htmlUrl: htmlStr,
                              ),
                            );
                          }
                        },
                    ),
                    const TextSpan(
                      text: "及",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "《用户协议》",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorPlate.themeColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          String htmlStr = HandleTool.instance.yHxy;
                          if (htmlStr.length > 0) {
                            Get.to(
                              MyWebViewPage(
                                titleStr: "用户协议",
                                htmlUrl: htmlStr,
                              ),
                            );
                          }
                        },
                    ),
                    const TextSpan(
                      text: "为了给你提供更好的服务，我们将会向您申请一下权限和信息：\n1.为了帮您统计设备维度数据分析、保障软件服务的正常运行，我们需要申请获取设备信息，日志信息。\n2.我们可能会申请读取设写入手机存储权限，用于下载及缓存相关文件；相机与录音权限，用于拍摄功能。\n3.以上权限以及社戏爱你个头。相册、存储空间等敏感权限均不会默认或强制开启收集信息。\n4.我们尊重你的选择权，同时我们也为你提供注销、投诉渠道。",
                      style: TextStyle(fontSize: 13, color: Color(0xff818181), fontWeight: FontWeight.w500, height: 1.8),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0), // 设置上边距为15.0
                  decoration: BoxDecoration(
                    color: ColorPlate.themeColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      '同意并继续',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff191919)),
                    ),
                    onPressed: () {
                      Get.back(result: true);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15.0, 1.0, 15.0, 21.0),
                  // 设置上边距为10.0
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      '不同意',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xff404C4C4C)),
                    ),
                    onPressed: () {
                      Get.back(result: false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
