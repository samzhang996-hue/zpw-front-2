import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:screen_protector/screen_protector.dart';
import 'package:tabbar_gradient_indicator_plus/tabbar_gradient_indicator_plus.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/gameplay/gameplay_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';

class GameplayPage extends StatefulWidget {
  const GameplayPage({Key? key}) : super(key: key);

  @override
  State<GameplayPage> createState() => _GameplayPageState();
}

class _GameplayPageState extends State<GameplayPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(GameplayLogic());
  final state = Get.find<GameplayLogic>().state;

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

      // print("offset:${offset}");

      if ((offset! > 166.36363636363615) == true) {
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
          GetBuilder<GameplayLogic>(builder: (logic) {
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
                    floating: true,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.white, // Navigation bar
                      statusBarColor: Colors.transparent, // Status bar
                    ),
                    expandedHeight: 196.w + outHeight,
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
                                    "gameplay.png".face,
                                    width: 58.w,
                                    height: 34.w,
                                    fit: BoxFit.cover,
                                  ),
                                  Visibility(
                                    visible: !HandleTool.instance.isMember,
                                    child: GestureDetector(
                                      onTap: () {
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.w),
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
                      preferredSize: Size.fromHeight(60.w),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 60.w,
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
                            page?.jumpToPage(index);
                          },
                          controller: logic.tabController,
                          indicator: const TabBarGradientIndicator(
                            gradientColor: [
                              Color(0xFFFF2E7E),
                              Color(0x00FF2E7E)
                            ],
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
