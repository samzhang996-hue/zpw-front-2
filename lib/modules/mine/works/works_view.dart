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
  int selectedIndex = 1; // 初始选中第一个选项

  void selectTab(int index) {
    state.index = index;
    setState(() {
      selectedIndex = index;
    });
    logic.photoRecord(index);
  }

  @override
  void dispose() {
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
            YAppBar(title: "作品"),
            Container(
              height: 40.w,
              width: 200.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTabItem(
                    text: "视频",
                    isSelected: selectedIndex == 1,
                    onTap: () => selectTab(1),
                  ),
                  buildTabItem(
                    text: "图片",
                    isSelected: selectedIndex == 0,
                    onTap: () => selectTab(0),
                  ),
                ],
              ),
            ),
            _item()
          ],
        ),
      );
    });
  }

  Widget _item() {
    if (state.records.isEmpty) {
      return Container(
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
                Get.find<MainLogic>().changeIndex(selectedIndex == 1 ? 0 : 1);
              },
              child: Container(
                width: 122.w,
                height: 40.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: ColorPlate.themeColor),
                child: Center(
                    child: CommText(
                  text: "去创作",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                )),
              ),
            )
          ],
        ),
      );
    }
    return Flexible(
        child: Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: GridView.builder(
          padding: EdgeInsets.only(top: 17.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 175 / 265,
          ),
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.records.length,
          itemBuilder: (BuildContext context, int index) {
            var data = state.records[index];
            //任务状态(WorksStatus 0:等待 1:工作中 2:失败 3:成功)
            int worksStatus = data["worksStatus"] ?? 0;
            //任务结果类型(WorksTypeEnum 0:图片 1:视频 2:音频 3:文字)
            int worksType = data["worksType"] ?? 0;
            var returnUrl = data["returnUrl"] ?? "";
            var tags = data["tags"] ?? "";
            var oldUrl = data["oldUrl"] ?? "";
            int id = data["id"] ?? 0;
            int funcId = data["funcId"] ?? 0;
            Log.d("data111--$data");
            return InkWell(
              child: Container(
                  child: Stack(
                children: [
                  QdsImageCorner(oldUrl, 175.w, 265.w, 8),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00141414), Color(0xFF73000000)],
                          begin: Alignment.topCenter, // 渐变的起始点
                          end: Alignment.bottomCenter, // 渐变的结束点
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                          margin: EdgeInsets.only(left: 10.w),
                          child: CommText(
                            text: tags,
                            fontSize: 14.sp,
                            textColor: Colors.white,
                          )),
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
                          color: Color(0xff99000000)),
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
                            text: worksStatus == 2 ? "制作失败" : "制作中...",
                            fontSize: 12.sp,
                            textColor: Colors.white,
                          ),
                          Visibility(
                            visible: worksStatus == 2,
                            child: InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 20.w, right: 20.w, top: 10.w),
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                      color: ColorPlate.themeColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: CommText(
                                    text: "重新制作",
                                    fontSize: 15.sp,
                                    textColor: Colors.white,
                                  ))),
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
              )),
              onTap: () async {
                if (worksStatus == 3) {
                  final res = await Get.to(() => DetailPage(), arguments: {
                    "worksType": worksType,
                    "returnUrl": returnUrl,
                    "tags": tags,
                    "id": id,
                    "funcId": funcId
                  });
                  logic.photoRecord(selectedIndex);
                  return;
                  // final res = await gotoPushPage(
                  //   DetailPage(),
                  //   arguments: {
                  //     "worksType": worksType,
                  //     "returnUrl": returnUrl,
                  //     "tags": tags,
                  //     "id": id
                  //   },
                  // );
                  // logic.photoRecord(selectedIndex);
                }
              },
            );
          }),
    ));
  }

  Widget buildTabItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: isSelected ? 20.0 : 16.0, // 选中时字体大小为20，未选中时为16
                color: Color(0xff191919),
              ),
            ),
            if (isSelected) // 只有当选中时才显示图片
              Image.asset(
                "custom_indicator.png".mine, // 注意：".mine" 不是有效的资源引用方式
                width: 36.0, // 注意：.w 不是有效单位，应该使用具体的数值
                height: 4.0, // 注意：.w 不是有效单位，应该使用具体的数值或根据需求调整
              ),
          ],
        ),
      ),
    );
  }
}
