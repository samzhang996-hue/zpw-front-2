import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/specially/zpw_make_page.dart';

class AvatarSetItem extends StatefulWidget {
  const AvatarSetItem({super.key});

  @override
  State<AvatarSetItem> createState() => _AvatarSetItemState();
}

class _AvatarSetItemState extends State<AvatarSetItem> {
  late final _list = [
    {
      "image": "images/specially/zpw_03_0.jpg",
      "colorType": "3401",
      "name": "红色",
      "useMethod": "03"
    },
    {
      "image": "images/specially/zpw_03_1.jpg",
      "colorType": "3406",
      "name": "灰色",
      "useMethod": "03"
    },
    {
      "image": "images/specially/zpw_03_2.jpg",
      "colorType": "3407",
      "name": "闪灰",
      "useMethod": "03"
    },
    {
      "image": "images/specially/zpw_06_0.jpg",
      "name": "奶茶男款头像A",
      "useMethod": "06"
    },
    {
      "image": "images/specially/zpw_06_1.jpg",
      "name": "奶茶男款头像B",
      "useMethod": "06"
    },
    {
      "image": "images/specially/zpw_06_2.jpg",
      "name": "奶茶女款头像A",
      "useMethod": "06"
    },
    {
      "image": "images/specially/zpw_06_3.jpg",
      "name": "奶茶女款头像B",
      "useMethod": "06"
    },
    {"image": "images/specially/zpw_09_0.jpg", "name": "爱国男孩", "useMethod": "09"},
    {"image": "images/specially/zpw_09_1.jpg", "name": "爱国女孩", "useMethod": "09"},
    {"image": "images/specially/zpw_09_2.jpg", "name": "吃瓜男孩", "useMethod": "09"},
    {"image": "images/specially/zpw_09_3.jpg", "name": "吃瓜女孩", "useMethod": "09"},
    {"image": "images/specially/zpw_09_4.jpg", "name": "男孩坐着", "useMethod": "09"},
    {"image": "images/specially/zpw_09_5.jpg", "name": "女孩测试", "useMethod": "09"},
    {"image": "images/specially/zpw_10_0.jpg", "name": "摆酷女孩", "useMethod": "10"},
    {"image": "images/specially/zpw_10_1.jpg", "name": "高枕无忧", "useMethod": "10"},
    {"image": "images/specially/zpw_10_2.jpg", "name": "接花女孩", "useMethod": "10"},
    {"image": "images/specially/zpw_11_0.jpg", "name": "摆酷男孩", "useMethod": "11"},
    {"image": "images/specially/zpw_11_1.jpg", "name": "墨镜男孩", "useMethod": "11"},
    {"image": "images/specially/zpw_11_2.jpg", "name": "男孩背影", "useMethod": "11"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        padding: EdgeInsets.only(top: 10.w),
        itemCount: _list.length,
        itemBuilder: (c, index) {
          final bean = _list[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => MakePage(map: bean));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.w),
                        child: Image.asset(
                          "${bean?["image"]}",
                          width: 200.w,
                          height: 200.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 55.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.w),
                          bottomRight: Radius.circular(8.w),
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00141414),
                            Color(0xBA000000),
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            top: 12.w,
                          ),
                          child: Text(
                            "${bean?["name"]}",
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.w,
          crossAxisSpacing: 8.w,
          // childAspectRatio: 175.w / 265.w,
          childAspectRatio: 1.w / 1.w,
        ),
      ),
    );
  }
}
