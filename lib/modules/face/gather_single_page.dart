import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tabbar_gradient_indicator_plus/tabbar_gradient_indicator_plus.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/no_more_content_view.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';

class GatherSinglePage extends StatefulWidget {
  const GatherSinglePage({
    super.key,
    required this.id,
    required this.imgUrlAcross,
    this.isWF = false,
  });
  final int id;

  final String imgUrlAcross;
  final bool isWF;

  @override
  State<GatherSinglePage> createState() => _GatherSinglePageState();
}

class _GatherSinglePageState extends State<GatherSinglePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ScrollController? _scrollViewController = ScrollController();
  var outHeight = 20.0.w;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  late PageController? _pageController = PageController();

  void _getData() {
    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.effectGroupList,
        isShowProgress: true,
        params: {
          "id": widget.id,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            listPhotoGroupBean = results;
            _tabController =
                TabController(length: listPhotoGroupBean.length, vsync: this);

            setState(() {});
          }
        },
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }

  @override
  void initState() {
    super.initState();

    if (widget.isWF) {
      _getData();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    leading: Container(),
                    floating: true,
                    expandedHeight: 220.w,
                    scrolledUnderElevation: 0.0,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: double.infinity,
                        child: Stack(
                          children: [
                            QdsImage(widget.imgUrlAcross, 1.sw, 260.w,
                                fit: BoxFit.contain),
                            // Positioned(
                            //   left: 0,
                            //   right: 0,
                            //   bottom: 30.w,
                            //   child: Container(
                            //     width: 1.sw,
                            //     height: 28.w,
                            //     decoration: BoxDecoration(
                            //       color: Colors.blue,
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(22.w),
                            //         topRight: Radius.circular(22.w),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    bottom: _tabController == null
                        ? const PreferredSize(
                            preferredSize: Size.zero,
                            child: SizedBox.shrink(),
                          )
                        : PreferredSize(
                            preferredSize: Size.fromHeight(60.w),
                            child: Container(
                              width: double.maxFinite,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 6.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22.w),
                                  topRight: Radius.circular(22.w),
                                ),
                                color: Colors.white,
                              ),
                              height: 60.w,
                              child: TabBar(
                                tabAlignment: TabAlignment.center,
                                tabs: listPhotoGroupBean
                                    .map((e) => Tab(text: "${e.groupName}"))
                                    .toList(),
                                onTap: (index) {
                                  _pageController?.jumpToPage(index);
                                },
                                controller: _tabController,
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
              body: widget.isWF
                  ? listPhotoGroupBean.isEmpty
                      ? const NoMoreContentView()
                      : PageView(
                          controller: _pageController,

                          children: listPhotoGroupBean
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
                            _tabController?.animateTo(index);
                            if (index == 1) {
                              if (_scrollViewController!.offset > 600) {
                                _scrollViewController!
                                    .jumpTo(_scrollViewController!.offset - 70);
                              }
                            }
                          },
                        )
                  : CollectionItem(id: widget.id)),
          Positioned(
              top: ScreenUtil().statusBarHeight,
              left: 22.w,
              // right: 0,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  color: Colors.transparent,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
