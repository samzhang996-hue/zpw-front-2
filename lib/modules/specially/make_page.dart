import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_comm_error.dart';
import 'package:zpw/common/zpw_comm_success.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/specially/model/comm_enum_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

class MakePage extends ZpwBaseStatefulWidget {
  final Map<String, String> map;

  MakePage({required this.map});
  @override
  ZpwBaseWidgetState<MakePage> getState() => _MakePageState();
}

class _MakePageState extends ZpwBaseWidgetState<MakePage> with ZpwAppMixin {
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
    zpwGotoPushPage(WorksPage());
  }

  void _showError() async {
    final res = await Get.dialog(const ZpwCommError(), barrierDismissible: false);
    if (res == true) {}
    // _show.value = false;
  }

  void _showSuccess() {
    Get.dialog(const ZpwCommSuccess(), barrierDismissible: false);

    Future.delayed(const Duration(seconds: 3), () {
      if (_canBack) {
        Get.back();
      }
    });
  }

  String findKeyByPartialIcon(String partialKey) {
    var foundKeys = animalsIcon.keys.where((key) => key.contains(partialKey)).toList();
    return foundKeys.isNotEmpty ? foundKeys.first : '鼠';
  }

  String findKeyByPartialNormalIcon(String partialKey) {
    var foundKeys = animalsNormalIcon.keys.where((key) => key.contains(partialKey)).toList();
    return foundKeys.isNotEmpty ? foundKeys.first : '鼠';
  }

  void _make() {
    _canBack = true;
    if (_nicknameEditingController.text.isEmpty) {
      ZpwHandleTool.showAppToastText("请输入文案");
      return;
    }

    if (_nicknameEditingController.text.length > 4) {
      ZpwHandleTool.showAppToastText("请输入1-2个字符");
      return;
    }

    final params = <String, Object?>{"content": _nicknameEditingController.text, "useMethod": widget.map["useMethod"]};

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
        ZpwHandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        ZpwHandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart09"] = {
        "headType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }
    if (widget.map["useMethod"] == "10") {
      if (_tipsEditingController.text.isEmpty) {
        ZpwHandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        ZpwHandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart10"] = {
        "girlType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }
    if (widget.map["useMethod"] == "11") {
      if (_tipsEditingController.text.isEmpty) {
        ZpwHandleTool.showAppToastText("请输入文案");
        return;
      }

      if (_tipsEditingController.text.length > 16) {
        ZpwHandleTool.showAppToastText("请输入1-16个字符");
        return;
      }
      params["dart11"] = {
        "boyType": _value,
      };
      params["tips"] = _tipsEditingController.text;
    }

    ZpwLog.e("params:$params");
    // _showError();
    // _showSuccess();
    // return;
    ZpwHandleTool.instance.SMWPost(ZpwApi.zpwAddTask, params: params, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        _showSuccess();
      } else {
        _showError();
      }
    });

    // zpwGotoPushPage(MakeResultPage());
  }

  void _getData() {
    var path = '';
    if (widget.map["useMethod"] == "03") {
      path = ZpwApi.zpwAnimalsEnum;
    }
    if (widget.map["useMethod"] == "06") {
      path = ZpwApi.zpwMilkTeaEnum;
    }
    if (widget.map["useMethod"] == "09") {
      path = ZpwApi.zpwCartoonEnum;
    }
    if (widget.map["useMethod"] == "10") {
      path = ZpwApi.zpwCartoonGirlEnum;
    }
    if (widget.map["useMethod"] == "11") {
      path = ZpwApi.zpwCartoonBoyEnum;
    }
    ZpwHandleTool.instance.QDSGet<CommEnumBean>(path,
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
  Widget zpwInitDefaultBuild(BuildContext context) {
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
                      ZpwCommText(
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
                          decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(8.w)),
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
                                    hintText: "周少",
                                    hintStyle: TextStyle(color: const Color(0xFF999999), fontSize: 15.sp, fontWeight: FontWeight.w500),
                                    labelStyle: TextStyle(color: const Color(0xFF1A1A1A), fontSize: 16.sp, fontWeight: FontWeight.w500),
                                  ),
                                  inputFormatters: [LengthLimitingTextInputFormatter(_max)],
                                ),
                              ),
                              Obx(() => ZpwCommText(
                                    text: "${_count.value == 0 ? "" : _count.value}",
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
                        ZpwCommText(
                          text: "生肖：",
                          textColor: const Color(0xff191919),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 14.w),
                        Obx(
                          () => Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                mainAxisSpacing: 8.w,
                                crossAxisSpacing: 17.w,
                                childAspectRatio: 45 / 61,
                              ),
                              itemCount: _commEnumBean.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _currentZodiac.value = index;
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Obx(
                                    () => Column(
                                      children: [
                                        Image.asset(
                                          _currentZodiac.value == index ? "${animalsIcon[findKeyByPartialIcon(_commEnumBean[index].name ?? '')]}" : "${animalsNormalIcon[findKeyByPartialNormalIcon(_commEnumBean[index].name ?? '')]}",
                                          width: 45.w,
                                          height: 44.w,
                                          fit: BoxFit.cover,
                                        ),
                                        ZpwCommText(
                                          text: findKeyByPartialIcon(_commEnumBean[index].name ?? ''),
                                          textColor: _currentZodiac.value == index ? const Color(0xFF191919) : const Color(0xFFB2B2B2),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 44.w),
                      ],
                      if (widget.map["useMethod"] == "09" || widget.map["useMethod"] == "10" || widget.map["useMethod"] == "11") ...[
                        SizedBox(height: 20.w),
                        ZpwCommText(
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
                            decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(8.w)),
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
                                      hintText: "生活甜甜 好运连连",
                                      hintStyle: TextStyle(color: const Color(0xFF999999), fontSize: 15.sp, fontWeight: FontWeight.w500),
                                      labelStyle: TextStyle(color: const Color(0xFF1A1A1A), fontSize: 16.sp, fontWeight: FontWeight.w500),
                                    ),
                                    inputFormatters: [LengthLimitingTextInputFormatter(_maxTips)],
                                  ),
                                ),
                                Obx(() => ZpwCommText(
                                      text: "${_countTips.value == 0 ? "" : _countTips.value}",
                                      textColor: const Color(0xFF999999),
                                      fontSize: 13.sp,
                                    )),
                                SizedBox(width: 14.w),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.w),
                        ZpwCommText(
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
            child: zpwYAppBar(
              bgColor: Colors.white,
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
                      child: Image.asset('arrow_back.png'.comm, width: 16.w, height: 16.w, fit: BoxFit.cover).paddingOnly(left: 10),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 50,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 1.sw * 0.4,
                    child: Text("${widget.map["name"]}", overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF191919), fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  Container(
                    width: 94,
                    height: 50,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(top: 2),
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () async {
                        if ((await zpwWxLogin() == true)) {
                          _toHistory();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Image.asset(
                          //   "my_work_ic.png".make,
                          //   width: 22.w,
                          //   height: 22.w,
                          // ),
                          Text(
                            "我的作品",
                            style: TextStyle(
                              color: const Color(0xFF656565),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 16.w)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              isMake: true,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
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
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7EFAEF),
                            Color(0xFF7FE1FB),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        // color: const Color(0xFFFF2E7E),
                        borderRadius: BorderRadius.circular(26.w),
                      ),
                      child: Center(
                        child: ZpwCommText(
                          text: "一键制作",
                          textColor: const Color(0xFF191919),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
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

var animalsIcon = {
  "鼠": "animal_12.png".make,
  "牛": "animal_11.png".make,
  "虎": "animal_10.png".make,
  "兔": "animal_9.png".make,
  "龙": "animal_8.png".make,
  "蛇": "animal_7.png".make,
  "马": "animal_6.png".make,
  "羊": "animal_5.png".make,
  "猴": "animal_4.png".make,
  "鸡": "animal_3.png".make,
  "狗": "animal_2.png".make,
  "猪": "animal_1.png".make,
};

var animalsNormalIcon = {
  "鼠": "animal_normal_12.png".make,
  "牛": "animal_normal_11.png".make,
  "虎": "animal_normal_10.png".make,
  "兔": "animal_normal_9.png".make,
  "龙": "animal_normal_8.png".make,
  "蛇": "animal_normal_7.png".make,
  "马": "animal_normal_6.png".make,
  "羊": "animal_normal_5.png".make,
  "猴": "animal_normal_4.png".make,
  "鸡": "animal_normal_3.png".make,
  "狗": "animal_normal_2.png".make,
  "猪": "animal_normal_1.png".make,
};
