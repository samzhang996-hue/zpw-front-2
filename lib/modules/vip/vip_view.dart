import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/modules/vip/view/custom_sure_vip_dialog_utils.dart';
import 'package:zpw/modules/vip/view/gradient_border_painter.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'vip_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VipPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => _VipPageState();
}

class _VipPageState extends BaseWidgetState {
  final logic = Get.put(VipLogic());
  final state = Get.find<VipLogic>().state;
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 使用网络视频 URL 或本地视频资产
    _controller = VideoPlayerController.asset(
      'vip.mp4'.vip,
    )
      ..setLooping(true)
      ..initialize().then((_) {
        // 确保在视频初始化完成后设置播放状态
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    Get.delete<VipPage>();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<VipLogic>(builder: (logic) {
      String? rk8;
      String? rk9;
      String? rk10;
      if (state.vipBean == null) {
        rk9 = "";
        rk10 = "";
      } else {
        if (state.vipBean.vipList?.length != 0) {
          rk9 = state.vipBean.vipList?[state.itemIndex].remark9;
          rk8 = state.vipBean.vipList?[state.itemIndex].remark8;
          rk10 = state.vipBean.vipList?[state.itemIndex].remark10;
          state.isWx = state.vipBean.vipList?[state.itemIndex].vipPriceOutput?.isWxPay ?? 0;
          state.isZfb = state.vipBean.vipList?[state.itemIndex].vipPriceOutput?.isZfbPay ?? 0;
        } else {
          rk9 = "";
          rk8 = "";
          rk10 = "";
        }
      }

      return Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: double.infinity, // 或者使用父容器的宽度约束
                  height: 644.h,
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          child: CircularProgressIndicator(),
                        ), // 使用屏幕高度的百分比
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x00000000), // 透明
                          Color(0xff000000), // 黑色
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 0.2], // 透明从0%到20%，黑色从20%到100%
                      ),
                    ),
                    child: Column(
                      children: [
                        Visibility(
                          child: _listViewWidget(),
                          visible: !(rk9 == ""),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: CommText(
                              text: rk9,
                              fontSize: 11.sp,
                              textColor: Color(0xff7E7E7E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (state.isWx == 1 && state.isZfb == 1),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Visibility(
                                  visible: state.isZfb == 1,
                                  child: Container(
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
                                ),
                                Visibility(
                                  visible: state.isWx == 1,
                                  child: Container(
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
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var vp = state.vipBean.vipList?[state.itemIndex].vipPriceOutput;
                            state.goodsId = vp?.id ?? 0;
                            state.payKeyType = vp?.defaultPayKeyType ?? 0;
                            var zfbType = vp?.defaultZfbPayKeyType ?? 0;
                            state.isWx = state.vipBean.vipList?[state.itemIndex].vipPriceOutput?.isWxPay ?? 0;
                            state.isZfb = state.vipBean.vipList?[state.itemIndex].vipPriceOutput?.isZfbPay ?? 0;
                            if (!state.isCheck.value) {
                              CustomSureVipDialogUtils.showCustomDialog(
                                  context: context,
                                  onPressed: () {
                                    logic.onSelected(true);
                                    logic.addOrder();
                                  });
                            } else {
                              logic.addOrder();
                            }
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
                                  text: rk8,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.white,
                                )),
                              ),
                              Visibility(
                                visible: !(rk10 == ""),
                                child: Container(
                                  margin: EdgeInsets.only(right: 17.h),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 183.w,
                                        height: 27.h,
                                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("vip_btn_tip.png".vip), fit: BoxFit.cover)),
                                        child: CommText(
                                          text: rk10,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          textColor: Colors.white,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20.h, top: 10.h, bottom: 25.h),
                          child: Row(
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      state.isCheck.value ? "checked.png".vip : "un_check.png".vip,
                                      width: 14.w,
                                    ),
                                    CommText(
                                      text: "点击购买即表示您同意",
                                      fontSize: 12.sp,
                                      textColor: Color(0xff646464),
                                    ),
                                  ],
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
                                onTap: () {
                                  String htmlStr = HandleTool.instance.hYxy;
                                  if (htmlStr.isEmpty) {
                                    return;
                                  }
                                  gotoPushPage(
                                    MyWebViewPage(
                                      titleStr: "会员协议",
                                      htmlUrl: HandleTool.instance.yHxy,
                                    ),
                                  );
                                },
                                child: CommText(
                                  text: "《会员协议》",
                                  fontSize: 12.sp,
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ), // 使用屏幕高度的百分比
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 80.w,
                      height: 30.h,
                      margin: EdgeInsets.only(top: 44.h, left: 14.w),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            "back.png".comm,
                            width: 16.w,
                          ))),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _listViewWidget() {
    var vipPriceVos = state.vipBean.vipList;
    if (state.vipBean == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
      height: 165.h,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        itemCount: vipPriceVos?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var vp = vipPriceVos?[index];
          bool isSelect = state.itemIndex == index;
          return InkWell(
            onTap: () {
              logic.selectItem(index);
            },
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
                            color: isSelect ? Color(0xFFFF2E7E) : Colors.transparent,
                            width: isSelect ? 2.0 : 0.0, // 你可以根据需要调整边框宽度
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CommText(
                            text: vp?.remark2,
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
                                    textColor: isSelect ? Color(0xFFFF2E7E) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CommText(
                                  text: vp?.remark3 ?? "0",
                                  fontSize: 27.sp,
                                  textColor: isSelect ? Color(0xFFFF2E7E) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          CommText(
                            text: vp?.remark4 ?? "",
                            fontSize: 12.sp,
                            textColor: Color(0xff6F6F6F),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 内层 Container，使用 Positioned 定位
                  Visibility(
                    visible: !(vp?.remark1 == "" || vp?.remark1 == null),
                    child: Positioned(
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
                                text: vp?.remark1 ?? "",
                                fontSize: 12.sp,
                                textColor: Colors.white,
                              ),
                            ),
                          )),
                    ),
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
