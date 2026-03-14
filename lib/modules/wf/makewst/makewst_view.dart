import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_qds_image.dart';
import 'package:zpw/common/zpw_style.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/mine/detail/detail_view.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'makewst_logic.dart';

class MakewstPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwBaseStatefulWidget> getState() => MakewstPageState();
}

class MakewstPageState extends ZpwBaseWidgetState with ZpwAppMixin {
  final ScrollController _scrollController = ScrollController();
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final logic = Get.put(MakewstZpwLogic());
  final state = Get.find<MakewstZpwLogic>().state;

  @override
  void initState() {
    super.initState();
    // 监听数据变化，滚动到底部
    ever(state.records, (_) => _scrollToBottom());
    _controller.text = state.funcValue.value;
    // 将光标移动到文本末尾
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _controller.dispose();
    logic.stopPolling();
    super.dispose();
  }

  // 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return GetBuilder<MakewstZpwLogic>(builder: (logic) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 100.w),
                child: Column(
                  children: [
                    zpwYAppBar(
                        title: "文生图",
                        right: InkWell(
                            onTap: () async {
                              if ((await zpwWxLogin() == true)) {
                                zpwGotoPushPage(WorksPage());
                              }
                            },
                            child: ZpwCommText(
                              text: "我的作品",
                            ))),
                    Expanded(child: createListView())
                  ],
                ),
              ),
              SafeArea(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 16.w, bottom: 4.w),
                          child: ZpwCommText(
                            text: "内容由ai生成，禁止利用本功能从事违法活",
                            fontWeight: FontWeight.w400,
                            textColor: Color(0xffCCCCCC),
                            fontSize: 10.sp,
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          width: double.infinity,
                          // height: 80.w,
                          decoration: BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(child: buildTextField(), margin: EdgeInsets.only(left: 12.w, right: 12.w)),
                              // ZpwCommText(text: state.funcValue.value,fontSize: 14.sp,textColor: Color(0xff191919),),
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
                                                  child: ZpwCommText(
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
                                                  child: ZpwCommText(
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
                                        if (state.funcValue.value.isEmpty) {
                                          ZpwHandleTool.showAppToastText("请输入提示词！");
                                          return;
                                        }
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
                                    child: ZpwCommText(
                                      text: "选择比例",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
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
                                            width: 65.w,
                                            height: 34.w,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.w, color: isSelect ? Color(0xff191919) : Color(0xffCCCCCC))),
                                            child: Center(
                                                child: ZpwCommText(
                                              text: title,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              textColor: isSelect ? Color(0xff191919) : Color(0xffCCCCCC),
                                            )),
                                          ));
                                    })),
                                Container(
                                    margin: EdgeInsets.only(top: 18.w, bottom: 14.w),
                                    child: ZpwCommText(
                                      text: "选择风格",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
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
                                            decoration: BoxDecoration(border: Border.all(color: isSelect ? Color(0xff191919) : Colors.transparent, width: isSelect ? 2.w : 0), borderRadius: BorderRadius.circular(10)),
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                // 假设 QdsImageCorner 是一个自定义组件，它接受图像 URL、宽度、高度和圆角半径作为参数
                                                ZpwQdsImageCorner(bgImg, 80.w, 118.w, 8),
                                                Container(
                                                  height: 27.w,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff36000000),
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(8),
                                                        bottomRight: Radius.circular(8),
                                                      )),
                                                  child: Center(
                                                      child: ZpwCommText(
                                                    text: name,
                                                    textColor: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp,
                                                    maxLines: 1,
                                                    overTextFlow: TextOverflow.ellipsis,
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
                ),
              )
            ],
          ));
    });
  }

  TextField buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      decoration: InputDecoration(
        // labelText: state.funcValue.value,
        // border: OutlineInputBorder(),
        hintText: "输入生成提示词",
        hintStyle: TextStyle(fontSize: 14.sp, color: Color(0xffB2B2B2)),
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

  Widget createImage(int worksStatus, String returnUrl, String bl, int id) {
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
            ZpwCommText(
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
                    decoration: BoxDecoration(color: ZpwColorPlate.themeColor, borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: ZpwCommText(
                      text: "重新制作",
                      fontSize: 15.sp,
                      textColor: Colors.white,
                    ))),
                onTap: () {
                  // ZpwLog.d("xxxx----------$funcId---$id");
                  // logic.getFuncDetail(funcId, id);
                  logic.remakePhotoRecord(id);
                },
              ),
            )
          ],
        ),
      );
    } else {
      return ZpwQdsImageCorner(returnUrl, w.w, h.w, 16.w);
    }
  }

  Widget createListView() {
    return Container(
      margin: const EdgeInsets.only(top: 22, bottom: 20),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(0),
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
          ZpwLog.d("msg----${item["valueJson"]}");
          String jsonName = "无风格";
          String jsonTitle = "1:1";
          if (item["valueJson"] != null) {
            Map<String, dynamic> jsonMap = jsonDecode(item["valueJson"]);
            jsonName = jsonMap["name"] ?? "";
            jsonTitle = jsonMap["title"] ?? "";
          }
          ZpwLog.d("list----$novel----$returnUrl---$type");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IntrinsicWidth(
                  child: Container(
                    margin: EdgeInsets.only(left: 69.w, right: 16.w, bottom: 18.w),
                    decoration: const BoxDecoration(
                      color: Color(0xffE9F7FF),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w, left: 12.w, top: 14.w, bottom: 13.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ZpwCommText(
                            text: novel,
                            fontSize: 14.sp,
                            textColor: Color(0xff191919),
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 11.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 55.w,
                                height: 23.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: ZpwCommText(
                                    text: jsonTitle,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    textColor: Color(0xff818181),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 6.w),
                                width: 55.w,
                                height: 23.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                child: Center(
                                  child: ZpwCommText(
                                    text: jsonName,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    textColor: Color(0xff818181),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 210.w,
                margin: EdgeInsets.only(left: 16.w, bottom: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (worksStatus == 3) {
                          final res = await Get.to(() => DetailPage(), arguments: {"worksType": type, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
                          logic.photoRecord(true);
                          return;
                        }
                      },
                      child: createImage(worksStatus, returnUrl, jsonTitle, id),
                    ),
                    SizedBox(
                      height: 12.w,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
