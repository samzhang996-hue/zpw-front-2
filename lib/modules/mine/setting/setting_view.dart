import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/modules/mine/view/custom_exit_dialog_utils.dart';
import 'package:zpw/utils/filecache.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'setting_logic.dart';

class SettingPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<SettingPage> getState() => _SettingPageState();
}

class _SettingPageState extends BaseWidgetState<SettingPage> {
  final logic = Get.put(SettingLogic());
  final state = Get
      .find<SettingLogic>()
      .state;

  @override
  void dispose() {
    Get.delete<SettingPage>();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<SettingLogic>(builder: (logic) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            YAppBar(title: "设置"),
            Obx(() {
              return commItem("清理缓存", state.size.value);
            }),
            commItem("注销账号", ""),
            Obx(() {
              return commItem("检查更新", state.version.value);
            }),
            InkWell(
              onTap: () {
                logic.getChannel();
              },
              child: Obx(() {
                return CommText(
                  text: "V${state.version.value}    ${state.channel.value}",
                  textColor: Color(0xffcccccc),
                );
              }),
            ),
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
      );
    });
  }

  Widget commItem(String title,
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
              case "清理缓存":
                logic.clearCache();
                break;
              case "检查更新":
                HandleTool.instance.packagesGetForcePackage();
                break;
              case "注销账号":
                CustomExitDialogUtils.showCustomDialog(
                    context: context,
                    onPressed: () {
                      logic.deleteUser();
                    });

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
                  fontWeight: FontWeight.bold,
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
