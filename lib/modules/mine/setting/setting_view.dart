import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/view/custom_exit_dialog_utils.dart';
import 'package:zpw/utils/handle_tool.dart';

import 'setting_logic.dart';

class SettingPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<SettingPage> getState() => _SettingPageState();
}

class _SettingPageState extends BaseWidgetState<SettingPage> {
  final logic = Get.put(SettingLogic());
  final state = Get.find<SettingLogic>().state;

  @override
  void dispose() {
    Get.delete<SettingPage>();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<SettingLogic>(builder: (logic) {
      final userInfoBean = logic.mineLogic.state.userInfoBean;
      return Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    YAppBar(title: "设置"),
                    commItem("ID", '${userInfoBean.id}', hideArrow: true),
                    commItem("昵称", '${userInfoBean.nickName}', hideArrow: true),
                    commItem("手机号", userInfoBean.userPhone ?? '去绑定', hideArrow: true),
                    commItem("微信", "", hideArrow: true),
                    commItem("注销账号", ""),

                    Visibility(
                      visible: HandleTool.instance.channelLogin,
                      child: commItem("切换账号", ""),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     logic.getChannel();
                    //   },
                    //   child: Obx(() {
                    //     return CommText(
                    //       text: "V${state.version.value}    ${state.channel.value}",
                    //       textColor: Color(0xffcccccc),
                    //     );
                    //   }),
                    // ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 20.h),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AdBannerWidget(
                          posId: AdsConfig.bannerId,
                          width: 345,
                          interval: 5,
                          show: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                minimum: EdgeInsets.symmetric(vertical: 10.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: logic.onExit,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0x12999999),
                            borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          ),
                          height: 52.w,
                          alignment: Alignment.center,
                          child: Text(
                            '退出登录',
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: const Color(0xFF999999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void _showLoginBottomSheet(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许弹窗滚动
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // 添加滚动支持
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 避免键盘遮挡
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommText(
                  text: "账号",
                  textColor: Color(0xff1A1A1A),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                SizedBox(height: 12.w),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _usernameController, // 绑定控制器
                    decoration: InputDecoration(
                      hintText: "请输入您的账号",
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xffB3B3B3),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.w,
                      ),
                      border: InputBorder.none, // 去掉默认边框
                    ),
                  ),
                ),
                SizedBox(height: 14.w),
                CommText(
                  text: "密码",
                  textColor: Color(0xff1A1A1A),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                SizedBox(height: 12.w),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController, // 绑定控制器
                    decoration: InputDecoration(
                      hintText: "请输入您的密码",
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xffB3B3B3),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.w,
                      ),
                      border: InputBorder.none, // 去掉默认边框
                    ),
                  ),
                ),
                SizedBox(height: 20.w),
                InkWell(
                  onTap: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    if (username.isEmpty || password.isEmpty) {
                      HandleTool.showAppToastText("账号或者密码不能为空");
                      return;
                    }
                    logic.accountLogin(username, password);
                  },
                  child: Container(
                    height: 54.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Center(
                      child: CommText(
                        text: "登录",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        textColor: Color(0xff1A1A1A),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget commItem(
    String title,
    String tag, {
    bool hideArrow = false,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        InkWell(
          onTap: () {
            switch (title) {
              case "注销账号":
                CustomExitDialogUtils.showCustomDialog(
                    context: context,
                    onPressed: () {
                      logic.deleteUser();
                    });
                break;
              case "切换账号":
                _showLoginBottomSheet(context);
                break;
            }
          },
          child: Container(
            height: 40.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16.w,
                ),
                CommText(
                  text: title,
                  textColor: const Color(0xff191919),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                CommText(
                  text: tag,
                  textColor: const Color(0xff7E8293),
                  fontSize: 13.sp,
                ),
                hideArrow
                    ? const SizedBox(width: 21)
                    : Image.asset(
                        "arrow.png".mine,
                        width: 21,
                      ),
                SizedBox(
                  width: 16.w,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
