import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_style.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';

class ZpwFacePhotoBottomSheet extends StatelessWidget {
  const ZpwFacePhotoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 19.w),
            child: Center(
                child: ZpwCommText(
              text: "上传正脸照片",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              textColor: Colors.black,
            )),
          ),
          Container(
              margin: EdgeInsets.only(top: 17.w),
              child: Image.asset(
                "zpw_face.png".comm,
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
                  child: ZpwCommText(
                    text: "侧脸拍照",
                    textColor: Color(0xffB2B2B2),
                    fontSize: 11.sp,
                  ),
                  margin: EdgeInsets.only(left: 8.w),
                ),
                ZpwCommText(
                  text: "面部遮挡",
                  textColor: Color(0xffB2B2B2),
                  fontSize: 11.sp,
                ),
                Container(
                  child: ZpwCommText(
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
              Get.back(result: true);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.w, left: 16.w, right: 16.w),
              width: double.infinity,
              height: 52.w,
              decoration: BoxDecoration(color: ZpwColorPlate.zpwThemeColor, borderRadius: BorderRadius.circular(26)),
              child: Center(
                  child: ZpwCommText(
                text: "上传照片",
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textColor: Color(0xff191919),
              )),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 8.w, bottom: 10.w + ScreenUtil().bottomBarHeight),
              child: ZpwCommText(
                text: "*用户图片数据在每次使用后均会被删除，不会在服务器上保存‌",
                fontSize: 11.sp,
                textColor: Color(0xffB2B2B2),
              ))
        ],
      ),
    );
  }
}