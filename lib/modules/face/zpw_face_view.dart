import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_qds_image.dart';
import 'package:zpw/modules/face/zpw_collection_item.dart';
import 'package:zpw/modules/face/zpw_face_logic.dart';
import 'package:zpw/modules/face/zpw_gather_single_page.dart';
import 'package:zpw/modules/mine/zpw_mine_logic.dart';
import 'package:zpw/modules/vip/zpw_vip_logic.dart';
import 'package:zpw/modules/vip/zpw_vip_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwFacePage extends StatefulWidget {
  const ZpwFacePage({super.key});

  @override
  State<ZpwFacePage> createState() => _ZpwFacePageState();
}

class _ZpwFacePageState extends State<ZpwFacePage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(ZpwFaceLogic());
  final state = Get.find<ZpwFaceLogic>().state;

  var outHeight = 0.0.w;
  late PageController? page = PageController();

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(() {
      ZpwHandleTool.showAppToastText("当前页面涉及隐私，不允许截图");
    }, (isCaptured) {
      ZpwHandleTool.showAppToastText("当前页面涉及隐私，不允许录屏");
    });
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      ZpwHandleTool.showAppToastText("当前页面涉及隐私，不允许录屏");
    }
  }

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) {
      _addListenerPreventScreenshot();
      _preventScreenshotOn();
      _checkScreenRecording();
    }
  }

  @override
  void dispose() {
    if (kReleaseMode) {
      _removeListenerPreventScreenshot();
      _preventScreenshotOff();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "zpw_face_bg.png".face,
            width: 1.sw,
            height: 371.w,
            fit: BoxFit.cover,
          ),
          GetBuilder<ZpwFaceLogic>(builder: (logic) {
            if (logic.tabController == null) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                Container(
                  width: 1.sw,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil().statusBarHeight + 10.w),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "zpw_face_photo.png".face,
                              width: 50.w,
                              height: 25.w,
                              fit: BoxFit.cover,
                            ),
                            GetBuilder<ZpwMineLogic>(builder: (mineLogic) {
                              return Visibility(
                                visible: !ZpwHandleTool.instance.isMember,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.find<ZpwVipLogic>().getVipHome();
                                    Get.to(() => ZpwVipPage());
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Image.asset(
                                    "zpw_face_vip.png".face,
                                    width: 65.w,
                                    height: 26.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.w),
                      if (logic.listPhotoGroupBean.isNotEmpty)
                        SizedBox(
                          height: 90.w,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: logic.listPhotoGroupBean.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (c, index) {
                                final bean = logic.listPhotoGroupBean[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ZpwGatherSinglePage(
                                        id: bean.id ?? 0,
                                        imgUrlAcross: bean.imgUrlAcross ?? "",
                                        title: bean.groupName ?? "",
                                      ),
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 182.w,
                                    height: 90.w,
                                    margin: EdgeInsets.only(
                                        left: 16.w,
                                        right: index == 2 ? 16.w : 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.w),
                                      child: ZpwQdsImage(
                                        "${bean.imgUrlAcross}",
                                        182.w,
                                        90.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      PreferredSize(
                        preferredSize: Size.fromHeight(46.w),
                        child: Container(
                          width: double.maxFinite,
                          height: 36.w,
                          // padding: EdgeInsets.only(left: 15.w, right: 15.w),
                          margin: EdgeInsets.only(bottom: 10.w),
                          child: TabBar(
                            tabAlignment: TabAlignment.center,
                            tabs: logic.listPhotoGroupBean2
                                .map((e) => Tab(text: "${e.groupName}"))
                                .toList(),
                            onTap: (index) {
                              // page.animateTo(index, duration: duration, curve: curve)
                              UmengCommonSdk.onEvent('Face_click_event', {
                                'Tab':
                                    '${logic.listPhotoGroupBean2[index].toJson()}'
                              });
                              page?.jumpToPage(index);
                            },
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                            controller: logic.tabController,
                            indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(50.w), // Creates border
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7EFAEF),
                                    Color(0xFF7FE1FB),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: const Color(0xFF191919),
                            isScrollable: true,
                            labelStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF191919),
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF656565),
                            ),
                            dividerColor: Colors.transparent,
                            // dividerHeight:0,
                            unselectedLabelColor:
                                const Color(0xFF656565), //未选中的颜色
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: page,
                    children: logic.listPhotoGroupBean2
                        .map((e) => ZpwCollectionItem(id: e.id ?? 0))
                        .toList(),
                    onPageChanged: (index) {
                      logic.tabController?.animateTo(index);
                    },
                  ),
                )
              ],
            );
          })
        ],
      ),
    );
  }
}

class ZpwCustomScrollPhysics extends BouncingScrollPhysics {
  final double friction;

  ZpwCustomScrollPhysics({this.friction = 0.6, ScrollPhysics? parent})
      : super(parent: parent);

  @override
  ZpwCustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ZpwCustomScrollPhysics(
        friction: friction, parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 使用 friction 值来调整滑动的灵敏度
    return super.applyPhysicsToUserOffset(position, offset) * friction;
  }
}
