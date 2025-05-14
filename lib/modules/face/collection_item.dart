import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/no_more_content_view.dart';
import 'package:zpw/model/page_photo_group_bind_bean.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/modules/face/gather_single_page.dart';
import 'package:zpw/modules/wf/wst/wst_view.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class CollectionItem extends StatefulWidget {
  const CollectionItem({super.key, required this.id, this.isHome = false});

  final int id;

  final bool isHome;

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  // late final _bean = PagePhotoGroupBindBean().obs;
  late final _records = <Records>[].obs;
  var _loadPage = 2;
  var _pages = 0;

  var _isLoading = false;
  late final _showNoMoreContent = false.obs;

  // double get _itemHeight => widget.isHome == false ? 295.w : 265.w;
  double get _itemHeight => 335.w;

  void _getData() {
    final params = {
      "id": widget.id,
      "pageIndex": 1,
      "pageSize": 10,
    };

    Log.e("params:$params");
    _showNoMoreContent.value = false;
    HandleTool.instance.QDSGet<PagePhotoGroupBindBean>(
      Api.pagePhotoGroupBind,
      isShowProgress: true,
      params: params,
      success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _records.value = results.first.records ?? [];
          _pages = results.first.pages ?? 0;
          _showNoMoreContent.value = true;
          _loadPage = 2;
        } else {
          _showNoMoreContent.value = true;
        }
      },
      onModel: (json) => PagePhotoGroupBindBean.fromJson(json),
    );
  }

  void _getLoadData() {
    if (_pages < _loadPage) {
      return;
    }

    if (_isLoading) {
      return;
    }
    _isLoading = true;

    final params = {
      "id": widget.id,
      "pageIndex": _loadPage,
      "pageSize": 10,
    };

    Log.e("_loadPage.params:$params");
    _showNoMoreContent.value = false;
    HandleTool.instance.QDSGet<PagePhotoGroupBindBean>(
      Api.pagePhotoGroupBind,
      isShowProgress: true,
      params: params,
      success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _records.addAll(results.first.records ?? []);
          _pages = results.first.pages ?? 0;
          _loadPage += 1;
          _isLoading = false;
          _showNoMoreContent.value = true;
        } else {
          _showNoMoreContent.value = true;
        }
      },
      onModel: (json) => PagePhotoGroupBindBean.fromJson(json),
    );
  }

  /// 模板
  Widget _getBindType0(Records bean, double height) {
    return GestureDetector(
      onTap: () {
        UmengCommonSdk.onEvent('Muban_click_event', {'Records': '${bean.toJson()}'});
        if (bean.photoFuncResp?.apiType == 6) {
          Get.to(WstPage(), arguments: {"funcValue": bean.photoFuncResp?.funcValue ?? "", "showImgGif": bean.photoFuncResp?.showImgGif ?? "", "funcId": bean.photoFuncResp?.id ?? 0});
          return;
        }
        Get.to(
          () => FaceMakePage(
            groupId: widget.id,
            title: bean.photoFuncResp?.tags ?? '',
            funcId: bean.photoFuncResp?.id ?? 0,
            imageUrl: bean.photoFuncResp?.showImgGif ?? "",
            videoUrl: bean.photoFuncResp?.videoUrl ?? "",
            apiType: bean.photoFuncResp?.apiType ?? -1,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // color: index.isOdd ? Colors.amber : Colors.red,
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.w),
                    child: QdsImage(
                      "${bean.photoFuncResp?.showImgGif}",
                      175.w,
                      height.w,
                    ),
                  ),
                ),
                // if (bean.photoFuncResp?.tags?.isNotEmpty == true)
                //   Positioned(
                //     left: 0,
                //     right: 0,
                //     bottom: 0,
                //     child: Container(
                //       height: 55.w,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(8.w),
                //           bottomRight: Radius.circular(8.w),
                //         ),
                //         gradient: const LinearGradient(
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //           colors: [
                //             Color(0x00141414),
                //             Color(0xBA000000),
                //           ],
                //         ),
                //       ),
                //       child: Align(
                //         alignment: Alignment.centerLeft,
                //         child: Padding(
                //           padding: EdgeInsets.only(left: 10.w, top: 10.w),
                //           child: Text(
                //             "${bean.photoFuncResp?.tags ?? bean.photoFuncResp?.funcName}",
                //             style: TextStyle(
                //               color: const Color(0xFFFFFFFF),
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
              ],
            ),
          ),
          // if (widget.isHome == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${bean.photoFuncResp?.tags ?? bean.photoFuncResp?.funcName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF191919),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Text(
              //   "2.5w",
              //   maxLines: 1,
              //   style: TextStyle(
              //     color: const Color(0xFF191919),
              //     fontSize: 14.sp,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ).paddingOnly(top: 5.w, left: 5.w, right: 5.w),
          5.verticalSpace,
          Container(
            height: 37.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(21.5.w),
                gradient: const LinearGradient(colors: [
                  Color(0xFF7EFAEF),
                  Color(0xFF7FE1FB),
                ])),
            child: Center(
              child: Text(
                "一键同款",
                maxLines: 1,
                style: TextStyle(
                  color: const Color(0xFF191919),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 合集
  Widget _getBindType1(Records bean, double height) {
    return GestureDetector(
      onTap: () {
        // Log.e('bean:${bean.toJson()}');
        // if (bean.photoFuncResp?.apiType == 6) {
        //   Get.to(WstPage(), arguments: {
        //     "funcValue": bean.photoFuncResp?.funcValue ?? "",
        //     "showImgGif": bean.photoFuncResp?.showImgGif ?? "",
        //     "funcId": bean.photoFuncResp?.id ?? 0
        //   });
        //   return;
        // }

        Get.to(
          () => GatherSinglePage(
            id: bean.photoGroupResp?.id ?? 0,
            imgUrlAcross: bean.photoGroupResp?.imgUrlAcross ?? "",
            title: bean.photoGroupResp?.groupName ?? '',
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // color: index.isOdd ? Colors.amber : Colors.red,
              // color: Colors.red,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Stack(
              children: [
                // Image.asset(
                //   // index.isEven ? "face_item_2.png".face : "face_item_1.png".face,
                //   "face_item_1.png".face,
                //   width: 175.w,
                //   height: 265.w,
                //   fit: BoxFit.cover,
                // ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8.w),
                  child: QdsImage(
                    "${bean.photoGroupResp?.imgUrlVertical}",
                    175.w,
                    height.w,
                    fit: BoxFit.cover,
                  ),
                ),
                // Center(
                //   child: Column(
                //     children: [
                //       SizedBox(height: 10.w),
                //       Text(
                //         "${bean.photoGroupResp?.groupName}",
                //         style: TextStyle(
                //           color: const Color(0xFF191919),
                //           fontSize: 22.sp,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       SizedBox(height: 3.w),
                //       if (bean.photoGroupResp?.remark?.isNotEmpty == true)
                //         Text(
                //           "-${bean.photoGroupResp?.remark ?? ''}-",
                //           style: TextStyle(
                //             color: const Color(0xFF191919),
                //             fontSize: 11.sp,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       SizedBox(height: 14.w),
                //       // ClipRRect(
                //       //   borderRadius: BorderRadius.circular(8.w),
                //       //   child: QdsImage(
                //       //     "${bean.photoGroupResp?.imgUrlAcross}",
                //       //     144.w,
                //       //     175.w,
                //       //   ),
                //       // )
                //     ],
                //   ),
                // ),
                // if (bean.photoGroupResp?.tips?.isNotEmpty == true)
                //   Positioned(
                //     left: 0,
                //     right: 0,
                //     bottom: 0,
                //     child: Container(
                //       height: 55.w,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(8.w),
                //           bottomRight: Radius.circular(8.w),
                //         ),
                //         gradient: const LinearGradient(
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //           colors: [
                //             Color(0x00141414),
                //             Color(0xBA000000),
                //           ],
                //         ),
                //       ),
                //       child: Align(
                //         alignment: Alignment.centerLeft,
                //         child: Padding(
                //           padding: EdgeInsets.only(left: 10.w),
                //           child: Text(
                //             "${bean.photoGroupResp?.tips}",
                //             style: TextStyle(
                //               color: const Color(0xFFFFFFFF),
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
              ],
            ),
          ),
          // if (widget.isHome == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${bean.photoGroupResp?.groupName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF191919),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Text(
              //   "2.5w",
              //   maxLines: 1,
              //   style: TextStyle(
              //     color: const Color(0xFF191919),
              //     fontSize: 14.sp,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ).paddingOnly(top: 5.w, left: 5.w, right: 5.w),
          5.verticalSpace,
          Container(
            height: 37.w,
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(21.5.w),
                gradient: const LinearGradient(colors: [
                  Color(0xFF7EFAEF),
                  Color(0xFF7FE1FB),
                ])),
            child: Center(
              child: Text(
                "一键同款",
                maxLines: 1,
                style: TextStyle(
                  color: const Color(0xFF191919),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
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
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 6.w),
        // color: Colors.red,
        child: EasyRefresh(
          onRefresh: () async {
            _getData();
          },
          onLoad: () async {
            _getLoadData();
          },
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // SliverToBoxAdapter(
                    //   child: SizedBox(height: 10.w),
                    // ),
                    SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.w,
                      crossAxisSpacing: 8.w,
                      childCount: _records.length,
                      itemBuilder: (context, index) {
                        final bean = _records[index];
                        final height = index.isOdd ? 265.w : 325.w;
                        return bean.bindType == 0 ? _getBindType0(bean, height) : _getBindType1(bean, height);
                      },
                    ),
                    // SliverGrid.builder(
                    //   itemCount: _records.length,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     mainAxisSpacing: 8.w,
                    //     crossAxisSpacing: 8.w,
                    //     childAspectRatio: 175.w / _itemHeight,
                    //   ),
                    //   itemBuilder: (c, index) {
                    //     final bean = _records[index];
                    //     return bean.bindType == 0 ? _getBindType0(bean) : _getBindType1(bean);
                    //   },
                    // ),
                    SliverToBoxAdapter(
                      child: Obx(
                        () => Visibility(
                          visible: _showNoMoreContent.isTrue,
                          child: const NoMoreContentView(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
