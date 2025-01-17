import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'setting_logic.dart';

class SettingPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<SettingPage> getState() => _SettingPageState();
}

class _SettingPageState extends BaseWidgetState<SettingPage> {

  final logic = Get.put(SettingLogic());
  final state = Get.find<SettingLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(title: "设置"),
          commItem("清理缓存", "22"),
          commItem("注销账号", ""),
          commItem("检查更新", "22"),
        ],
      ),
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
              case "清理缓存":
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
