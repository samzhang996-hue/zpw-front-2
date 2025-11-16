import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/main.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/mine/detail/detail_view.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class MakewstPage extends StatefulWidget {
  const MakewstPage({Key? key}) : super(key: key);

  @override
  State<MakewstPage> createState() => _MakewstPageState();
}

class _MakewstPageState extends State<MakewstPage> with AppMixin {
  // 原 MakewstState 的状态变量
  final RxList<dynamic> records = [].obs;
  final RxList<Map<String, dynamic>> hfList = <Map<String, dynamic>>[].obs;
  final RxString funcValue = "".obs;
  final RxString title = "1:1".obs;
  final RxString name = "无风格".obs;
  final RxInt funcId = 0.obs;
  final RxInt titleIndex = 0.obs;
  final RxInt fgIndex = 0.obs;
  final RxBool isAdd = false.obs;
  final List<Map<String, dynamic>> itemTitles = [
    {
      'title': "1:1",
      "width": "1080",
      "height": "1080",
    },
    {
      "title": "16:9",
      "width": "1920",
      "height": "1080",
    },
    {
      'title': "9:16",
      "width": "1080",
      "height": "1920",
    },
    {
      'title': "4:3",
      "width": "1280",
      "height": "960",
    },
    {
      'title': "3:4",
      "width": "960",
      "height": "1280",
    }
  ];

  // UI 控制器
  final ScrollController _scrollController = ScrollController();
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // 原 MakewstLogic 的轮询定时器
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    // 获取传递的参数
    var map = Get.arguments;
    if (map != null) {
      funcValue.value = map["funcValue"] ?? "";
      funcId.value = map["funcId"] ?? 0;
    }

    // 监听数据变化，滚动到底部
    ever(records, (_) => _scrollToBottom());
    _controller.text = funcValue.value;
    // 将光标移动到文本末尾
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _focusNode.requestFocus();

