import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:screen_protector/screen_protector.dart';
import 'package:tabbar_gradient_indicator_plus/tabbar_gradient_indicator_plus.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/specially/make_page.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';

import 'specially_logic.dart';

class SpeciallyPage extends StatefulWidget {
  SpeciallyPage({Key? key}) : super(key: key);

  @override
  State<SpeciallyPage> createState() => _SpeciallyPageState();
}

class _SpeciallyPageState extends State<SpeciallyPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(SpeciallyLogic());

  final state = Get.find<SpeciallyLogic>().state;

  late final TabController _tabController =
      TabController(length: state.values.keys.length, vsync: this);
  late ScrollController? _scrollViewController = ScrollController();
  var outHeight = 20.0.w;
  late PageController? page = PageController();
  Color _backgroundColor = Colors.transparent; // 初始背景色为透明
  // void _preventScreenshotOn() async =>
  //     await ScreenProtector.preventScreenshotOn();

  // void _preventScreenshotOff() async =>
  //     await ScreenProtector.preventScreenshotOff();

  // void _addListenerPreventScreenshot() async {
  //   ScreenProtector.addListener(() {
  //     // Screenshot
  //     debugPrint('Screenshot:');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Screenshot!'),
  //     ));
  //   }, (isCaptured) {
  //     // Screen Record
  //     debugPrint('Screen Record:');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Screen Record!'),
  //     ));
  //   });
  // }

  // void _removeListenerPreventScreenshot() async {
  //   ScreenProtector.removeListener();
  // }

  // void _checkScreenRecording() async {
  //   final isRecording = await ScreenProtector.isRecording();

  //   if (isRecording) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Screen Recording...'),
  //     ));
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _scrollViewController?.addListener(() {
      double? offset = _scrollViewController?.offset;

      if ((offset! >= kToolbarHeight) == true) {
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

    // _addListenerPreventScreenshot();
    // _preventScreenshotOn();
    // _checkScreenRecording();
  }

  @override
  void dispose() {
    // For iOS only.
    // _removeListenerPreventScreenshot();

    // // For iOS and Android
    // _preventScreenshotOff();
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
          NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  leading: Container(),
                  floating: true,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    systemNavigationBarColor: Colors.white, // Navigation bar
                    statusBarColor: Colors.transparent, // Status bar
                  ),
                  // expandedHeight: 196.w + outHeight,
                  expandedHeight: 86.w + outHeight,

                  /// --- 90
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
                          SizedBox(height: ScreenUtil().statusBarHeight + 10.w),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "specially.png".specially,
                                  width: 58.w,
                                  height: 34.w,
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
                          // SizedBox(height: 20.w),
                          // SizedBox(
                          //   height: 90.w,
                          //   child: ListView.builder(
                          //       padding: EdgeInsets.zero,
                          //       itemCount: 3,
                          //       scrollDirection: Axis.horizontal,
                          //       itemBuilder: (c, index) {
                          //         return GestureDetector(
                          //           onTap: () {
                          //             Get.to(() => MakePage(
                          //                 index: index,
                          //                 imageUrl: "03_$index.jpg"));
                          //           },
                          //           behavior: HitTestBehavior.opaque,
                          //           child: Container(
                          //             width: 182.w,
                          //             height: 90.w,
                          //             margin: EdgeInsets.only(
                          //                 left: 16.w,
                          //                 right: index == 2 ? 16.w : 0),
                          //             child: Image.asset(
                          //               "03_$index.jpg".specially,
                          //               width: 182.w,
                          //               height: 90.w,
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(60.w),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 60.w,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        tabs:
                            state.values.keys.map((e) => Tab(text: e)).toList(),

                        onTap: (index) {
                          // page.animateTo(index, duration: duration, curve: curve)
                          page?.jumpToPage(index);
                        },
                        controller: _tabController,
                        indicator: const TabBarGradientIndicator(
                          gradientColor: [Color(0xFFFF2E7E), Color(0x00FF2E7E)],
                          indicatorWidth: 4,
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: const Color(0xFF191919),
                        isScrollable: true,
                        labelStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF191919),
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF656565),
                        ),
                        dividerColor: Colors.transparent,
                        // dividerHeight:0,
                        unselectedLabelColor: const Color(0xFF656565), //未选中的颜色
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
              children: state.values.keys
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        // color: Colors.red,
                        child: GridView.builder(
                          padding: EdgeInsets.only(top: 10.w),
                          itemCount: state.values[e]?.length ?? 0,
                          itemBuilder: (c, index) {
                            final bean = state.values[e]?[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => MakePage(map: bean ?? {}));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 200.w,
                                        height: 200.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                          child: Image.asset(
                                            "${bean?["image"]}",
                                            width: 200.w,
                                            height: 200.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 55.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8.w),
                                            bottomRight: Radius.circular(8.w),
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0x00141414),
                                              Color(0xBA000000),
                                            ],
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 10.w,
                                              top: 12.w,
                                            ),
                                            child: Text(
                                              "${bean?["name"]}",
                                              style: TextStyle(
                                                color: const Color(0xFFFFFFFF),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.w,
                            crossAxisSpacing: 8.w,
                            // childAspectRatio: 175.w / 265.w,
                            childAspectRatio: 1.w / 1.w,
                          ),
                        ),
                      ))
                  .toList(),
              onPageChanged: (index) {
                _tabController.animateTo(index);

                if (index == 1) {
                  if (_scrollViewController!.offset > 600) {
                    _scrollViewController!
                        .jumpTo(_scrollViewController!.offset - 70);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
