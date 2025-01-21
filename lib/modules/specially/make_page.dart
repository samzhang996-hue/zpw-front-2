import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/utils/handle_tool.dart';

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

  List<String> _chineseZodiac = [
    '鼠',
    '牛',
    '虎',
    '兔',
    '龙',
    '蛇',
    '马',
    '羊',
    '猴',
    '鸡',
    '狗',
    '猪'
  ];

  late final _currentZodiac = 0.obs;

  void _make() {
    HandleTool.showAppToastText("请输入文案");
    // gotoPushPage(MakeResultPage());
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
          Column(
            children: [
              SizedBox(height: kToolbarHeight + 26.w),
              Center(
                child: Image.asset(
                  widget.imageUrl.specially,
                  width: 358.w,
                  height: 358.w,
                  fit: BoxFit.cover,
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
                      child: ListView.builder(
                          itemCount: _chineseZodiac.length,
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
                                  margin: EdgeInsets.only(right: 4.w),
                                  decoration: BoxDecoration(
                                    color: _currentZodiac.value == index
                                        ? const Color(0xFFFF2E7E)
                                        : const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(6.w),
                                  ),
                                  child: Center(
                                    child: CommText(
                                      text: _chineseZodiac[index],
                                      textColor: _currentZodiac.value == index
                                          ? Colors.white
                                          : const Color(0xFF999999),
                                      fontSize: 16.sp,
                                      fontWeight: _currentZodiac.value == index
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: YAppBar(title: "天马行空"),
          )
        ],
      ),
    );
  }
}