    // 初始化数据
    photoRecord(true);
    defTimbreVO();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _controller.dispose();
    stopPolling();
    super.dispose();
  }

  // ============ 原 MakewstLogic 的方法 ============

  void titleIndexState(int index) {
    titleIndex.value = index;
    title.value = itemTitles[index]["title"];
    setState(() {});
  }

  void fgIndexState(int index) {
    fgIndex.value = index;
    name.value = hfList[index]["name"];
    setState(() {});
  }

  void isAddState(bool value) {
    isAdd.value = value;
    setState(() {});
  }

  // 开始轮询
  void startPolling() {
    _pollingTimer ??= Timer.periodic(const Duration(seconds: 10), (timer) {
      photoRecord(false);
    });
  }

  // 停止轮询
  void stopPolling() {
    if (_pollingTimer != null) {
      _pollingTimer!.cancel();
      _pollingTimer = null;
    }
  }

  Future<void> photoRecord(bool rush) async {
    Map<String, dynamic> dataMap = {"pageIndex": 1, "pageSize": 100, "apiType": 6, "sortType": 1};
    try {
      final response = await HttpClient().post(
        ApiConfig.photoRecord,
        data: dataMap,
        showLoading: rush,
      );

      if (response.isSuccess && response.data != null) {
        final Map data = response.data as Map;
        records.value = data["records"];
        setState(() {});

        bool shouldContinuePolling = records.any((record) =>
          (record['worksStatus'] == 0 || record['worksStatus'] == 1));

        if (!shouldContinuePolling) {
          stopPolling();
        } else {
          startPolling();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> addPhotoRecord() async {
    final valueJsonMap = {
      "title": itemTitles[titleIndex.value]["title"],
      "name": hfList[fgIndex.value]["name"],
    };
    final String valueJsonString = jsonEncode(valueJsonMap);
    final params = {
      "funcId": funcId.value,
      "novel": funcValue.value,
      "width": itemTitles[titleIndex.value]["width"],
      "height": itemTitles[titleIndex.value]["height"],
      "prompt": hfList[fgIndex.value]["voiceType"] ?? "",
      "valueJson": valueJsonString
    };

    try {
      final response = await HttpClient().post(
        ApiConfig.addPhotoRecord,
        data: params,
      );

      if (response.isSuccess && response.data != null) {
        await photoRecord(true);
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> defTimbreVO() async {
    try {
      final response = await HttpClient().post(
        ApiConfig.defTimbreVO,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        hfList.value = dataList.cast<Map<String, dynamic>>();
        setState(() {});
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> remakePhotoRecord(int id) async {
    try {
      final response = await HttpClient().post(
        "${ApiConfig.remakePhotoRecord}?id=$id",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        await photoRecord(true);
        setState(() {});
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  // ============ UI 辅助方法 ============

  // 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// 导航栏
  Widget YAppBar(
      {String? title,
      Color? navBarTitleColor,
      Color? bgColor,
      bool canBack = true,
      bool divider = false,
      bool homePage = false,
      Widget? left,
      Widget? right,
      Widget? widget,
      String? statubar,
      double? RightValue,
      Function? leftClick,
      String? navBar,
      double rightPadding = 20,
      bool isMake = false}) {
    var screenSize = yScreenSize(navigatorKey.currentContext!);
    double statubarHeight = yStatubarHeight(navigatorKey.currentContext!);
    double navBarHeight = yNavBarHeight();
    return Container(
      color: bgColor ?? Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: screenSize.width,
            height: statubarHeight,
          ),
          Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: isMake ? 0 : 10),
              color: bgColor ?? Colors.white,
              height: navBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: widget == null
                    ? <Widget>[
                        if (canBack)
                          GestureDetector(
                            onTap: () {
                              if (canBack) {
                                if (leftClick != null) {
                                  leftClick();
                                } else {
                                  Get.back();
                                }
                              }
                            },
                            child: Container(
                                width: navBarHeight,
                                height: navBarHeight,
                                color: bgColor ?? Colors.white,
                                child: left ??
                                    (canBack
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                    'arrow_back.png'.comm,
                                                    width: 16.w,
                                                    height: 16.w,
                                                    fit: BoxFit.cover,
                                                    color: navBarTitleColor ??
                                                        Colors.black)
                                                .paddingOnly(right: 10),
                                          )
                                        : Container(
                                            color: Colors.white,
                                          ))),
                          ),
                        SizedBox(
                          width: homePage == true ? 50 : 0,
                        ),
                        YTitleWidget(title ?? "",
                            navBarTitleColor: navBarTitleColor ?? Colors.black),
                        right != null
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: rightPadding),
                                height: navBarHeight,
                                child: right,
                              )
                            : Container(
                                width: navBarHeight,
                              )
                      ]
                    : <Widget>[
                        SizedBox(
                            width: screenSize.width,
                            height: navBarHeight,
                            child: widget)
                      ],
              ),
            ),
          ]),
          divider
              ? Divider(height: 1, color: Colors.grey.shade400)
              : Container(),
        ],
      ),
    );
  }

  /// 页面跳转
  gotoPushPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
    Get.to(pushWidget,
        transition: Transition.rightToLeft, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 100.w),
              child: Column(
                children: [
                  YAppBar(
                      title: "文生图",
                      right: InkWell(
                          onTap: () async {
                            if ((await wxLogin() == true)) {
                              gotoPushPage(WorksPage());
                            }
                          },
                          child: CommText(
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
                        child: CommText(
                          text: "内容由ai生成，禁止利用本功能从事违法活",
                          fontWeight: FontWeight.w400,
                          textColor: Color(0xffCCCCCC),
                          fontSize: 10.sp,
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Color(0xffF9F9F9), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(child: buildTextField(), margin: EdgeInsets.only(left: 12.w, right: 12.w)),
                            Container(
                              margin: EdgeInsets.only(bottom: 5.w),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        isAddState(!isAdd.value);
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          isAdd.value ? "hide.png".comm : "add.png".comm,
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
                                              text: title.value,
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
                                              text: name.value,
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
                                      if (funcValue.value.isEmpty) {
                                        HandleTool.showAppToastText("请输入提示词！");
                                        return;
                                      }
                                      addPhotoRecord();
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
                        visible: isAdd.value,
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
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xff191919),
                                  )),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(itemTitles.length, (index) {
                                    String title = itemTitles[index]["title"];
                                    bool isSelect = titleIndex.value == index;
                                    return InkWell(
                                        onTap: () {
                                          titleIndexState(index);
                                        },
                                        child: Container(
                                          width: 65.w,
                                          height: 34.w,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.w, color: isSelect ? Color(0xff191919) : Color(0xffCCCCCC))),
                                          child: Center(
                                              child: CommText(
                                            text: title,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            textColor: isSelect ? Color(0xff191919) : Color(0xffCCCCCC),
                                          )),
                                        ));
                                  })),
                              Container(
                                  margin: EdgeInsets.only(top: 18.w, bottom: 14.w),
                                  child: CommText(
                                    text: "选择风格",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xff191919),
                                  )),
                              Container(
                                width: double.infinity,
                                height: 120.w,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hfList.length,
                                  itemBuilder: (context, index) {
                                    String bgImg = hfList[index]["bgImg"];
                                    String name = hfList[index]["name"];
                                    bool isSelect = fgIndex.value == index;
                                    return InkWell(
                                        onTap: () {
                                          fgIndexState(index);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          width: 80.w,
                                          decoration: BoxDecoration(border: Border.all(color: isSelect ? Color(0xff191919) : Colors.transparent, width: isSelect ? 2.w : 0), borderRadius: BorderRadius.circular(10)),
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
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
        )));
  }

  TextField buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "输入生成提示词",
        hintStyle: TextStyle(fontSize: 14.sp, color: Color(0xffB2B2B2)),
        border: InputBorder.none,
        labelStyle: TextStyle(fontSize: 14.sp, color: Color(0xff191919)),
        contentPadding: const EdgeInsets.only(top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
      ),
      style: TextStyle(fontSize: 14.sp),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        funcValue.value = value;
        print('Text changed: $value-----${funcValue.value}');
      },
      onEditingComplete: () {
        print('Editing completed');
      },
      onSubmitted: (value) {
        print('Text submitted: $value');
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
    } else if (bl == "3:4") {
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
                  remakePhotoRecord(id);
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
      margin: const EdgeInsets.only(top: 22, bottom: 20),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          final item = records[index];
          final int type = item['worksType'] ?? 0;
          final int worksStatus = item['worksStatus'] ?? 0;
          final String returnUrl = item['returnUrl'] ?? "";
          final String novel = item['novel'] ?? "";
          var tags = item["tags"] ?? "";
          int id = item["id"] ?? 0;
          int funcId = item["funcId"] ?? 0;
          int apiType = item["apiType"] ?? 0;
          String jsonName = "无风格";
          String jsonTitle = "1:1";
          if (item["valueJson"] != null) {
            Map<String, dynamic> jsonMap = jsonDecode(item["valueJson"]);
            jsonName = jsonMap["name"] ?? "";
            jsonTitle = jsonMap["title"] ?? "";
          }
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
                                  child: CommText(
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
                                  child: CommText(
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
                          await Get.to(() => DetailPage(), arguments: {"worksType": type, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
                          photoRecord(true);
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
