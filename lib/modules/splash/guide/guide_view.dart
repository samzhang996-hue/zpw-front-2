import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';

import 'guide_logic.dart';

class GuidePage extends BaseStatefulWidget {
  @override
  BaseWidgetState<GuidePage> getState() => _GuidePageState();
}

class _GuidePageState extends BaseWidgetState<GuidePage> {
  final logic = Get.put(GuideLogic());
  final state = Get.find<GuideLogic>().state;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
  }

  void _uploadImg() async {
    Get.to(() => Photo_listPage());
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<GuideLogic>(builder: (logic) {
      return Column(
        children: [
          SizedBox(
            height: 44.w,
          ),
          CommText(
            text: state.funcName,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            textColor: Color(0xff191919),
          ),
          SizedBox(
            height: 8.w,
          ),
          Expanded(
            child: QdsImage(state.showImgGif, double.infinity, double.infinity,
                fit: BoxFit.cover),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                  top: 17.w, bottom: 44.w, right: 16.w, left: 16.w),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                  color: ColorPlate.themeColor,
                  borderRadius: BorderRadius.circular(26)),
              child: Center(
                  child: CommText(
                text: "立即制作",
                textColor: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              )),
            ),
            onTap: () {
              Get.bottomSheet(
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 19.w),
                        child: Center(
                            child: CommText(
                          text: "上传正脸照片",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.black,
                        )),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 17.w),
                          child: Image.asset(
                            "face.png".comm,
                            width: 244.w,
                            height: 192.w,
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 5.w),
                        width: 244.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: CommText(
                                text: "侧脸拍照",
                                textColor: Color(0xffB2B2B2),
                                fontSize: 11.sp,
                              ),
                              margin: EdgeInsets.only(left: 8.w),
                            ),
                            CommText(
                              text: "面部遮挡",
                              textColor: Color(0xffB2B2B2),
                              fontSize: 11.sp,
                            ),
                            Container(
                              child: CommText(
                                text: "挤眉弄眼",
                                textColor: Color(0xffB2B2B2),
                                fontSize: 11.sp,
                              ),
                              margin: EdgeInsets.only(right: 8.w),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _uploadImg,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10.w, left: 16.w, right: 16.w),
                          width: double.infinity,
                          height: 52.w,
                          decoration: BoxDecoration(
                              color: ColorPlate.themeColor,
                              borderRadius: BorderRadius.circular(26)),
                          child: Center(
                              child: CommText(
                            text: "上传照片",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.white,
                          )),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: 8.w,
                              bottom: 10.w + ScreenUtil().bottomBarHeight),
                          child: CommText(
                            text: "*用户图片数据在每次使用后均会被删除，不会在服务器上保存‌",
                            fontSize: 11.sp,
                            textColor: Color(0xffB2B2B2),
                          ))
                    ],
                  ),
                ),
              );
            },
          )
        ],
      );
    });
  }
}
