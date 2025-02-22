import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/main/main_logic.dart';
import 'package:zpw/utils/log_utils.dart';

import '../detail/detail_view.dart';
import 'works_logic.dart';

class WorksPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<WorksPage> getState() => _WorksPageState();
}

class _WorksPageState extends BaseWidgetState<WorksPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(WorksLogic());
  final state = Get.find<WorksLogic>().state;
  final List<String> _tabs = ['视频', '图片'];
  late TabController _tabController;

  int _currentIndex = 0;

  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: Color(0xff656565),
    );
    TextStyle selectedStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      color: Color(0xff191919),
    );
    return Tab(
      child: AnimatedDefaultTextStyle(
        style: _currentIndex == index ? selectedStyle : normalStyle,
        duration: const Duration(milliseconds: 100),
        child: Text(text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 监听 TabController 的 index 变化
    _tabController.addListener(() {
      Log.d("msg----${_tabController.index}");
      logic.stateIndex(_tabController.index == 0 ? 1 : 0);
      logic.photoRecord();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<WorksPage>();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<WorksLogic>(builder: (logic) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            YAppBar(
              bgColor: Colors.transparent,
              widget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Image.asset('arrow_back.png'.comm,
                              width: 16.w,
                              height: 16.w,
                              fit: BoxFit.cover,
                              color: Colors.black)
                          .paddingOnly(left: 10),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 50,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: 1.sw * 0.4,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      tabAlignment: TabAlignment.center,
                      dividerColor: Colors.transparent,
                      tabs: _tabs.asMap().entries.map((e) {
                        return _animatedTab(e.key, e.value);
                      }).toList(),
                      onTap: (index) {
                        logic.stateIndex(index==0?1:0);
                        logic.photoRecord();
                      },
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 94,
                    height: 50,
                  )
                ],
              ),
              isMake: true,
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w, top: 10.w, bottom: 10.w),
              child: Align(
                child: CommText(
                  text: "内容由ai生成，禁止利用本功能从事违法活动",
                  textColor: const Color(0xffCCCCCC),
                  fontSize: 10.sp,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    if (scrollNotification.metrics.axisDirection ==
                        AxisDirection.right) {
                      double progress = scrollNotification.metrics.pixels /
                          scrollNotification.metrics.maxScrollExtent;
                      double unit = 1.0 / _tabs.length;
                      int index = progress ~/ unit;
                      if (index != _currentIndex && index < _tabs.length) {
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    }
                  }
                  return true;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _item(),
                    _item(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _item() {
    if (state.records.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 93.w),
        child: Column(
          children: [
            Image.asset(
              "emty_data.png".comm,
              width: 199.w,
            ),
            SizedBox(
              height: 13.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.find<MainLogic>().changeIndex(_tabController.index);
              },
              child: Container(
                width: 122.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Center(
                  child: CommText(
                    text: "去创作",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    textColor: const Color(0xff191919),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 175 / 265,
        ),
        shrinkWrap: true,
        itemCount: state.records.length,
        itemBuilder: (BuildContext context, int index) {
          var data = state.records[index];
          int worksStatus = data["worksStatus"] ?? 0;
          int worksType = data["worksType"] ?? 0;
          var returnUrl = data["returnUrl"] ?? "";
          var firstFrameUrl = data["firstFrameUrl"] ?? "";
          var tags = data["tags"] ?? "";
          var oldUrl = data["oldUrl"] ?? "";
          int id = data["id"] ?? 0;
          int funcId = data["funcId"] ?? 0;
          int apiType = data["apiType"] ?? 0;
          Log.d("data111--$data");
          String imagUrl;
          if ((apiType == -1 || apiType == 6)) {
            imagUrl = returnUrl;
          } else if (worksType == 1) {
            imagUrl = firstFrameUrl.toString().isEmpty ? oldUrl : firstFrameUrl;
          } else {
            imagUrl = oldUrl;
          }
          return InkWell(
            child: Container(
              child: Stack(
                children: [
                  QdsImageCorner(imagUrl, 175.w, 265.w, 8),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00141414), Color(0xFF73000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        child: CommText(
                          text: tags,
                          fontSize: 14.sp,
                          textColor: Colors.white,
                          overTextFlow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (worksStatus == 0 ||
                        worksStatus == 1 ||
                        worksStatus == 2),
                    child: Container(
                      width: 175.w,
                      height: 265.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xff99000000)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: (worksStatus != 2),
                            child: const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                          CommText(
                            text: worksStatus == 2 ? "制作失败" : "生成中...",
                            fontSize: 12.sp,
                            textColor: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          Visibility(
                            visible: worksStatus == 2,
                            child: InkWell(
                              child: Container(
                                width: 80.w,
                                margin: EdgeInsets.only(top: 10.w),
                                height: 24.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1.w,
                                    color: ColorPlate.themeColor,
                                  ),
                                ),
                                child: Center(
                                  child: CommText(
                                    text: "重新制作",
                                    fontSize: 13.sp,
                                    textColor: ColorPlate.themeColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Log.d("xxxx----------$funcId---$id");
                                logic.getFuncDetail(funcId, id);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              if (worksStatus == 3) {
                final res = await Get.to(() => DetailPage(), arguments: {"worksType": worksType, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
                logic.photoRecord();
                return;
              }
            },
          );
        },
      ),
    );
  }
}
