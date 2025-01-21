import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/utils/handle_tool.dart';

class MakeResultPage extends BaseStatefulWidget {
  final int index;

  MakeResultPage({required this.index});
  @override
  BaseWidgetState<MakeResultPage> getState() => _MakeResultPageState();
}

class _MakeResultPageState extends BaseWidgetState<MakeResultPage> {
  late final _currentZodiac = 0.obs;

  void _make() {
    HandleTool.showAppToastText("请输入文案");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            YAppBar(title: "天马行空"),
            Center(
              child: Container(
                color: Colors.grey,
                width: 358.w,
                height: 358.w,
              ),
            ),
            SizedBox(height: 20.w),
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
      ),
    );
  }
}
