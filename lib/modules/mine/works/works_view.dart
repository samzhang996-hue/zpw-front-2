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

class _WorksPageState extends BaseWidgetState<WorksPage> with SingleTickerProviderStateMixin {
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
            // YAppBar(title: "作品"),
            Container(
              padding: EdgeInsets.only(left: 10),
              height: 74.w,
              child: Container(
                margin: EdgeInsets.only(top: 24.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        child: Icon(Icons.arrow_back_ios, color: Colors.black),
                        margin: EdgeInsets.only(left: 13.w),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTabItem(
                              text: "视频",
                              isSelected: selectedIndex == 1,
                              onTap: () => selectTab(1),
                            ),
                            SizedBox(
                              width: 24.w,
                            ),
                            buildTabItem(
                              text: "图片",
                              isSelected: selectedIndex == 0,
                              onTap: () => selectTab(0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Container(
                        child: Icon(Icons.arrow_back_ios, color: Colors.black),
                        margin: EdgeInsets.only(right: 13.w),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w, top: 10.w,bottom: 10.w),
              child: Align(
                child: CommText(
                  text: "内容由ai生成，禁止利用本功能从事违法活动",
                  textColor: Color(0xffCCCCCC),
                  fontSize: 10.sp,
                ),
                alignment: Alignment.centerLeft,
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(21),
                  gradient: LinearGradient(
                    colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),),
                child: Center(
                    child: CommText(
                  text: "去创作",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textColor: Color(0xff191919),
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
          padding: EdgeInsets.all(0),
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
            int apiType = data["apiType"] ?? 0;
            Log.d("data111--$data");
            return InkWell(
              child: Container(
                  child: Stack(
                children: [
                  QdsImageCorner((apiType == -1 || apiType == 6) ? returnUrl : oldUrl, 175.w, 265.w, 8),
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
                            overTextFlow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                    ),
                  ),
                  Visibility(
                    visible: (worksStatus == 0 || worksStatus == 1 || worksStatus == 2),
                    child: Container(
                      width: 175.w,
                      height: 265.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff99000000)),
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
                                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1.w,
                                      color:ColorPlate.themeColor
                                    )
                                    // gradient: LinearGradient(
                                    //   colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.topRight,
                                    // ),
                                      ),
                                  child: Center(
                                      child: CommText(
                                    text: "重新制作",
                                    fontSize: 13.sp,
                                    textColor: ColorPlate.themeColor,
                                        fontWeight: FontWeight.w400,
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
                  final res = await Get.to(() => DetailPage(), arguments: {"worksType": worksType, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
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
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                fontSize: isSelected ? 20.0 : 16.0, // 选中时字体大小为20，未选中时为16
                color: isSelected ? const Color(0xff191919) : const Color(0xff656565),
              ),
            ),
            // if (isSelected) // 只有当选中时才显示图片
            //   Image.asset(
            //     "custom_indicator.png".mine, // 注意：".mine" 不是有效的资源引用方式
            //     width: 36.0, // 注意：.w 不是有效单位，应该使用具体的数值
            //     height: 4.0, // 注意：.w 不是有效单位，应该使用具体的数值或根据需求调整
            //   ),
          ],
        ),
      ),
    );
  }
}
