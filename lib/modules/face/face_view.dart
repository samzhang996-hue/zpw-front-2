import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/modules/face/face_logic.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key});

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(FaceLogic());
  final state = Get.find<FaceLogic>().state;
  late ScrollController? _scrollViewController = ScrollController();
  var outHeight = 0.0.w;
  late PageController? page = PageController();
  Color _backgroundColor = Colors.transparent; // 初始背景色为透明
  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(() {
      HandleTool.showAppToastText("当前页面涉及隐私，不允许截图");
    }, (isCaptured) {
      HandleTool.showAppToastText("当前页面涉及隐私，不允许录屏");
    });
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      HandleTool.showAppToastText("当前页面涉及隐私，不允许录屏");
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollViewController?.addListener(() {
      double? offset = _scrollViewController?.offset;

      if ((offset! >= (kToolbarHeight - 36.w - 6.w - 10.w)) == true) {
        // 滚动到最顶部时，背景色为淡紫色
        setState(() {
          _backgroundColor = Colors.white;
        });
      } else {
        // 否则，背景色透明
        setState(() {
          _backgroundColor = Colors.transparent;
        });
      }
    });

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
            "face_bg.png".face,
            width: 1.sw,
            height: 371.w,
            fit: BoxFit.cover,
          ),
          GetBuilder<FaceLogic>(builder: (logic) {
            if (logic.tabController == null) {
              return const SizedBox.shrink();
            }

            return NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    leading: Container(),
                    floating: false,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.white, // Navigation bar
                      statusBarColor: Colors.transparent, // Status bar
                    ),
                    expandedHeight: 70.w +
                        outHeight +
                        (logic.listPhotoGroupBean.isEmpty ? 0 : 110.w),
                    backgroundColor: _backgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        color: Colors.transparent,
                        width: 1.sw,
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: kToolbarHeight),
                            SizedBox(
                                height: ScreenUtil().statusBarHeight + 10.w),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "face_photo.png".face,
                                    width: 50.w,
                                    height: 25.w,
                                    fit: BoxFit.cover,
                                  ),
                                  GetBuilder<MineLogic>(builder: (mineLogic) {
                                    return Visibility(
                                      visible: !HandleTool.instance.isMember,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.find<VipLogic>().getVipHome();
                                          Get.to(() => VipPage());
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Image.asset(
                                          "face_vip.png".face,
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
                                      final bean =
                                          logic.listPhotoGroupBean[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => GatherSinglePage(
                                              id: bean.id ?? 0,
                                              imgUrlAcross:
                                                  bean.imgUrlAcross ?? "",
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
                                            borderRadius:
                                                BorderRadius.circular(8.w),
                                            child: QdsImage(
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
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(46.w),
                      child: Container(
                        width: double.maxFinite,
                        height: 36.w,
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        margin: EdgeInsets.only(bottom: 10.w),
                        child: TabBar(
                          tabAlignment: TabAlignment.center,
                          tabs: logic.listPhotoGroupBean2
                              .map((e) => Tab(text: "${e.groupName}"))
                              .toList(),
                          // tabs: const [
                          //   Tab(text: "热门推荐"),
                          //   Tab(text: "经典角色"),
                          //   Tab(text: "男神专属"),
                          //   Tab(text: "雪季❄️"),
                          //   Tab(text: "合照❤️"),
                          // ],
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF191919),
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF656565),
                          ),
                          dividerColor: Colors.transparent,
                          // dividerHeight:0,
                          unselectedLabelColor:
                              const Color(0xFF656565), //未选中的颜色
                        ),
                      ),
                    ),
                  )
                ];
              },
              // body: TabBarView(
              //   controller: _tabController,
              //   children: getTabContent(),
              // ),
              body: PageView(
                controller: page,

                children: logic.listPhotoGroupBean2
                    // .map((e) => FaceItem(id: e.id ?? 0))
                    .map((e) => CollectionItem(id: e.id ?? 0))
                    .toList(),
                // [
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                //     // color: Colors.red,
                //     child: GridView.builder(
                //       padding: EdgeInsets.zero,
                //       itemBuilder: (c, index) {
                //         return GestureDetector(
                //           onTap: () {
                //             // Navigator.of(context).push(
                //             //   MaterialPageRoute(
                //             //     builder: (context) {
                //             //       return const GatherPage();
                //             //     },
                //             //   ),
                //             // );
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: index.isOdd ? Colors.amber : Colors.red,
                //               borderRadius: BorderRadius.circular(8.w),
                //             ),
                //             child: Stack(
                //               children: [
                //                 Image.asset(
                //                   index.isEven
                //                       ? "face_item_2.png".face
                //                       : "face_item_1.png".face,
                //                   width: 175.w,
                //                   height: 265.w,
                //                   fit: BoxFit.cover,
                //                 ),
                //                 Center(
                //                   child: Column(
                //                     children: [
                //                       SizedBox(height: 10.w),
                //                       Text(
                //                         "照片拥抱",
                //                         style: TextStyle(
                //                           color: const Color(0xFF191919),
                //                           fontSize: 22.sp,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                       SizedBox(height: 3.w),
                //                       Text(
                //                         "-跨越时空的专属浪漫-",
                //                         style: TextStyle(
                //                           color: const Color(0xFF191919),
                //                           fontSize: 11.sp,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                       SizedBox(height: 14.w),
                //                       Container(
                //                         width: 144.w,
                //                         height: 175.w,
                //                         decoration: BoxDecoration(
                //                           color: Colors.amber,
                //                           borderRadius:
                //                               BorderRadius.circular(8.w),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //                 Positioned(
                //                   left: 0,
                //                   right: 0,
                //                   bottom: 0,
                //                   child: Container(
                //                     height: 55.w,
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.only(
                //                         bottomLeft: Radius.circular(8.w),
                //                         bottomRight: Radius.circular(8.w),
                //                       ),
                //                       gradient: const LinearGradient(
                //                         begin: Alignment.topCenter,
                //                         end: Alignment.bottomCenter,
                //                         colors: [
                //                           Color(0x00141414),
                //                           Color(0xBA000000),
                //                         ],
                //                       ),
                //                     ),
                //                     child: Align(
                //                       alignment: Alignment.centerLeft,
                //                       child: Padding(
                //                         padding: EdgeInsets.only(left: 10.w),
                //                         child: Text(
                //                           "千种风情人生",
                //                           style: TextStyle(
                //                             color: const Color(0xFFFFFFFF),
                //                             fontSize: 14.sp,
                //                             fontWeight: FontWeight.w400,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         mainAxisSpacing: 8.w,
                //         crossAxisSpacing: 8.w,
                //         childAspectRatio: 175.w / 265.w,
                //       ),
                //     ),
                //   ),
                //   Container(
                //     color: Colors.yellow,
                //     child: ListView.builder(
                //         padding: EdgeInsets.zero,
                //         itemCount: 110,
                //         itemBuilder: (c, index) {
                //           return Text("index: ${200 - index}");
                //         }),
                //   ),
                //   Container(
                //     color: Colors.blue,
                //     child: ListView.builder(
                //         padding: EdgeInsets.zero,
                //         itemCount: 110,
                //         itemBuilder: (c, index) {
                //           return Text("index: ${2 * index}");
                //         }),
                //   ),
                // ],
                onPageChanged: (index) {
                  logic.tabController?.animateTo(index);

                  if (index == 1) {
                    if (_scrollViewController!.offset > 600) {
                      _scrollViewController!
                          .jumpTo(_scrollViewController!.offset - 70);
                    }
                  }
                },
              ),
            );
          })
        ],
      ),
    );
  }
}

class CustomScrollPhysics extends BouncingScrollPhysics {
  final double friction;

  CustomScrollPhysics({this.friction = 0.6, ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
        friction: friction, parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 使用 friction 值来调整滑动的灵敏度
    return super.applyPhysicsToUserOffset(position, offset) * friction;
  }
}
