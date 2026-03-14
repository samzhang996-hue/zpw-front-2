import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';

import 'zpw_sf_logic.dart';

class SfPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwBaseStatefulWidget> getState() => _SfPageState();
}

class _SfPageState extends ZpwBaseWidgetState {
  final logic = Get.put(SfLogic());

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            zpwYAppBar(title: "算法公示备案"),
            SizedBox(
              height: 18.w,
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZpwCommText(
                    text: "算法名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "豆包大模型算法 ",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "网信算备110108823483901230031号",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "模型名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "豆包大模型",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "Beijing-YunQue-20230821",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "算法名称：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "火山引擎人脸融合算法",
                    fontWeight: FontWeight.w400,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
                    text: "备案号：",
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff4D4D4D),
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  ZpwCommText(
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
