import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/common/view/my_web_view/zpw_my_web_view_view.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/vip/view/countdown_timer2.dart';
import 'package:zpw/modules/vip/view/custom_sure_vip_dialog_utils.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class CustomExitVipDialogUtils2 {
  static void showCustomDialog({
    required BuildContext context,
    required Function() onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final logic = Get.find<VipLogic>();
        final state = Get.find<VipLogic>().state;
        var vipPriceVos = state.vipBean.vipPopList;
        var rk1 = vipPriceVos?[0].remark1 ?? "";
        var rk2 = vipPriceVos?[0].remark2 ?? "";
        var rk3 = vipPriceVos?[0].remark3 ?? "";
        var rk4 = vipPriceVos?[0].remark4 ?? "";
        var rk5 = vipPriceVos?[0].remark5 ?? "";
        var rk8 = vipPriceVos?[0].remark8 ?? "";
        var rk9 = vipPriceVos?[0].remark9 ?? "";
        var agreemenType = vipPriceVos?[0]?.vipPriceOutput?.agreemenType ?? 0;
        var iosProductId = vipPriceVos?[0]?.vipPriceOutput?.iosProductId ?? 0;
        state.payKeyType =
            vipPriceVos?[0]?.vipPriceOutput?.defaultPayKeyType ?? 0;
        state.goodsId = vipPriceVos?[0]?.vipPriceOutput?.id ?? 0;
        // bool? isDjs = vipPriceVos?[0].remark6?.isNotEmpty;
        // bool? isXf = vipPriceVos?[0].remark9?.isNotEmpty;
        return StatefulBuilder(// 使用 StatefulBuilder 包裹对话框内容
            builder: (context, setState) {
          return Center(
            child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                          width: double.infinity.w,
                          height: 60.w,
                          margin: EdgeInsets.only(right: 39.w),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              "zpw_close.png".comm,
                              width: 24.w,
                            ),
                          )),
                      onTap: () {
                        if (state.type == 1) {
                          Navigator.of(context).pop();
                          Get.offAll(() => const MainPage());
                        } else {
                          Navigator.of(context).pop();
                          Get.back();
                        }
                      },
                    ),
                    Stack(
                      children: [
                        // Positioned(
                        //   top: *10.w,
                        //   child: Container(
                        //   child: Image.asset("zpw_close.png".comm,width:24.w,height: 24.w, ),
                        // ),),
                        Container(
                          width: 320.w,
                          height: 338.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "zpw_vip_update.png".comm,
                                  ),
                                  fit: BoxFit.cover)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: rk4.isEmpty ? 0 : 1,
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 70.w, left: 15.w),
                                    height: 26.w,
                                    width: 100.w,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(14.0),
                                        bottomRight: Radius.circular(14),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFFF75),
                                          Color(0xFFFFC243)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w),
                                      child: Center(
                                        child: ZpwCommText(
                                          text: rk4,
                                          fontSize: 14.sp,
                                          textColor: Color(0xff191919),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 25.w, right: 26.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: ZpwCommText(
                                                text: "¥",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.sp,
                                                textColor: Color(0xffFF7000),
                                              ),
                                              margin: EdgeInsets.only(top: 8.w),
                                            ),
                                            ZpwCommText(
                                              text: rk3,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32.sp,
                                              textColor: Color(0xffFF7000),
                                            ),
                                          ],
                                        ),
                                        ZpwCommText(
                                          text: rk5,
                                          fontSize: 13.sp,
                                          textColor: Color(0xff999999),
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ZpwCommText(
                                          text: rk1,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          textColor: Color(0xff191919),
                                        ),
                                        SizedBox(
                                          height: 15.w,
                                        ),
                                        ZpwCommText(
                                          text: rk2,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          textColor: Color(0xff818181),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ZpwCommText(
                                      text: "距优惠结束还有",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      textColor: Color(0xff191919),
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    CountdownTimer2(
                                      onCountdownComplete: () {
                                        setState(() {
                                          // showCountdown = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 12.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return InkWell(
                                        child: Image.asset(
                                          state.isCheck.value
                                              ? "zpw_checked.png".vip
                                              : "zpw_un_check.png".vip,
                                          width: 15.w,
                                        ),
                                        onTap: () {
                                          if (state.isCheck.value) {
                                            logic.onSelected(false);
                                          } else {
                                            logic.onSelected(true);
                                          }
                                        },
                                      );
                                    }),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      child: ZpwCommText(
                                        text: "点击购买即表示您同意",
                                        fontSize: 12,
                                        textColor: const Color(0xff808080),
                                      ),
                                      onTap: () {
                                        if (state.isCheck.value) {
                                          logic.onSelected(false);
                                        } else {
                                          logic.onSelected(true);
                                        }
                                      },
                                    ),
                                    InkWell(
                                      child: ZpwCommText(
                                        text: "《会员协议》",
                                        fontSize: 12,
                                        textColor: const Color(0xff808080),
                                      ),
                                      onTap: () {
                                        String htmlStr =
                                            ZpwHandleTool.instance.hYxy;
                                        if (htmlStr.length > 0) {
                                          Get.to(
                                            ZpwMyWebViewPage(
                                              titleStr: "会员协议",
                                              htmlUrl: htmlStr,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 22.w, right: 22.w, top: 12.w),
                                  height: 48.w,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                      child: ZpwCommText(
                                    text: rk8,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    textColor: Color(0xff191919),
                                  )),
                                ),
                                onTap: () {
                                  if (state.isCheck.value) {
                                    if (agreemenType == 2) {
                                      logic.addUserAgreementOrder();
                                    } else {
                                      logic.addOrder();
                                    }
                                  } else {
                                    CustomSureVipDialogUtils.showCustomDialog(
                                        context: context,
                                        onPressed: () {
                                          logic.onSelected(true);
                                          if (Platform.isIOS) {
                                            logic.buyEngin
                                                .buyProduct(iosProductId);
                                            return;
                                          }
                                          if (agreemenType == 2) {
                                            logic.addUserAgreementOrder();
                                          } else {
                                            logic.addOrder();
                                          }
                                        });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              Center(
                                  child: ZpwCommText(
                                text: rk9,
                                fontSize: 10.sp,
                                textColor: Color(0xffCECDCD),
                                fontWeight: FontWeight.w400,
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
      },
    );
  }
}
