import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/no_more_content_view.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GatherSinglePage extends StatefulWidget {
  const GatherSinglePage({
    super.key,
    required this.id,
    required this.imgUrlAcross,
    this.isWF = false,
    // this.title = 'title',
    required this.title,
  });
  final int id;

  final String imgUrlAcross;
  final bool isWF;
  final String title;

  @override
  State<GatherSinglePage> createState() => _GatherSinglePageState();
}

class _GatherSinglePageState extends State<GatherSinglePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ScrollController? _scrollViewController = ScrollController();
  // var outHeight = 0.0.w;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  late PageController? _pageController = PageController();
  Color _backgroundColor = Colors.transparent;
  var _showTitle = false;

  late final _title = widget.title.obs;

  Future<void> _getData() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.effectGroupList,
        queryParameters: {
          "id": widget.id,
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => ListPhotoGroupBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          listPhotoGroupBean = results;
          _tabController =
              TabController(length: listPhotoGroupBean.length, vsync: this);
          if (listPhotoGroupBean.isNotEmpty) {
            _title.value = listPhotoGroupBean.first.groupName ?? '';
          }

          setState(() {});
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollViewController?.addListener(() {
      double? offset = _scrollViewController?.offset;

      if ((offset! >=
              (220.w - 60.w + (listPhotoGroupBean.length > 1 ? 20.w : 0.w))) ==
          true) {
        setState(() {
          _backgroundColor = Colors.white;
          _showTitle = true;
        });
      } else {
        setState(() {
          _backgroundColor = Colors.transparent;
          _showTitle = false;
        });
      }
    });
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
                    expandedHeight: (_tabController == null ||
                            listPhotoGroupBean.length == 1 ||
                            _showTitle)
                        ? 176.w
                        : 220.w,
                    scrolledUnderElevation: 0.0,
                    backgroundColor: _backgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: double.infinity,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: QdsImage(widget.imgUrlAcross, 1.sw, 232.w,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    // bottom: (_tabController == null ||
                    //         listPhotoGroupBean.length == 1)
                    bottom: (_tabController == null ||
                            listPhotoGroupBean.length == 1 ||
                            _showTitle)
                        ? PreferredSize(
                            preferredSize: Size.fromHeight(_showTitle
                                ? ScreenUtil().statusBarHeight + 10.w
                                : 20.w),
                            child: Container(
                              width: double.maxFinite,
                              alignment: Alignment.topCenter,
                              // padding: EdgeInsets.only(top: 6.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22.w),
                                  topRight: Radius.circular(22.w),
                                ),
                                color: Colors.white,
                              ),
                              height: _showTitle
                                  ? ScreenUtil().statusBarHeight + 10.w
                                  : 20.w,
                            ),
                          )
                        : PreferredSize(
                            preferredSize: Size.fromHeight(66.w),
                            child: Container(
                              width: double.maxFinite,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 16.w, bottom: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22.w),
                                  topRight: Radius.circular(22.w),
                                ),
                                color: Colors.white,
                              ),
                              height: 66.w,
                              child: TabBar(
                                tabAlignment: TabAlignment.center,
                                tabs: listPhotoGroupBean
                                    .map((e) => Tab(text: "${e.groupName}"))
                                    .toList(),
                                onTap: (index) {
                                  _title.value =
                                      listPhotoGroupBean[index].groupName ?? '';
                                  _pageController?.jumpToPage(index);
                                },
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      50.w), // Creates border
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
                            _title.value =
                                listPhotoGroupBean[index].groupName ?? '';
                            // if (index == 1) {
                            //   if (_scrollViewController!.offset > 600) {
                            //     _scrollViewController!
                            //         .jumpTo(_scrollViewController!.offset);
                            //   }
                            // }
                          },
                        )
                  : CollectionItem(id: widget.id)),
          Positioned(
              top: ScreenUtil().statusBarHeight,
              left: 22.w,
              right: 22.w,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'arrow_back.png'.comm,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.cover,
                          // child: Icon(
                          //   Icons.arrow_back_ios,
                          color: _showTitle ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() => Text(_title.value,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _showTitle
                              ? const Color(0xFF191919)
                              : Colors.transparent,
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
                  const Spacer(),
                  SizedBox(width: 32.w, height: 32.w)
                ],
              ))
        ],
      ),
    );
  }
}
