import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/detail/detail_view.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/utils/log_utils.dart';
import 'makewst_logic.dart';

class MakewstPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => MakewstPageState();
}

class MakewstPageState extends BaseWidgetState {
  final _controller = TextEditingController();
  final logic = Get.put(MakewstLogic());
  final state = Get.find<MakewstLogic>().state;

  @override
  void dispose() {
    _controller.dispose();
    logic.stopPolling();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<MakewstLogic>(builder: (logic) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 60.w),
                child: Column(
                  children: [
                    YAppBar(
                        title: "文生图",
                        right: InkWell(
                            onTap: () {
                              gotoPushPage(WorksPage());
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "my_work_ic.png".make,
                                  width: 22.w,
                                  height: 22.w,
                                ),
                                CommText(
                                  text: "作品",
                                  fontSize: 13.sp,
                                  textColor: Color(0xff191919),
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ))),
                    Expanded(child: createListView())
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        width: double.infinity,
                        // height: 80.w,
                        decoration: BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(child: buildTextField(), margin: EdgeInsets.only(left: 12.w, right: 12.w)),
                            // CommText(text: state.funcValue.value,fontSize: 14.sp,textColor: Color(0xff191919),),
                            Container(
                              margin: EdgeInsets.only(bottom: 5.w),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        logic.isAddState(!state.isAdd.value);
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          state.isAdd.value ? "hide.png".comm : "add.png".comm,
                                          width: 30.w,
                                          height: 30.w,
                                        ),
                                        margin: EdgeInsets.only(left: 12.w),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 5.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 55.w,
                                            height: 23.w,
                                            decoration: BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.circular(6)),
                                            child: Center(
                                                child: CommText(
                                              text: state.title.value,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              textColor: Color(0xff818181),
                                            )),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 6.w),
                                            width: 55.w,
                                            height: 23.w,
                                            decoration: BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.circular(6.w)),
                                            child: Center(
                                                child: CommText(
                                              text: state.name.value,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              textColor: Color(0xff818181),
                                            )),
                                          ),
                                        ],
                                      )),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      logic.addPhotoRecord();
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 12.w),
                                        child: Image.asset(
                                          "push.png".comm,
                                          width: 30.w,
                                          height: 30.w,
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                    Visibility(
                        visible: state.isAdd.value,
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 18.w, bottom: 14.w),
                                  child: CommText(
                                    text: "选择比例",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(0xff191919),
                                  )),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(state.itemTitles.length, (index) {
                                    String title = state.itemTitles[index]["title"];
                                    bool isSelect = state.titleIndex.value == index;
                                    return InkWell(
                                        onTap: () {
                                          logic.titleIndexState(index);
                                        },
                                        child: Container(
                                          width: 55.w,
                                          height: 23.w,
                                          decoration: BoxDecoration(color: isSelect ? ColorPlate.themeColor : Color(0xffEEEEEE), borderRadius: BorderRadius.circular(6)),
                                          child: Center(
                                              child: CommText(
                                            text: title,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            textColor: isSelect ? Colors.white : Color(0xff818181),
                                          )),
                                        ));
                                  })),
                              Container(
                                  margin: EdgeInsets.only(top: 18.w, bottom: 14.w),
                                  child: CommText(
                                    text: "选择比例",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(0xff191919),
                                  )),
                              Container(
                                width: double.infinity,
                                height: 120.w,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal, // 设置滚动方向为水平
                                  itemCount: state.hfList.length,
                                  itemBuilder: (context, index) {
                                    String bgImg = state.hfList[index]["bgImg"];
                                    String name = state.hfList[index]["name"];
                                    bool isSelect = state.fgIndex.value == index;
                                    return InkWell(
                                        onTap: () {
                                          logic.fgIndexState(index);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: isSelect ? ColorPlate.themeColor : Colors.transparent, width: isSelect ? 2.w : 0), borderRadius: BorderRadius.circular(10)),
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              // 假设 QdsImageCorner 是一个自定义组件，它接受图像 URL、宽度、高度和圆角半径作为参数
                                              QdsImageCorner(bgImg, 80.w, 118.w, 8),
                                              Container(
                                                height: 27.w,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff36000000),
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(8),
                                                      bottomRight: Radius.circular(8),
                                                    )),
                                                child: Center(
                                                    child: CommText(
                                                  text: name,
                                                  textColor: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              )
            ],
          ));
    });
  }

  TextField buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: state.funcValue.value,
        // border: OutlineInputBorder(),
        border: InputBorder.none,
        labelStyle: TextStyle(fontSize: 14.sp, color: Color(0xff191919)),
        contentPadding: const EdgeInsets.only(top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
      ),
      style: TextStyle(fontSize: 14.sp),
      maxLines: null,
      // 允许无限制的行数，即支持多行输入
      keyboardType: TextInputType.multiline,
      // 设置键盘类型为多行输入
      onChanged: (value) {
        state.funcValue.value = value;
        print('Text changed: $value-----${state.funcValue.value}');
      },
      onEditingComplete: () {
        print('Editing completed');
      },
      onSubmitted: (value) {
        print('Text submitted: $value');
        // 可以在这里调用 _controller.clear() 或其他逻辑来处理提交后的行为
      },
    );
  }

  Widget createImage(int worksStatus, String returnUrl, String bl,int id) {
    double w = 210;
    double h = 290;
    if (bl == "1:1") {
      w = 210;
      h = 210;
    } else if (bl == "9:16") {
      w = 130;
      h = 232;
    } else if (bl == "16:9") {
      w = 232;
      h = 130;
    } else if (bl == "4:3") {
      w = 189;
      h = 142;
    } else if (bl == "4:3") {
      w = 142;
      h = 189;
    }
    if (worksStatus == 0 || worksStatus == 1 || worksStatus == 2) {
      return Container(
        width: w.w,
        height: h.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.w), color: Color(0xff99000000)),
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
                    margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
                    height: 35.w,
                    decoration: BoxDecoration(color: ColorPlate.themeColor, borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: CommText(
                      text: "重新制作",
                      fontSize: 15.sp,
                      textColor: Colors.white,
                    ))),
                onTap: () {
                  // Log.d("xxxx----------$funcId---$id");
                  // logic.getFuncDetail(funcId, id);
                  logic.remakePhotoRecord(id);
                },
              ),
            )
          ],
        ),
      );
    } else {
      return QdsImageCorner(returnUrl, w.w, h.w, 16.w);
    }
  }

  Widget createListView() {
    return Container(
        margin: const EdgeInsets.only(top: 22,bottom: 20),
        child: ListView.builder(
            padding: EdgeInsets.all(0),
            // physics: const NeverScrollableScrollPhysics(),
            // 禁用ListView的滚动
            shrinkWrap: true,
            itemCount: state.records.value.length,
            itemBuilder: (BuildContext context, int index) {
              final item = state.records.value[index];
              final int type = item['worksType'] ?? 0;
              final int worksStatus = item['worksStatus'] ?? 0;
              final String returnUrl = item['returnUrl'] ?? "";
              final String novel = item['novel'] ?? "";

              var tags = item["tags"] ?? "";
              int id = item["id"] ?? 0;
              int funcId = item["funcId"] ?? 0;
              int apiType = item["apiType"] ?? 0;

              Map<String, dynamic> jsonMap = jsonDecode(item["valueJson"]);
              final String jsonName = jsonMap["name"] ?? "";
              final String jsonTitle = jsonMap["title"] ?? "";
              Log.d("list----$novel----$returnUrl---$type");
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 18.w),
                      decoration: const BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Container(
                          margin: EdgeInsets.only(left: 12.w, top: 14.w, bottom: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommText(
                                text: novel,
                                fontSize: 14.sp,
                                textColor: Color(0xff191919),
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 11.w,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 55.w,
                                    height: 23.w,
                                    decoration: BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                        child: CommText(
                                      text: jsonTitle,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: Color(0xff818181),
                                    )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 6.w),
                                    width: 55.w,
                                    height: 23.w,
                                    decoration: BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.circular(6.w)),
                                    child: Center(
                                        child: CommText(
                                      text: jsonName,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: Color(0xff818181),
                                    )),
                                  ),
                                ],
                              )
                            ],
                          ))),
                  Container(
                      width: 210.w,
                      margin: EdgeInsets.only(left: 16.w, bottom: 18.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // QdsImageCorner(returnUrl, 210.w, 290.w, 16.w),
                          InkWell(
                            onTap: () async {
                              if (worksStatus == 3) {
                                final res = await Get.to(() => DetailPage(), arguments: {"worksType": type, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
                                logic.photoRecord(true);
                                return;
                              }
                            },
                            child:createImage(worksStatus, returnUrl,jsonTitle,id),
                          ),

                          SizedBox(
                            height: 12.w,
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Container(
                          //       width: 101.w,
                          //       height: 32.w,
                          //       decoration: BoxDecoration(color: ColorPlate.themeColor, borderRadius: BorderRadius.circular(26)),
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             "tk.png".comm,
                          //             width: 20.w,
                          //             height: 20.w,
                          //           ),
                          //           CommText(
                          //             text: "做同款",
                          //             fontSize: 15.sp,
                          //             fontWeight: FontWeight.bold,
                          //             textColor: Colors.white,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.only(left: 8.w),
                          //       width: 101.w,
                          //       height: 32.w,
                          //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.w), border: Border.all(width: 2.w, color: ColorPlate.themeColor)),
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             "rush.png".comm,
                          //             width: 20.w,
                          //             height: 20.w,
                          //           ),
                          //           CommText(
                          //             text: "再次生成",
                          //             fontSize: 15.sp,
                          //             fontWeight: FontWeight.bold,
                          //             textColor: ColorPlate.themeColor,
                          //           )
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ))
                ],
              );
            }));
  }
}
