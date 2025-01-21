import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/specially/model/animals_enum_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class MakePage extends BaseStatefulWidget {
  final int index;
  final String imageUrl;

  MakePage({required this.index, required this.imageUrl});
  @override
  BaseWidgetState<MakePage> getState() => _MakePageState();
}

class _MakePageState extends BaseWidgetState<MakePage> {
  late final _nicknameEditingController = TextEditingController();

  late final _count = 0.obs;

  int get _max => 12;

  late final _animalsEnumBean = <AnimalsEnumBean>[].obs;

  late final _currentZodiac = 0.obs;
  void _toHistory() {
    gotoPushPage(WorksPage());
  }

  void _make() {
    if (_nicknameEditingController.text.isEmpty) {
      HandleTool.showAppToastText("请输入文案");
      return;
    }

    if (_nicknameEditingController.text.length > 4) {
      HandleTool.showAppToastText("请输入1-4个字符");
      return;
    }

    final params = {
      "content": _nicknameEditingController.text,
      "dart03": {
        "colorType": widget.index == 0
            ? "3401"
            : widget.index == 1
                ? "3406"
                : "3407",
        "animalType": "${_animalsEnumBean[_currentZodiac.value].value}",
      },
      "useMethod": "03"
    };
    // Log.e("params:$params");
    // return;
    HandleTool.instance.SMWPost(Api.addTask, params: params,
        success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Log.e("成功");
      } else {
        Log.e("成NOOOO");
      }
    });

    // gotoPushPage(MakeResultPage());
  }

  void _getData() {
    HandleTool.instance.QDSGet<AnimalsEnumBean>(Api.animalsEnum,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            _animalsEnumBean.value = results;
            // Log.e("");
          } else {
            // _showError();
          }
        },
        onModel: (json) => AnimalsEnumBean.fromJson(json));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _nicknameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + 26.w),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: Image.asset(
                      widget.imageUrl.specially,
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
                            ],
                          ),
                        ),
                      ),
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
                              itemCount: _animalsEnumBean.length,
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
                                                  _animalsEnumBean.length - 1
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
                                              '${_animalsEnumBean[index].name}',
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
              title: "生肖姓氏鼓励头像",
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
        ],
      ),
    );
  }
}
