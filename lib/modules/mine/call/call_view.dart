import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'call_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPage extends BaseStatefulWidget {
  final logic = Get.put(CallLogic());
  final state = Get.find<CallLogic>().state;

  @override
  BaseWidgetState<CallPage> getState() => _CallPageState();
}

class _CallPageState extends BaseWidgetState<CallPage> {
  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(title: "联系客服"),
          InkWell(
            onTap: () {
              toUrl();
            },
            child: Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              height: 86.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffF9F9F9)),
              child: Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Image.asset(
                    "online.png".mine,
                    width: 50.w,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommText(
                              text: "在线客服",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Color(0xff191919),
                            ),
                            CommText(
                              text: "工作日：09:30-18:00",
                              fontSize: 14.sp,
                              textColor: Color(0xff999999),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              launchPhone(HandleTool.instance.pHone);
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              width: double.infinity,
              height: 86.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffF9F9F9)),
              child: Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Image.asset(
                    "call.png".mine,
                    width: 50.w,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommText(
                              text: "电话客服",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Color(0xff191919),
                            ),
                            CommText(
                              text: HandleTool.instance.pHone,
                              fontSize: 14.sp,
                              textColor: Color(0xff999999),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
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
  }

  Future<void> toUrl() async {
    await launch('https://web.jiaxincloud.com/wechat.html?id=dgrvaxn1ndd5zg&appName=xlx025&appChannel=20002&appid=wxfd35345e9614a46d&wechat=true');
  }

  void launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
