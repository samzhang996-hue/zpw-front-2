import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'works_logic.dart';

class WorksPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<WorksPage> getState() => _WorksPageState();
}

class _WorksPageState extends BaseWidgetState<WorksPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(WorksLogic());
  final state = Get.find<WorksLogic>().state;
  int selectedIndex = 0; // 初始选中第一个选项

  void selectTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    Get.delete<WorksPage>();
    super.dispose();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<WorksLogic>(builder: (logic) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            YAppBar(title: "作品"),
            Container(
              height: 40.h,
              width: 200.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTabItem(
                    text: "视频",
                    isSelected: selectedIndex == 0,
                    onTap: () => selectTab(0),
                  ),
                  buildTabItem(
                    text: "图片",
                    isSelected: selectedIndex == 1,
                    onTap: () => selectTab(1),
                  ),
                ],
              ),
            ),
            _item()
          ],
        ),
      );
    });
  }

  Widget _item() {
    return Flexible(
        child: Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: GridView.builder(
          padding: EdgeInsets.only(top: 17.h),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 175 / 265,
          ),
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Stack(
              children: [
                QdsImageCorner("url", 175.w, 265.h, 8),
              ],
            ));
          }),
    ));
  }

  Widget buildTabItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: isSelected ? 20.0 : 16.0, // 选中时字体大小为20，未选中时为16
                color: Color(0xff191919),
              ),
            ),
            if (isSelected) // 只有当选中时才显示图片
              Image.asset(
                "custom_indicator.png".mine, // 注意：".mine" 不是有效的资源引用方式
                width: 36.0, // 注意：.w 不是有效单位，应该使用具体的数值
                height: 4.0, // 注意：.h 不是有效单位，应该使用具体的数值或根据需求调整
              ),
          ],
        ),
      ),
    );
  }
}
