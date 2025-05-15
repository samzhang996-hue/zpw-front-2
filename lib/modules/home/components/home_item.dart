import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        CachedImage(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(12.r),
          imageUrl: listPhotoGroupBean2[index].imgUrlAcross,
        ),
        Center(
          child: Text("i:$index,l: ${listPhotoGroupBean2.length}"),
        )
      ],
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
