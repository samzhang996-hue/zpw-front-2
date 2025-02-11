import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/model/page_photo_group_bind_bean.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class FaceItem extends StatefulWidget {
  const FaceItem({super.key, required this.id});

  final int id;

  @override
  State<FaceItem> createState() => _FaceItemState();
}

class _FaceItemState extends State<FaceItem> {
  late final _bean = PagePhotoGroupBindBean().obs;

  void _getData() {
    final params = {
      "id": widget.id,
      "pageIndex": 1,
      "pageSize": 20,
    };

    Log.e("params:$params");

    HandleTool.instance.QDSGet<PagePhotoGroupBindBean>(
      Api.pagePhotoGroupBind,
      isShowProgress: true,
      params: params,
      success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _bean.value = results.first;
        }
      },
      onModel: (json) => PagePhotoGroupBindBean.fromJson(json),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        // color: Colors.red,
        child: GridView.builder(
          padding: EdgeInsets.only(top: 10.w),
          itemCount: _bean.value.records?.length,
          itemBuilder: (c, index) {
            final bean = _bean.value.records?[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => FaceMakePage(
                    groupId: widget.id,
                    title: bean?.photoFuncResp?.tags ?? '',
                    funcId: bean?.photoFuncResp?.id ?? 0,
                    imageUrl: bean?.photoFuncResp?.showImgGif ?? '',
                    videoUrl: bean?.photoFuncResp?.videoUrl ?? '',
                    apiType: bean?.photoFuncResp?.apiType ?? -1,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: index.isOdd ? Colors.amber : Colors.red,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      index.isEven
                          ? "face_item_2.png".face
                          : "face_item_1.png".face,
                      width: 175.w,
                      height: 265.w,
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10.w),
                          Text(
                            "照片拥抱",
                            style: TextStyle(
                              color: const Color(0xFF191919),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          Text(
                            "-${"${bean?.photoFuncResp?.funcName}"}-",
                            style: TextStyle(
                              color: const Color(0xFF191919),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 14.w),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.w),
                            child: QdsImage(
                              "${bean?.photoFuncResp?.showImgGif}",
                              144.w,
                              175.w,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (bean?.photoFuncResp?.tags?.isNotEmpty == true)
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
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "${bean?.photoFuncResp?.tags}",
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
            childAspectRatio: 175.w / 265.w,
          ),
        ),
      ),
    );
  }
}
