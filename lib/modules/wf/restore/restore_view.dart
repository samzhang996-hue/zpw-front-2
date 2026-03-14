import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_my_plugin.dart';
import 'package:zpw/utils/zpw_permission.dart';

import 'restore_logic.dart';

class RestorePage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwBaseStatefulWidget> getState() => _RestorePageState();
}

class _RestorePageState extends ZpwBaseWidgetState with ZpwAppMixin {
  final logic = Get.put(RestoreLogic());
  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          zpwYAppBar(title: "数据恢复"),
          Image.asset(
            "zpw_hf.png".comm,
            width: double.infinity,
            height: 297.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "zpw_left_bg.png".comm,
                width: 27.w,
                height: 2.w,
              ),
              SizedBox(
                width: 2.w,
              ),
              ZpwCommText(
                text: "数据恢复 安全可靠",
                fontWeight: FontWeight.bold,
                textColor: Color(0xff191919),
                fontSize: 19.sp,
              ),
              SizedBox(
                width: 2.w,
              ),
              Image.asset(
                "zpw_right_bg.png".comm,
                width: 27.w,
                height: 2.w,
              ),
            ],
          ),
          ZpwCommText(
            text: "数据不会在服务器上保存‌，仅存于本地设备",
            textColor: Color(0xff999999),
            fontSize: 13.sp,
          ),
          InkWell(
            onTap: () async {
              if ((await zpwWxLogin() == true)) {
                if (ZpwHandleTool.instance.isMember) {
                  onStartPhoto();
                } else {
                  zpwGotoPushPage(VipPage());
                }
              }
            },
            child: Container(
              height: 51.w,
              width: double.infinity,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 26.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                  child: ZpwCommText(
                text: "立即恢复",
                textColor: Color(0xff191919),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              )),
            ),
          ),
          SizedBox(
            height: 27.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    "zpw_del.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  ZpwCommText(
                    text: "误删",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "zpw_clean.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  ZpwCommText(
                    text: "回收站清空",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "zpw_data.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  ZpwCommText(
                    text: "数据丢失",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "zpw_dir.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  ZpwCommText(
                    text: "目录损坏",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  onStartPhoto() async {
    await ZpwPermissionUtils.checkFilesAccessPermission();
    startPhoto();
  }
}
