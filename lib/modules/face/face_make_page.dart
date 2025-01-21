import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';

class FaceMakePage extends BaseStatefulWidget {
  final String title;
  final int funcId;
  FaceMakePage({required this.title, required this.funcId});

  @override
  BaseWidgetState<FaceMakePage> getState() => _FaceMakePageState();
}

class _FaceMakePageState extends BaseWidgetState<FaceMakePage> {
  late final _currentZodiac = 0.obs;

  late final _show = false.obs;

  void _toHistory() {
    gotoPushPage(WorksPage());
  }

  void _showSuccess() {
    _show.value = true;
  }

  void _showError() async {
    final res = await Get.dialog(
        Material(
          type: MaterialType.transparency,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35.w, right: 35.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            width: 294.w,
                            height: 345.w,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19.w),
                              child: SizedBox(
                                width: 294.w,
                                height: 345.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 26.w),
                                    Center(
                                      child: Text(
                                        '制作失败',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: const Color(0xFF191919),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14.w),
                                    Text(
                                      '1.可能是你的照片不符合该特效的上传要求，请参考上传建议。',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    Text(
                                      '2.可能是你使用的照片违反了国家法律法规（比如明星、政治人物等等...）',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    Text(
                                      'PS：请上传符合要求的照片再试试哦..',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back(result: true);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 357.w,
                                        height: 44.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF2E7E),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "重新上传",
                                            textColor: const Color(0xFFFFFFFF),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back(result: false);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 357.w,
                                        height: 44.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1.w,
                                              color: const Color(0xFFFF2E7E)),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "知道了",
                                            textColor: const Color(0xFFFF2E7E),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false);
    if (res == true) {}
    _show.value = false;
  }

  void _make() async {
    _show.value = false;
    final params = {
      "funcId": widget.funcId,
      "imgUrls": [HandleTool.instance.headImg],
      // "prompt": "",
    };
    HandleTool.instance.SMWPost(Api.addPhotoRecord, params: params,
        success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        _showSuccess();
      } else {
        _showError();
      }
    });
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void yCloseInputMethod() {
    _show.value = false;
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              YAppBar(
                title: widget.title,
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
              Expanded(
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  return Container(
                    color: Colors.grey,
                    width: 1.sw,
                    height: boxConstraints.maxHeight,
                  );
                }),
              ),
            ],
          ),
          Obx(() => Visibility(
                visible: _show.isTrue,
                child: Positioned(
                  left: 0,
                  right: 0,
                  top: kToolbarHeight / 2,
                  child: Container(
                    height: 118.w,
                    width: 358.w,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 12.w),
                            Container(
                              width: 69.w,
                              height: 94.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8D8D8),
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CommText(
                                      text: "作品制作完成！",
                                      textColor: const Color(0xff191919),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Image.asset(
                                      "make_result_success.png".make,
                                      width: 26.w,
                                      height: 26.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.w),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _show.value = false;
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 110.w,
                                        height: 33.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1.w,
                                              color: const Color(0xFFFF2E7E)),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "稍后查看",
                                            textColor: const Color(0xFFFF2E7E),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    GestureDetector(
                                      onTap: () {
                                        _show.value = false;
                                        _toHistory();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 110.w,
                                        height: 33.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF2E7E),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "立即查看",
                                            textColor: const Color(0xFFFFFFFF),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 214.w,
              width: 1.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.w),
                ),
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF2EB8), Color(0xFFFF2E2E)],
                                begin: Alignment.centerLeft, // 渐变的起始点
                                end: Alignment.centerRight, // 渐变的结束点
                              ),
                            ),
                          ),
                          ClipOval(
                              child: QdsImage(
                                  HandleTool.instance.headImg, 68.w, 68.w)),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          "make_close.png".make,
                          width: 18.w,
                          height: 18.w,
                        ),
                      ),
                      Positioned(
                        bottom: -5.w,
                        right: 0,
                        child: Container(
                          width: 76.w,
                          height: 21.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF2EB8), Color(0xFFFF2E2E)],
                              begin: Alignment.centerLeft, // 渐变的起始点
                              end: Alignment.centerRight, // 渐变的结束点
                            ),
                          ),
                          child: Center(
                            child: CommText(
                              text: "上传新头像",
                              textColor: const Color(0xFFFFFFFF),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  const Spacer(),
                  GestureDetector(
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
                  const Spacer(flex: 2),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
