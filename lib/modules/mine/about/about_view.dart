import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'about_logic.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
class AboutPage extends BaseStatefulWidget {
  final logic = Get.put(AboutLogic());
  final state = Get.find<AboutLogic>().state;

  @override
  BaseWidgetState<AboutPage> getState() => _AboutPageState();
}

class _AboutPageState extends BaseWidgetState<AboutPage> {
  @override
  void dispose() {
    Get.delete<AboutPage>();
    super.dispose();
  }
  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(title: "关于我们"),
          commItem("用户协议", ""),
          commItem("隐私政策", ""),
          commItem("会员协议", ""),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 20.h),
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
              case "用户协议":
                String htmlStr=HandleTool.instance.yHxy;
                if(htmlStr.isEmpty){
                  return;
                }
                gotoPushPage(
                  MyWebViewPage(
                    titleStr: "用户协议",
                    htmlUrl: HandleTool.instance.yHxy,
                  ),
                );
                break;
              case "隐私政策":
                String htmlStr=HandleTool.instance.ySxy;
                if(htmlStr.isEmpty){
                  return;
                }
                gotoPushPage(
                  MyWebViewPage(
                    titleStr: "隐私政策",
                    htmlUrl: HandleTool.instance.ySxy,
                  ),
                );
                break;
              case "会员协议":
                String htmlStr=HandleTool.instance.hYxy;
                if(htmlStr.isEmpty){
                  return;
                }
                gotoPushPage(
                  MyWebViewPage(
                    titleStr: "会员协议",
                    htmlUrl: HandleTool.instance.hYxy,
                  ),
                );
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
                  fontWeight: FontWeight.w500,
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
