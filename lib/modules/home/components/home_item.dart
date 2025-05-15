import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/home/home_detail.dart';

import '../../../common/cached_image/cached_image.dart';
import '../../../model/list_photo_group_bean.dart';
import '../../../network/api/network_api.dart';
import '../../../utils/handle_tool.dart';

class HomeItem extends StatefulWidget {
  const HomeItem({super.key, required this.title});
  final String title;

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> with AutomaticKeepAliveClientMixin<HomeItem> {
  int get tabType => switch (widget.title) {
        "特效" => 2,
        "图片" => 1,
        "视频" => 0,
        _ => 0,
      };

  var listPhotoGroupBean2 = <ListPhotoGroupBean>[].obs;

  void _getData2() {
    if (widget.title == "全部") {
      const all = [
        {"id": 178, "groupType": 0, "groupName": "婚纱", "tips": null, "frontType": null, "remark": "批量跑数据", "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/e8a07f7d-725d-4628-bae9-915da386b002.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 96},
        {"id": 177, "groupType": 0, "groupName": "旗袍", "tips": null, "frontType": null, "remark": "批量跑数据", "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/ee11c6fe-56c9-4257-98c6-01d0bb3fbba5.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 95},
        {"id": 179, "groupType": 0, "groupName": "男神", "tips": null, "frontType": null, "remark": "批量跑数据", "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/1078f28b-1fb3-497b-a737-79a5b9f88167.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 95},
        {"id": 42, "groupType": 0, "groupName": "视频写真", "tips": null, "frontType": null, "remark": "", "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/025bd619-3305-40cb-938d-be4fba8aa0c3.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 95},
        {"id": 37, "groupType": 0, "groupName": "趣味生活", "tips": null, "frontType": null, "remark": null, "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/bce037a3-16da-495e-8cb6-a4c7ea59f0cc.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 94},
        {"id": 24, "groupType": 0, "groupName": "才艺比拼", "tips": null, "frontType": null, "remark": null, "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/d70dee04-71bb-490f-8eb9-849f46376d36.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 93},
        {"id": 28, "groupType": 0, "groupName": "换发型", "tips": null, "frontType": null, "remark": null, "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/77950dc3-2a96-4603-96a7-6414156f3d36.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 98},
        {"id": 188, "groupType": 0, "groupName": "文生图", "tips": null, "frontType": null, "remark": null, "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/dff5f299-ce91-4c9d-85a9-a32f44b35cb1.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 98},
        {"id": 30, "groupType": 0, "groupName": "卡通动漫", "tips": null, "frontType": null, "remark": null, "imgUrlAcross": "https://imgeffect.obs.cn-north-1.myhuaweicloud.com/socialParent/50d558b6-a828-49ad-81cc-2d3c432a9847.png", "imgUrlVertical": null, "tabType": null, "status": 1, "sortNo": 97},
      ];
      listPhotoGroupBean2.value = all.map((e) => ListPhotoGroupBean.fromJson(e)).toList();
      return;
    }

    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.listPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 0,
          "tabType": tabType,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            listPhotoGroupBean2.value = results;
          }
        },
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData2();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0),
        separatorBuilder: (context, index) => 15.verticalSpace,
        itemBuilder: (context, index) {
          return buildCard(index);
        },
        itemCount: (listPhotoGroupBean2.length / 12).ceil(),
      ),
    );
  }

  Widget _cachedImage(double? width, double? height, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(
            HomeDetail(
              title: listPhotoGroupBean2[index].groupName ?? '',
              id: listPhotoGroupBean2[index].id ?? 0,
            ),
            transition: Transition.rightToLeft);
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          CachedImage(
            width: width,
            height: height,
            borderRadius: BorderRadius.circular(12.r),
            imageUrl: listPhotoGroupBean2[index].imgUrlAcross,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              height: height == 114.w ? 30.w : 76.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                gradient: LinearGradient(colors: [
                  const Color(0x00000000),
                  height == 114.w ? const Color(0xFF000000) : const Color(0xB8000000),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: height == 114.w ? 6.w : 8.w, top: height == 114.w ? 0.w : 30.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${listPhotoGroupBean2[index].groupName}",
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: height == 114.w ? 14.w : 17.sp, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard(int index) {
    int current = index * 12;
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    if (listPhotoGroupBean2.length > current) _cachedImage(114.w, 114.w, current),
                    9.verticalSpace,
                    if (listPhotoGroupBean2.length > current + 1) _cachedImage(114.w, 114.w, current + 1),
                  ],
                ),
                9.horizontalSpace,
                if (listPhotoGroupBean2.length > current + 2) _cachedImage(236.w, 236.w, current + 2),
              ],
            ),
            9.verticalSpace,
            Row(
              children: [
                if (listPhotoGroupBean2.length > current + 3) _cachedImage(114.w, 114.w, current + 3),
                9.horizontalSpace,
                if (listPhotoGroupBean2.length > current + 4) _cachedImage(114.w, 114.w, current + 4),
                9.horizontalSpace,
                if (listPhotoGroupBean2.length > current + 5) _cachedImage(114.w, 114.w, current + 5),
              ],
            )
          ],
        ),
        9.verticalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (listPhotoGroupBean2.length > current + 6) _cachedImage(236.w, 236.w, current + 6),
                9.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listPhotoGroupBean2.length > current + 7) _cachedImage(114.w, 114.w, current + 7),
                    9.verticalSpace,
                    if (listPhotoGroupBean2.length > current + 8) _cachedImage(114.w, 114.w, current + 8),
                  ],
                ),
              ],
            ),
            9.verticalSpace,
            Row(
              children: [
                if (listPhotoGroupBean2.length > current + 9) _cachedImage(114.w, 114.w, current + 9),
                9.horizontalSpace,
                if (listPhotoGroupBean2.length > current + 10) _cachedImage(114.w, 114.w, current + 10),
                9.horizontalSpace,
                if (listPhotoGroupBean2.length > current + 11) _cachedImage(114.w, 114.w, current + 11),
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
