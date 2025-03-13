import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/wf/restore/restore_view.dart';
import 'package:zpw/utils/log_utils.dart';

// import 'package:zpw/modules/wf/wf_page.dart';
import 'wf_logic.dart';

class WfPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<WfPage> getState() => _WfPageState();
}

class _WfPageState extends BaseWidgetState<WfPage> {
  final logic = Get.put(WfLogic());
  final state = Get.find<WfLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
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
          GetBuilder<WfLogic>(builder: (logic) {
            return Column(
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
                        onTap: () {
                          gotoPushPage(WorksPage());
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                _item()
              ],
            );
          }),
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
          logic.getData();
        },
        child: GridView.builder(
            padding: EdgeInsets.only(top: 7.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 175 / 265,
            ),
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: logic.state.listPhotoGroupBean.length,
            itemBuilder: (BuildContext context, int index) {
              ListPhotoGroupBean data = state.listPhotoGroupBean[index];
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
                              // color: Color(0xffFFEEF2),
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
                  Log.d("async----$frontType");
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
                      Log.e("xx: ${data.toJson()}");
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

                  // Get.to(
                  //   () => WfPage2(
                  //     index: index,
                  //     listPhotoGroupBean: state.listPhotoGroupBean,
                  //     imgUrlAcross: imgUrlAcross,
                  //   ),
                  // );
                  // if (worksStatus == 3) {
                  //   final res = await gotoPushPage(
                  //     DetailPage(),
                  //     arguments: {"worksType": worksType, "returnUrl": returnUrl, "tags": tags, "id": id},
                  //   );
                  //   logic.photoRecord(selectedIndex);
                  // }
                },
              );
            }),
      ),
    ));
  }
}
