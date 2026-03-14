import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_ads_config.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/modules/mine/view/zpw_custom_exit_dialog_utils.dart';

import 'zpw_setting_logic.dart';

class SettingPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<SettingPage> getState() => _SettingPageState();
}

class _SettingPageState extends ZpwBaseWidgetState<SettingPage> {
  final logic = Get.put(SettingLogic());
  final state = Get.find<SettingLogic>().state;

  @override
  void dispose() {
    Get.delete<SettingPage>();
    super.dispose();
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
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
                    zpwYAppBar(title: "设置"),
                    commItem("ID", '${userInfoBean.id}', hideArrow: true),
                    commItem("昵称", '${userInfoBean.nickName}', hideArrow: true),
                    // commItem("手机号", userInfoBean.userPhone ?? '去绑定', hideArrow: userInfoBean.userPhone?.isEmpty == true),
                    commItem("微信", userInfoBean.wxNickName ?? '', hideArrow: true),
                    commItem("注销账号", ""),

                    // InkWell(
                    //   onTap: () {
                    //     logic.getChannel();
                    //   },
                    //   child: Obx(() {
                    //     return ZpwCommText(
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
                          posId: ZpwAdsConfig.zpwBannerId,
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
                minimum: EdgeInsets.only(bottom: 16.w),
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
                      SizedBox(height: 10.w),
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

              // case "手机号":
              //   logic.bindPhone();
              //   break;
              // case "微信":
              //   logic.bindWx();
              //   break;
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
                ZpwCommText(
                  text: tag,
                  textColor: const Color(0xff7E8293),
                  fontSize: 13.sp,
                ),
                if (!hideArrow)
                  Image.asset(
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
