import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_ads_config.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/common/view/my_web_view/zpw_my_web_view_view.dart';
import 'package:zpw/modules/mine/zpw_mine_logic.dart';
import 'package:zpw/modules/mine/sf/zpw_sf_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

import 'zpw_about_logic.dart';

class ZpwAboutPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwAboutPage> getState() => _ZpwAboutPageState();
}

class _ZpwAboutPageState extends ZpwBaseWidgetState<ZpwAboutPage> {
  final logic = Get.put(ZpwAboutLogic());
  final state = Get.find<ZpwAboutLogic>().state;

  @override
  void dispose() {
    Get.delete<ZpwAboutPage>();
    super.dispose();
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(onDoubleTap: logic.onDoubleTap, child: zpwYAppBar(title: "关于我们")),
          commItem("用户协议", ""),
          commItem("隐私政策", ""),
          commItem("会员协议", ""),
          commItem("算法公示", ""),
          Obx(() {
            return commItem("清理缓存", state.size.value);
          }),
          Obx(() {
            return commItem("检查更新", state.version.value, showUpdate: true);
          }),
          GetBuilder<ZpwMineLogic>(
            builder: (mineLogic) {
              return Visibility(
                visible: ZpwHandleTool.instance.channelLogin && ZpwHandleTool.instance.isEmpty(mineLogic.state.userInfoBean.nickName),
                child: commItem("切换账号", ""),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 20.h),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdBannerWidget(
                posId: ZpwAdsConfig.bannerId,
                width: 345,
                interval: 5,
                show: true,
              ),
            ),
          ),
        ],
      ),
    );
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
                ZpwCommText(
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
                ZpwCommText(
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
                      ZpwHandleTool.showAppToastText("账号或者密码不能为空");
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
                      child: ZpwCommText(
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
    bool showUpdate = false,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        InkWell(
          onTap: () {
            switch (title) {
              case "切换账号":
                _showLoginBottomSheet(context);
                break;
              case "用户协议":
                String htmlStr = ZpwHandleTool.instance.yHxy;
                if (htmlStr.isEmpty) {
                  return;
                }
                zpwGotoPushPage(
                  ZpwMyWebViewPage(
                    titleStr: "用户协议",
                    htmlUrl: ZpwHandleTool.instance.yHxy,
                  ),
                );
                break;
              case "隐私政策":
                String htmlStr = ZpwHandleTool.instance.ySxy;
                if (htmlStr.isEmpty) {
                  return;
                }
                zpwGotoPushPage(
                  ZpwMyWebViewPage(
                    titleStr: "隐私政策",
                    htmlUrl: ZpwHandleTool.instance.ySxy,
                  ),
                );
                break;
              case "会员协议":
                String htmlStr = ZpwHandleTool.instance.hYxy;
                if (htmlStr.isEmpty) {
                  return;
                }
                zpwGotoPushPage(
                  ZpwMyWebViewPage(
                    titleStr: "会员协议",
                    htmlUrl: ZpwHandleTool.instance.hYxy,
                  ),
                );
                break;
              case "算法公示":
                zpwGotoPushPage(ZpwSfPage());
                break;
              case "清理缓存":
                logic.clearCache();
                break;
              case "检查更新":
                ZpwHandleTool.instance.packagesGetForcePackage(isShowProgress: true);
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
                ZpwCommText(
                  text: title,
                  textColor: const Color(0xff191919),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                Obx(() => Visibility(
                      visible: logic.isUpdate.isTrue && showUpdate,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        margin: EdgeInsets.only(right: 4.w),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    )),
                ZpwCommText(
                  text: tag,
                  textColor: const Color(0xff7E8293),
                  fontSize: 13.sp,
                ),
                hideArrow
                    ? const SizedBox(width: 21)
                    : Image.asset(
                        "zpw_arrow.png".mine,
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
