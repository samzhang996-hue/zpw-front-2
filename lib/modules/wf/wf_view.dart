import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/wf/restore/restore_view.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class WfPage extends StatefulWidget {
  const WfPage({Key? key}) : super(key: key);

  @override
  State<WfPage> createState() => _WfPageState();
}

class _WfPageState extends State<WfPage> with AppMixin {
  // 原 WfState 的状态变量
  List<ListPhotoGroupBean> listPhotoGroupBean = <ListPhotoGroupBean>[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // ============ 原 WfLogic 的方法 ============

  Future<void> getData() async {
    try {
      final response = await HttpClient().post(
        ApiConfig.listPhotoGroup,
        data: {"groupType": 2},
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final List<ListPhotoGroupBean> results = dataList
            .map((e) => ListPhotoGroupBean.fromJson(e as Map<String, dynamic>))
            .toList();

        setState(() {
          if (Platform.isIOS) {
            listPhotoGroupBean = results.where((item) => item.frontType != 'SJHF').toList();
          } else {
            listPhotoGroupBean = results;
          }
        });
        if (listPhotoGroupBean.length > 1) {
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  // ============ UI 辅助方法 ============

  /// 页面跳转
  gotoPushPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
    Get.to(pushWidget,
        transition: Transition.rightToLeft, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "face_bg.png".face,
            width: 1.sw,
            height: 371.w,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().statusBarHeight + 10.w,
                    left: 16.w,
                    right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "wf.png".comm,
                      width: 50.w,
                      height: 25.w,
                    ),
                    InkWell(
                      child: CommText(
                        text: '我的作品',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        textColor: const Color(0xFF656565),
                      ),
                      onTap: () async {
                        if ((await wxLogin() == true)) {
                          gotoPushPage(WorksPage());
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              _item()
            ],
          ),
        ],
      ),
    );
  }

  Widget _item() {
    return Flexible(
        child: Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: EasyRefresh(
        onRefresh: () async {
          getData();
        },
        child: GridView.builder(
            padding: EdgeInsets.only(top: 7.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 175 / 265,
            ),
            shrinkWrap: true,
            itemCount: listPhotoGroupBean.length,
            itemBuilder: (BuildContext context, int index) {
              ListPhotoGroupBean data = listPhotoGroupBean[index];
              var groupName = data.groupName ?? "";
              var tips = data.tips ?? "";
              var frontType = data.frontType ?? "";
              var imgUrlVertical = data.imgUrlVertical ?? "";
              var imgUrlAcross = data.imgUrlAcross ?? "";
              return InkWell(
                child: Container(
                    child: Column(
                  children: [
                    QdsImageCorner(imgUrlVertical, 175.w, 210.w, 8),
                    SizedBox(
                      height: 8.w,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CommText(
                                  text: groupName,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: Color(0xff191919),
                                )
                              ],
                            ),
                            CommText(
                              text: tips,
                              fontSize: 13.sp,
                              textColor: Color(0xff999999),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          width: 56.w,
                          height: 27.w,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7EFAEF).withOpacity(0.11),
                                  Color(0xFF7FE1FB).withOpacity(0.11),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(15.w)),
                          child: Center(
                              child: CommText(
                            text: "使用",
                            fontSize: 15.sp,
                            textColor: Color(0xFF19CDF2),
                            fontWeight: FontWeight.bold,
                          )),
                        )
                      ],
                    )
                  ],
                )),
                onTap: () {
                  switch (frontType) {
                    case "SJHF":
                      gotoPushPage(RestorePage());
                      break;
                    case "AIKT":
                      gotoPushPage(Photo_listPage(isNew: false),
                          arguments: {"type": 1});
                      break;
                    case "WST":
                    default:
                      Get.to(
                        () => GatherSinglePage(
                          id: data.id ?? 0,
                          imgUrlAcross: imgUrlAcross,
                          title: data.groupName ?? "",
                          isWF: true,
                        ),
                      );
                      break;
                  }
                },
              );
            }),
      ),
    ));
  }
}
