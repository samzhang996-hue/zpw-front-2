import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/model/page_photo_group_bind_bean.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class CollectionItem extends StatefulWidget {
  const CollectionItem({super.key, required this.id});

  final int id;

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  // late final _bean = PagePhotoGroupBindBean().obs;
  late final _records = <Records>[].obs;
  var _loadPage = 2;
  var _pages = 0;

  var _isLoading = false;
  void _getData() {
    final params = {
      "id": widget.id,
      "pageIndex": 1,
      "pageSize": 5,
    };

    Log.e("params:$params");

    HandleTool.instance.QDSGet<PagePhotoGroupBindBean>(
      Api.pagePhotoGroupBind,
      isShowProgress: true,
      params: params,
      success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _records.value = results.first.records ?? [];
          _pages = results.first.pages ?? 0;
          _loadPage = 2;
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
      "pageSize": 5,
    };

    Log.e("_loadPage.params:$params");

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
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 10.w),
                  itemCount: _records.length,
                  itemBuilder: (c, index) {
                    final bean = _records[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => FaceMakePage(
                              title: bean.photoFuncResp?.tags ?? '',
                              funcId: bean.photoFuncResp?.id ?? 0,
                              imageUrl: bean.photoFuncResp?.showImgGif ?? "",
                            ));
                      },
                      child: Container(
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
                                  265.w,
                                ),
                              ),
                            ),
                            if (bean.photoFuncResp?.tags?.isNotEmpty == true)
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
                                          left: 10.w, top: 10.w),
                                      child: Text(
                                        "${bean.photoFuncResp?.tags ?? bean.photoFuncResp?.funcName}",
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
            ],
          ),
        ),
      ),
    );
  }
}
