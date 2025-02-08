import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/wf/aikt/view/my_slider.dart';
import 'package:zpw/utils/dowload.dart';
import 'aikt_logic.dart';

class AiktPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => _AiktPageState();
}

class _AiktPageState extends BaseWidgetState {
  final logic = Get.put(AiktLogic());
  final state = Get.find<AiktLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(
              title: "扩图",
              right: InkWell(
                  onTap: () {
                    gotoPushPage(WorksPage());
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "my_work_ic.png".make,
                        width: 22.w,
                        height: 22.w,
                      ),
                      CommText(
                        text: "作品",
                        fontSize: 13.sp,
                        textColor: Color(0xff191919),
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ))),
          Obx(() {
            return state.text.value == "保存图片"
                ? QdsImage(state.path.value, 358.w, 531.w)
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
                    child: CommText(
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
              child: MySlider(
                onValueChanged: (value) {
                  state.outPaintRatio.value = value;
                },
              ),
            );
          }),
          InkWell(
            onTap: () {
              if (state.text.value == "保存图片") {
                downloadAndSaveMedia(state.path.value, (res) {
                  if (res) {
                    Get.back();
                  }
                });
              } else {
                logic.outPaint(state.outPaintRatio.value);
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 26.w),
              height: 51.w,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: ColorPlate.themeColor),
              child: Center(child: Obx(() {
                return CommText(
                  text: state.text.value,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  textColor: Colors.white,
                );
              })),
            ),
          )
        ],
      ),
    );
  }
}
