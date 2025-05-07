import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/view/comm_text.dart';

import 'sf_logic.dart';

class SfPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => _SfPageState();
}

class _SfPageState extends BaseWidgetState {
  final logic = Get.put(SfLogic());

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YAppBar(title: "算法公示备案"),
            SizedBox(
              height: 18.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommText(
                    text: "算法名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "豆包大模型算法 ",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "网信算备110108823483901230031号",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "模型名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "豆包大模型",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "Beijing-YunQue-20230821",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "算法名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "火山引擎人脸融合算法",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  CommText(
                    text: "网信算备110108823483901230073号",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
