import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'guide_logic.dart';
import 'package:image_picker/image_picker.dart';

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
    print('file----${pickedFile?.path}');
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 44.h,
        ),
        CommText(
          text: "千种风情人生",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          textColor: Color(0xff191919),
        ),
        SizedBox(
          height: 8.h,
        ),
        Expanded(
            child: Image.asset(
          "splash.png".comm,
          width: double.infinity,
          fit: BoxFit.fill,
        )),
        InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 17.h, bottom: 44.h, right: 16.w, left: 16.w),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(color: ColorPlate.themeColor, borderRadius: BorderRadius.circular(26)),
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
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 19.h),
                      child: Center(
                          child: CommText(
                        text: "上传正脸照片",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.black,
                      )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 17.h),
                        child: Image.asset(
                          "face.png".comm,
                          width: 244.w,
                          height: 192.h,
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
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
                      onTap: () {
                          gotoPushPage(Photo_listPage());
                        // pickImage();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(color: ColorPlate.themeColor, borderRadius: BorderRadius.circular(26)),
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
                        margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
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
  }
}
