import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwMakeResultPage extends ZpwBaseStatefulWidget {
  final int index;

  ZpwMakeResultPage({required this.index});
  @override
  ZpwBaseWidgetState<ZpwMakeResultPage> getState() => _ZpwMakeResultPageState();
}

class _ZpwMakeResultPageState extends ZpwBaseWidgetState<ZpwMakeResultPage> {
  late final _currentZodiac = 0.obs;

  void _make() {
    ZpwHandleTool.showAppToastText("请输入文案");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            zpwYAppBar(title: "天马行空"),
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
          ],
        ),
      ),
    );
  }
}
