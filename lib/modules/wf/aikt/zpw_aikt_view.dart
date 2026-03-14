import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_qds_image.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/mine/works/zpw_works_view.dart';
import 'package:zpw/modules/vip/zpw_vip_view.dart';
import 'package:zpw/modules/wf/aikt/view/zpw_my_slider.dart';
import 'package:zpw/utils/zpw_dowload.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

import 'zpw_aikt_logic.dart';

class ZpwAiktPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwBaseStatefulWidget> getState() => _ZpwAiktPageState();
}

class _ZpwAiktPageState extends ZpwBaseWidgetState with ZpwAppMixin {
  final logic = Get.put(ZpwAiktLogic());
  final state = Get.find<ZpwAiktLogic>().state;

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          zpwYAppBar(
              title: "扩图",
              right: InkWell(
                  onTap: () async {
                    if ((await zpwWxLogin() == true)) {
                      zpwGotoPushPage(ZpwWorksPage());
                    }
                  },
                  child: ZpwCommText(
                    text: "我的作品",
                    fontSize: 13.sp,
                    textColor: Color(0xff191919),
                    fontWeight: FontWeight.bold,
                  ))),
          Obx(() {
            return state.text.value == "保存图片"
                ? ZpwQdsImage(state.path.value, 358.w, 531.w)
                : Image.file(
                    File(state.path.value),
                    width: 358.w,
                    height: 531.w,
                  );
          }),
          Obx(() {
            return Opacity(
              opacity: state.text.value == "保存图片" ? 0 : 1,
              child: Container(
                margin: EdgeInsets.only(top: 20.w, left: 16.w),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: ZpwCommText(
                      text: "比例",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      textColor: Color(0xff191919),
                    )),
              ),
            );
          }),
          SizedBox(
            height: 10.w,
          ),
          Obx(() {
            return Opacity(
              opacity: state.text.value == "保存图片" ? 0 : 1,
              child: ZpwMySlider(
                onValueChanged: (value) {
                  state.outPaintRatio.value = value;
                },
              ),
            );
          }),
          InkWell(
            onTap: () async {
              UmengCommonSdk.onEvent('Aikt_click_event', {'name': ''});
              if ((await zpwWxLogin() == true)) {
                if (!ZpwHandleTool.instance.isMember) {
                  zpwGotoPushPage(ZpwVipPage());
                  return;
                }
                if (state.text.value == "保存图片") {
                  downloadAndSaveMedia(state.path.value, (res) {
                    if (res) {
                      Get.back();
                    }
                  });
                } else {
                  logic.outPaint(state.outPaintRatio.value);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 26.w),
              height: 51.w,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(child: Obx(() {
                return ZpwCommText(
                  text: state.text.value,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  textColor: Color(0xff191919),
                );
              })),
            ),
          )
        ],
      ),
    );
  }
}
