import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/modules/face/collection_item.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/specially/widget/avatar_set_item.dart';
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

  var outHeight = 0.0.w;
  late PageController? page = PageController();

  @override
  void initState() {
    super.initState();
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
          GetBuilder<SpeciallyLogic>(builder: (logic) {
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
                              "specially.png".specially,
                              width: 50.w,
                              height: 25.w,
                              fit: BoxFit.cover,
                            ),
                            GetBuilder<MineLogic>(
                              builder: (mineLogic) {
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
                              },
                            ),
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
                                      () => GatherSinglePage(
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
                              UmengCommonSdk.onEvent('Specially_click_event', {
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
                            unselectedLabelColor: const Color(0xFF656565),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: page,
                    children: logic.listPhotoGroupBean2
                        // .map((e) => FaceItem(id: e.id ?? 0))
                        .map((e) {
                      return e.id == -1
                          ? const AvatarSetItem()
                          : CollectionItem(
                              id: e.id ?? 0,
                            );
                    }).toList(),
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
