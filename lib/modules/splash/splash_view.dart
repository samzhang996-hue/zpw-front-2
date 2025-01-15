import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  @override
  void dispose() {
    Get.delete<SplashPage>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SpUtils.getBool("isAgreed").then((value) {
      Log.i("splash--$value");
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
            Log.i("splash2--$agreed");
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
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          "splash.png".comm,
          fit: BoxFit.fill,
        ));
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
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: ColorPlate.sixThreeColor),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          "感谢您信任我们的产品！\n我们非常重视您的隐私和个人信息保护。\n在您使用亲，请认真阅读：《隐私政策》及《用户协议》。我们将严格按照前述政策，为您提供更好的服务。如您同意改隐私政策，请点击“同意”并开始使用我们的产品集服务。",
                      style: TextStyle(
                          fontSize: 14, color: ColorPlate.sixSixColor),
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
                          String htmlStr =
                              HandleTool.instance.ySxy;
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
                      text: "、",
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
                          String htmlStr =
                              HandleTool.instance.yHxy;
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
                      text:
                          "内容，我们将严格按照政策为您提供更好的服务。如果您同意本隐私政策，请点击“同意”并开始使用我们的产品。",
                      style: TextStyle(
                          fontSize: 14, color: ColorPlate.sixSixColor),
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
                    color: const Color(0xff4F7FF3),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      '同意',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorPlate.sixNineColor),
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
