import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabbar_gradient_indicator_plus/tabbar_gradient_indicator_plus.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/utils/log_utils.dart';

class GatherPage extends StatefulWidget {
  const GatherPage({
    super.key,
    required this.index,
    required this.listPhotoGroupBean,
    required this.imgUrlAcross,
  });
  final int index;
  final List<ListPhotoGroupBean> listPhotoGroupBean;
  final String imgUrlAcross;

  @override
  State<GatherPage> createState() => _GatherPageState();
}

class _GatherPageState extends State<GatherPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: widget.listPhotoGroupBean.length,
    vsync: this,
    initialIndex: widget.index,
  );
  late ScrollController? _scrollViewController = ScrollController();
  var outHeight = 20.0.w;
  late PageController? page = PageController(initialPage: widget.index);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                      QdsImage(
                        widget.imgUrlAcross,
                        1.sw,
                        260.w,
                      ),
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
              bottom: PreferredSize(
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
                    tabs: widget.listPhotoGroupBean
                        .map((e) => Tab(text: "${e.groupName}"))
                        .toList(),
                    onTap: (index) {
                      // page?.animateTo(index, duration: duration, curve: curve)
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
          children: widget.listPhotoGroupBean
              .map((e) => CollectionItem(id: e.id ?? 0))
              .toList(),
          onPageChanged: (index) {
            Log.e("indexindexindex:index$index");
            _tabController.animateTo(index);

            if (index == 1) {
              if (_scrollViewController!.offset > 200.w) {
                _scrollViewController!
                    .jumpTo(_scrollViewController!.offset - 70.w);
              }
            }
          },
        ),
      ),
    );
  }
}
