import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/comm_bottom_tips.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/modules/wf/makewst/makewst_view.dart';
import 'package:zpw/utils/handle_tool.dart';

import 'wst_logic.dart';

class WstPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => WstPageState();
}

class WstPageState extends BaseWidgetState with AppMixin {
  final logic = Get.put(WstLogic());
  final state = Get.find<WstLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Column(children: [
                YAppBar(
                    title: "文生图",
                    right: InkWell(
                        onTap: () async {
                          if ((await wxLogin() == true)) {
                            gotoPushPage(WorksPage());
                          }
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(margin: EdgeInsets.all(10.w), child: QdsImageCorner(state.showImgGif.value, double.infinity, 458.w, 16.w, fit: BoxFit.cover)),
                        Container(
                          margin: EdgeInsets.all(10.w),
                          width: double.infinity,
                          decoration: BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(16.w)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 13.w, top: 15.w),
                                  child: CommText(
                                    text: "提示词Prom",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    textColor: Colors.black,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 8.w, left: 13.w, right: 13.w, bottom: 16.w),
                                  child: CommText(
                                    text: state.funcValue.value,
                                    fontSize: 14.sp,
                                    textColor: Color(0xff818181),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80.w,
                        )
                      ],
                    ),
                  ),
                )
              ]),
              Positioned(
                bottom: 16.w,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        if ((await wxLogin() == true)) {
                          if (HandleTool.instance.isMember) {
                            gotoPushPage(MakewstPage(), arguments: {"funcValue": state.funcValue.value, "funcId": state.funcId.value});
                          } else {
                            gotoPushPage(VipPage());
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        width: double.infinity,
                        height: 52.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.circular(26)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "tk.png".comm,
                              width: 26.w,
                              height: 26.w,
                            ),
                            CommText(
                              text: "做同款",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              textColor: Color(0xff191919),
                            )
                          ],
                        ),
                      ),
                    ),
                    const CommBottomTips()
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
