import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';

class ZpwCommSuccess extends StatelessWidget {
  const ZpwCommSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 176.w,
            height: 185.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  "zpw_success_ing.png".make,
                  width: 86.w,
                  height: 86.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 6.w),
                ZpwCommText(
                  text: "正在制作中！",
                  textColor: const Color(0xff191919),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 9.w),
                Center(
                  child: Text.rich(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                    ),
                    const TextSpan(
                      children: [
                        TextSpan(text: '制作完成可在', style: TextStyle(color: Color(0xffB2B2B2))),
                        TextSpan(
                          text: '我的作品',
                          style: TextStyle(color: Color(0xff4D4D4D), fontWeight: FontWeight.w500),
                        ),
                        TextSpan(text: '中查看', style: TextStyle(color: Color(0xffB2B2B2))),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}