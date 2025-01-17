import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/vip/view/custom_sure_vip_dialog_utils.dart';
import 'package:zpw/modules/vip/view/gradient_border_painter.dart';
import 'vip_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VipPage extends BaseStatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  BaseWidgetState<BaseStatefulWidget> getState() => _VipPageState();
}

class _VipPageState extends BaseWidgetState {
  final logic = Get.put(VipLogic());
  final state = Get.find<VipLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: Colors.red,
                width: double.infinity, // 或者使用父容器的宽度约束
                height: 644.h, // 使用屏幕高度的百分比
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 398.h, // 使用屏幕高度的百分比
                ),
                height: 247.h, // 使用屏幕高度的百分比
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00000000), // 透明
                      Color(0xff000000), // 黑色
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Color(0xff070704),
                  child: Column(
                    children: [
                      _listViewWidget(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: CommText(
                            text: "按周期会员自动续费,可随时关闭",
                            fontSize: 12.sp,
                            textColor: Color(0xff6F6F6F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 47.h,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "zfb.png".vip,
                                    width: 26.w,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  CommText(
                                    text: "支付宝支付",
                                    fontSize: 15.w,
                                    textColor: Color(0xffFFD9D0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Image.asset(
                                    "un_check.png".vip,
                                    width: 14.w,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 47.h,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "wx.png".vip,
                                    width: 26.w,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  CommText(
                                    text: "微信支付",
                                    fontSize: 15.w,
                                    textColor: Color(0xffFFD9D0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Image.asset(
                                    "un_check.png".vip,
                                    width: 14.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          CustomSureVipDialogUtils.showCustomDialog(context: context, onPressed: (){

                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 17.h, right: 17.h, top: 17.h),
                              height: 54.h,
                              width: double.infinity,
                              decoration: BoxDecoration(color: const Color(0xffFF2E7E), borderRadius: BorderRadius.circular(27)),
                              child: Center(
                                  child: CommText(
                                text: "立即开通并支付",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                              )),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 17.h),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 183.w,
                                    height: 27.h,
                                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage("vip_btn_tip.png".vip), fit: BoxFit.cover)),
                                    child: CommText(
                                      text: "立享13个月，折合7.5元/月",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: Colors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 17.h, top: 10.h, bottom: 25.h),
                        child: Row(
                          children: [
                            Image.asset(
                              "un_check.png".vip,
                              width: 14.w,
                            ),
                            CommText(
                              text: "点击购买即表示您同意",
                              fontSize: 12.sp,
                              textColor: Color(0xff646464),
                            ),
                            CommText(
                              text: "《会员协议》",
                              fontSize: 12.sp,
                              textColor: Colors.white,
                            ),
                            CommText(
                              text: "《自动续费协议》",
                              fontSize: 12.sp,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ), // 使用屏幕高度的百分比
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listViewWidget() {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
      height: 165.h,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(left: 9.w),
              child: Stack(
                children: [
                  Container(
                    height: 146.h,
                    child: Container(
                      width: 114.w,
                      height: 136.h,
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Color(0xFF141414),
                          border: Border.all(
                            color: Color(0xFFFF85B4),
                            width: 2.0, // 你可以根据需要调整边框宽度
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CommText(
                            text: "连续包月",
                            fontSize: 15.sp,
                            textColor: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CommText(
                                    text: "¥",
                                    fontSize: 13.sp,
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CommText(
                                  text: "188",
                                  fontSize: 27.sp,
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          CommText(
                            text: "原价399元",
                            fontSize: 12.sp,
                            textColor: Color(0xff6F6F6F),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 内层 Container，使用 Positioned 定位
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        height: 24.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14.0),
                            bottomRight: Radius.circular(14),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF2EB8), Color(0xFFFF2E2E)],
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: 8, right: 8),
                          child: Center(
                            child: CommText(
                              text: "新人福利",
                              fontSize: 12.sp,
                              textColor: Colors.white,
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
