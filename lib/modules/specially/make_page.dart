import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/comm_error.dart';
import 'package:zpw/common/comm_success.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/specially/model/comm_enum_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class MakePage extends BaseStatefulWidget {
  final Map<String, String> map;

  MakePage({required this.map});
  @override
  BaseWidgetState<MakePage> getState() => _MakePageState();
}

class _MakePageState extends BaseWidgetState<MakePage> {
  late final _nicknameEditingController = TextEditingController();
  late final _tipsEditingController = TextEditingController();

  late final _count = 0.obs;
  late final _countTips = 0.obs;

  int get _max => 2;
  int get _maxTips => 16;

  var _value = '';
  var _canBack = true;

  late final _commEnumBean = <CommEnumBean>[].obs;

  late final _currentZodiac = 0.obs;
  void _toHistory() {
    _canBack = false;
    gotoPushPage(WorksPage());
  }

  void _showError() async {
    final res = await Get.dialog(const CommError(), barrierDismissible: false);
    if (res == true) {}
    // _show.value = false;
  }

  void _showSuccess() {
    Get.dialog(const CommSuccess(headImg: ""), barrierDismissible: false);

    Future.delayed(const Duration(seconds: 3), () {
      if (_canBack) {
        Get.back();
      }
    });
  }

  void _make() {
    _canBack = true;
    if (_nicknameEditingController.text.isEmpty) {
      HandleTool.showAppToastText("请输入文案");
      return;
    }

    if (_nicknameEditingController.text.length > 4) {
      HandleTool.showAppToastText("请输入1-2个字符");
      return;
    }

    final params = <String, Object?>{
      "content": _nicknameEditingController.text,
      "useMethod": widget.map["useMethod"]
    };

    if (widget.map["useMethod"] == "03") {
      params["dart03"] = {
        "colorType": widget.map["colorType"],
        "animalType": "${_commEnumBean[_currentZodiac.value].value}",
      };
    }

    if (widget.map["useMethod"] == "06") {
      params["dart06"] = {
        "milkTeaType": _value,
      };
    }
    //// 08/09/10/11/15：姓氏+宣言/印签文字
    if (widget.map["useMethod"] == "09") {
      if (_tipsEditingController.text.isEmpty) {
        HandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        HandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart09"] = {
        "headType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }
    if (widget.map["useMethod"] == "10") {
      if (_tipsEditingController.text.isEmpty) {
        HandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        HandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart10"] = {
        "girlType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }
    if (widget.map["useMethod"] == "11") {
      if (_tipsEditingController.text.isEmpty) {
        HandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        HandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart11"] = {
        "boyType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }

    Log.e("params:$params");
    // _showError();
    // _showSuccess();
    // return;
    HandleTool.instance.SMWPost(Api.addTask, params: params,
        success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        _showSuccess();
      } else {
        _showError();
      }
    });

    // gotoPushPage(MakeResultPage());
  }

  void _getData() {
    var path = '';
    if (widget.map["useMethod"] == "03") {
      path = Api.animalsEnum;
    }
    if (widget.map["useMethod"] == "06") {
      path = Api.milkTeaEnum;
    }
    if (widget.map["useMethod"] == "09") {
      path = Api.cartoonEnum;
    }
    if (widget.map["useMethod"] == "10") {
      path = Api.cartoonGirlEnum;
    }
    if (widget.map["useMethod"] == "11") {
      path = Api.cartoonBoyEnum;
    }
    HandleTool.instance.QDSGet<CommEnumBean>(path,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            _commEnumBean.value = results;

            if (widget.map["useMethod"] != "03") {
              for (var e in results) {
                if (e.name == widget.map["name"]) {
                  _value = e.value ?? '';
                }
              }
            }
          } else {}
        },
        onModel: (json) => CommEnumBean.fromJson(json));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _canBack = false;
    _nicknameEditingController.dispose();
    _tipsEditingController.dispose();
    super.dispose();
  }

  @override
  Color get backgroundColor => Colors.white;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: kToolbarHeight + 26.w),
                SizedBox(height: ScreenUtil().statusBarHeight + kToolbarHeight),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: Image.asset(
                      "${widget.map["image"]}",
                      width: 358.w,
                      height: 358.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.w),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommText(
                        text: "姓氏：",
                        textColor: const Color(0xff191919),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 10.w),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Container(
                          height: 49.w,
                          // color: Colors.grey,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8.w)),
                          child: Row(
                            children: [
                              SizedBox(width: 14.w),
                              Expanded(
                                child: TextField(
                                  controller: _nicknameEditingController,
                                  onChanged: (value) {
                                    _count.value = value.length;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    labelStyle: TextStyle(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(_max)
                                  ],
                                ),
                              ),
                              Obx(() => CommText(
                                    text:
                                        "${_count.value == 0 ? "" : _count.value}",
                                    textColor: const Color(0xFF999999),
                                    fontSize: 13.sp,
                                  )),
                              SizedBox(width: 14.w),
                            ],
                          ),
                        ),
                      ),
                      if (widget.map["useMethod"] == "03") ...[
                        SizedBox(height: 20.w),
                        CommText(
                          text: "生肖：",
                          textColor: const Color(0xff191919),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 14.w),
                        SizedBox(
                          height: 34.w,
                          child: Obx(
                            () => ListView.builder(
                                itemCount: _commEnumBean.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _currentZodiac.value = index;
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Obx(
                                      () => Container(
                                        width: 65.w,
                                        height: 34.w,
                                        margin: EdgeInsets.only(
                                            right: index ==
                                                    _commEnumBean.length - 1
                                                ? 16.w
                                                : 4.w),
                                        decoration: BoxDecoration(
                                          color: _currentZodiac.value == index
                                              ? const Color(0xFFFF2E7E)
                                              : const Color(0xFFF2F2F2),
                                          borderRadius:
                                              BorderRadius.circular(6.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text:
                                                '${_commEnumBean[index].name}',
                                            textColor:
                                                _currentZodiac.value == index
                                                    ? Colors.white
                                                    : const Color(0xFF999999),
                                            fontSize: 16.sp,
                                            fontWeight:
                                                _currentZodiac.value == index
                                                    ? FontWeight.w500
                                                    : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                      if (widget.map["useMethod"] == "09" ||
                          widget.map["useMethod"] == "10" ||
                          widget.map["useMethod"] == "11") ...[
                        SizedBox(height: 20.w),
                        CommText(
                          text: "宣言：",
                          textColor: const Color(0xff191919),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 10.w),
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Container(
                            height: 49.w,
                            // color: Colors.grey,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(8.w)),
                            child: Row(
                              children: [
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: TextField(
                                    controller: _tipsEditingController,
                                    onChanged: (value) {
                                      _countTips.value = value.length;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      labelStyle: TextStyle(
                                          color: const Color(0xFF1A1A1A),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(_maxTips)
                                    ],
                                  ),
                                ),
                                Obx(() => CommText(
                                      text:
                                          "${_countTips.value == 0 ? "" : _countTips.value}",
                                      textColor: const Color(0xFF999999),
                                      fontSize: 13.sp,
                                    )),
                                SizedBox(width: 14.w),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.w),
                        CommText(
                          text: "ps:可输入空格",
                          textColor: const Color(0xFFB2B2B2),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 80.w),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: YAppBar(
              title: "${widget.map["name"]}",
              right: GestureDetector(
                onTap: _toHistory,
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  "make_history.png".make,
                  width: 28.w,
                  height: 28.w,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 20.w),
              child: Center(
                child: GestureDetector(
                  onTap: _make,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 357.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2E7E),
                      borderRadius: BorderRadius.circular(26.w),
                    ),
                    child: Center(
                      child: CommText(
                        text: "一键制作",
                        textColor: const Color(0xFFFFFFFF),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
