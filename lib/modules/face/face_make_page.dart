import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/bottom_sheet/zpw_face_photo_bottom_sheet.dart';
import 'package:zpw/common/zpw_comm_error.dart';
import 'package:zpw/common/zpw_comm_images_widget.dart';
import 'package:zpw/common/zpw_comm_success.dart';
import 'package:zpw/common/zpw_comm_video_player_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_qds_image.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/model/zpw_group_other_func_list_bean.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import '../../common/bottom_sheet/zpw_whole_body_photo_bottom_sheet.dart';
import '../../utils/zpw_sp_utils.dart';

class FaceMakePage extends ZpwBaseStatefulWidget {
  final String title;
  final int funcId;
  final String imageUrl;
  final String videoUrl;
  final int groupId;

  final int apiType;

  FaceMakePage({
    required this.title,
    required this.funcId,
    required this.imageUrl,
    required this.videoUrl,
    this.groupId = -1,
    required this.apiType,
  });

  @override
  ZpwBaseWidgetState<FaceMakePage> getState() => _FaceMakePageState();
}

class _FaceMakePageState extends ZpwBaseWidgetState<FaceMakePage> with ZpwAppMixin {
  // late final _hasAvatar = (widget.apiType == 10 || widget.apiType == 2 || widget.apiType == 9 || widget.apiType == 3 || widget.apiType == 1 || widget.apiType == 0 ? true.obs : false.obs);
  late final _hasAvatar = (widget.apiType == 10 || widget.apiType == 2 || widget.apiType == 9 || widget.apiType == 3 || widget.apiType == 1 || widget.apiType == 16 || widget.apiType == 4 ? true.obs : false.obs);
  var _canBack = true;
  late final _autoPlay = true.obs;
  late final _initialPage = 0.obs;
  late final _videoUrls = <String>[].obs;
  late final _tags = <String>[].obs;
  late final _apiTypes = <int>[].obs;
  late final _funcIds = <int>[];
  late final _title = widget.title.obs;
  late final _currentIndex = 0.obs;

  late final _currentZodiac = 0.obs;

  late final _showHeadImg = true.obs;

  bool get _isNotEmptyVideoUrl => widget.videoUrl.isNotEmpty;

  late final _myHeadImg = ZpwHandleTool.instance.headImg.obs;
  var _showDialog = false;
  late final _list = <String>[].obs;
  VideoPlayerController? _videoPlayerController;
  late int _apiType = widget.apiType;
  var _isScroller = false;
  int get _funcID => widget.groupId == -1
      ? widget.funcId
      : _isScroller
          ? _funcIds[_currentIndex.value]
          : _currentIndex.value == 0
              ? widget.funcId
              : _funcIds[_currentIndex.value];

  void _toHistory() async {
    _canBack = false;
    _autoPlay.value = false;
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.pause();
    }
    await Get.to(() => WorksPage());
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.play();
    }
  }

  void _showSuccess() async {
    _showDialog = true;
    Get.dialog(
      const ZpwCommSuccess(),
      barrierDismissible: false,
    );
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.play();
    }
    Future.delayed(const Duration(seconds: 3), () {
      _showDialog = false;
      if (_canBack) {
        Get.back();
      }
    });
  }

  void _showError() async {
    final res = await Get.dialog(const ZpwCommError(), barrierDismissible: false);
    if (res == true) {}
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.play();
    }
  }

  void _getNewHasAvatar() {
    if (widget.groupId == -1) {
      return;
    }
    _isScroller = true;
    var apiType = _apiTypes[_currentIndex.value];
    _apiType = apiType;
    // if (apiType == 10 || apiType == 2 || apiType == 9 || apiType == 3 || apiType == 1 || apiType == 0) {
    /// apiType: 9  异性的你
    /// apiType: 10  变老变年轻
    /// apiType: 4  卡通动漫
    /// apiType: 16  图片
    /// apiType: 2  视频
    if (apiType == 10 || apiType == 2 || apiType == 9 || apiType == 3 || apiType == 1 || apiType == 16 || apiType == 4) {
      _hasAvatar.value = true;
    } else {
      _hasAvatar.value = false;
    }

    // ZpwLog.e("_hasAvatar:${_hasAvatar.value}");
  }

  // 检查并显示弹窗
  Future<bool> _checkFaceAndShowDialog() async {
    if (_apiType == 9 || _apiType == 10 || _apiType == 4 || _apiType == 16 || _apiType == 2) {
      String lastShownDate = await ZpwSpUtils.getString('lastFaceShownDate_$_apiType');
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 如果当天没有弹过窗，或者日期不同，则显示弹窗
      if (lastShownDate != todayDate) {
        await ZpwSpUtils.setString('lastFaceShownDate_$_apiType', todayDate); // 更新为今天的日期
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<bool> _checkWholeBodyAndShowDialog() async {
    String lastShownDate = await ZpwSpUtils.getString('lastWholeBodyShownDate');
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 如果当天没有弹过窗，或者日期不同，则显示弹窗
    if (lastShownDate != todayDate) {
      await ZpwSpUtils.setString('lastWholeBodyShownDate', todayDate); // 更新为今天的日期
      return false;
    } else {
      return true;
    }
  }

  void _make() async {
    // ZpwLog.e("params------:${widget.funcId},params:${widget.groupId},type:${widget.apiType}");
    // return;
    UmengCommonSdk.onEvent('Make_click_event', {'name': widget.groupId == -1 ? widget.title : _tags[_currentIndex.value]});
    if (_myHeadImg.isEmpty && (_hasAvatar.isTrue)) {
      _uploadNewHeadImg();
      return;
    }

    _canBack = true;
    _autoPlay.value = false;

    if ((await zpwWxLogin() == true)) {
      if (_isNotEmptyVideoUrl) {
        _videoPlayerController?.pause();
      }
      if (!ZpwHandleTool.instance.isMember) {
        Get.find<VipLogic>().getVipHome();
        await Get.to(() => VipPage());
        if (_isNotEmptyVideoUrl) {
          _videoPlayerController?.play();
        }
        return;
      }

      if (_apiType == 0) {
        final result = await _checkWholeBodyAndShowDialog();
        if (result == false) {
          await Get.bottomSheet<bool?>(const ZpwWholeBodyPhotoBottomSheet(), isDismissible: false);
        }
        final res = await Get.to<String>(() => Photo_listPage(isNew: false, hasAvatar: _hasAvatar.value));
        _videoPlayerController?.play();

        if (res == null) {
          return;
        }

        if (res.isNotEmpty == true) {
          _myHeadImg.value = res;
        } else {
          return;
        }
      }

      if (_apiType == 5 || _apiType == 8) {
        final res = await Get.to<String>(() => Photo_listPage(isNew: false, hasAvatar: _hasAvatar.value));
        _videoPlayerController?.play();

        if (res == null) {
          return;
        }

        if (res.isNotEmpty == true) {
          _myHeadImg.value = res;
        } else {
          return;
        }
      }

      // return;

      // if (_myHeadImg.value.isEmpty || _showHeadImg.isFalse) {
      //   final res = await Get.to<String>(() => Photo_listPage(isNew: false));
      //   if (res?.isNotEmpty == true) {
      //     _myHeadImg.value = res!;
      //     if (_myHeadImg.isNotEmpty) {
      //       _showHeadImg.value = true;
      //     }
      //     return;
      //   } else {
      //     return;
      //   }
      // }

      // final formData = ffff.FormData.fromMap({
      //   "file": await ffff.MultipartFile.fromFile(_myHeadImg.value),
      // });
      // final bean = await ZpwHandleTool.instance.QDSUpload<UploadBean>(Api.uploadFile,
      //     params: formData, onModel: (v) => UploadBean.fromJson(v));
      // if (bean == null) return;
      // ZpwLog.e("bean:${bean.url}");
      // ZpwLog.e("_myHeadImg.value:${_myHeadImg.value}");
      // return;

      final params = {
        "funcId": _funcID,
        "imgUrls": [_myHeadImg.value],
        // "prompt": "",
      };

      ZpwHandleTool.instance.SMWPost(ZpwApi.zpwAddPhotoRecord, params: params, success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _showSuccess();
        } else {
          _showError();
        }
      });
      return;
    }
  }

  void _uploadNewHeadImg() async {
    final result = await _checkFaceAndShowDialog();
    if (result == false) {
      await Get.bottomSheet<bool?>(const ZpwFacePhotoBottomSheet(), isDismissible: false);
    }

    _autoPlay.value = false;

    if ((await zpwWxLogin() == true)) {
      if (_isNotEmptyVideoUrl) {
        _videoPlayerController?.pause();
      }
      if (!ZpwHandleTool.instance.isMember) {
        Get.find<VipLogic>().getVipHome();
        await Get.to(() => VipPage());
        if (_isNotEmptyVideoUrl) {
          _videoPlayerController?.play();
        }
        return;
      }
      if (_isNotEmptyVideoUrl) {
        _videoPlayerController?.pause();
      }
      final res = await Get.to<String>(() => Photo_listPage(isNew: false));
      if (_isNotEmptyVideoUrl) {
        _videoPlayerController?.play();
      }
      ZpwLog.e("res:$res");
      if (res?.isNotEmpty == true) {
        _myHeadImg.value = res ?? '';
        if (_myHeadImg.isNotEmpty) {
          _showHeadImg.value = true;
        }
        // setState(() {});
        return;
      }
    }

    // _myHeadImg.value = ZpwHandleTool.instance.headImg;
  }

  void _closeHeadImg() {
    _showHeadImg.value = false;
    _myHeadImg.value = "";
  }

  void _checkImage() {
    // File file = File(_myHeadImg.value);
    // bool isExists = file.existsSync();
    // if (!isExists) {
    //   _showHeadImg.value = false;
    // }
  }

  void _getData() {
    if (widget.groupId == -1) {
      if (_isNotEmptyVideoUrl) {
        _videoUrls.add(widget.videoUrl);
      } else {
        _list.add(widget.imageUrl);
      }
      return;
    }
    final params = {
      "funcId": widget.funcId,
      "groupId": widget.groupId,
    };

    ZpwLog.e("params:$params");
    _funcIds.clear();
    ZpwHandleTool.instance.QDSGet<ZpwGroupOtherFuncListBean>(
      "${ZpwApi.zpwGetGroupOtherFuncList}?funcId=${widget.funcId}&groupId=${widget.groupId}",
      isShowProgress: true,
      success: (isSuccess, code, message, results) {
        if (isSuccess == true && results.isNotEmpty) {
          _apiTypes.value = results.map((e) => e.apiType ?? -1).toList();
          _tags.value = results.map((e) => e.tags ?? "").toList();
          _funcIds.addAll(results.map((e) => e.id ?? 0).toList());
          _initialPage.value = _funcIds.indexOf(widget.funcId);
          if (_isNotEmptyVideoUrl) {
            _videoUrls.value = results.map((e) => '${e.videoUrl}').toList();
          } else {
            _list.value = results.map((e) => '${e.showImgGif}').toList();
          }
        }
      },
      onModel: (json) => ZpwGroupOtherFuncListBean.fromJson(json),
    );
  }

  @override
  void initState() {
    super.initState();
    // _checkImage();
    UmengCommonSdk.onPageStart("FaceMakePage");
    _getData();
    ZpwLog.e("params------:${widget.funcId},params:${widget.groupId},type:${widget.apiType}");
  }

  @override
  void dispose() {
    UmengCommonSdk.onPageEnd("FaceMakePage");
    _canBack = false;
    super.dispose();
  }

  @override
  void zpwYCloseInputMethod() {}

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container(
      color: const Color(0xFF191919),
      child: Stack(
        // alignment: Alignment.center,
        children: [
          Container(
            margin: widget.videoUrl.isEmpty
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    top: ScreenUtil().statusBarHeight,
                  ),
            child: widget.videoUrl.isEmpty
                ? Obx(
                    () => _list.isEmpty
                        ? const SizedBox.shrink()
                        : ZpwCommImagesWidget(
                            images: _list,
                            initialPage: _initialPage.value,
                            groupId: widget.groupId,
                            onPageChanged: (index) {
                              _currentIndex.value = index;
                              _getNewHasAvatar();
                            },
                          ),
                  )
                : Obx(
                    () => _videoUrls.isEmpty
                        ? const SizedBox.shrink()
                        : ZpwCommVideoPlayerWidget(
                            autoPlay: _autoPlay.value,
                            initialPage: _initialPage.value,
                            videoUrls: _videoUrls,
                            groupId: widget.groupId,
                            onPageChanged: (index, videoPlayerController) {
                              _currentIndex.value = index;
                              _videoPlayerController = videoPlayerController;
                              _getNewHasAvatar();
                            },
                          ),
                  ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: zpwYAppBar(
              bgColor: Colors.transparent,
              widget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'arrow_back.png'.comm,
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover,
                        color: Colors.white,
                      ).paddingOnly(left: 10),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 50,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                  ),
                  const Spacer(),
                  Obx(() => SizedBox(
                        width: 1.sw * 0.4,
                        child: Text(
                            widget.groupId == -1
                                ? _title.value
                                : _tags.isEmpty
                                    ? ""
                                    : _tags[_currentIndex.value],
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      )),
                  const Spacer(),
                  Container(
                    width: 94,
                    height: 50,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(top: 2),
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () async {
                        if ((await zpwWxLogin() == true)) {
                          _toHistory();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Image.asset(
                          //   "my_work_ic.png".make,
                          //   width: 22.w,
                          //   height: 22.w,
                          // ),
                          Text(
                            "我的作品",
                            style: TextStyle(
                              color: Color(0xffB2B2B2),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 16.w)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              isMake: true,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 20.w),
              child: Obx(() => Container(
                    height: _hasAvatar.value ? 162.w : 65.w,
                    width: 1.sw,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        // const Spacer(),

                        if (_hasAvatar.value)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: Container(
                                      width: 1.sw,
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF051B38).withOpacity(0.87),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.w),
                                            topRight: Radius.circular(16.w),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    width: 1.sw,
                                    height: 52.w,
                                    color: const Color(0xFF191919),
                                  ),
                                ],
                              ),
                              Obx(
                                () => SizedBox(
                                  width: 1.sw,
                                  height: 76.w,
                                  child: _showHeadImg.isFalse
                                      ? Center(
                                          child: GestureDetector(
                                            onTap: _uploadNewHeadImg,
                                            behavior: HitTestBehavior.opaque,
                                            child: Image.asset(
                                              "no_head_img.png".make,
                                              width: 76.w,
                                              height: 76.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              if (_myHeadImg.isNotEmpty)
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 72.w,
                                                      height: 72.w,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.grey,
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF7EFAEF),
                                                            Color(0xFF7FE1FB),
                                                          ],
                                                          begin: Alignment.centerLeft, // 渐变的起始点
                                                          end: Alignment.centerRight, // 渐变的结束点
                                                        ),
                                                      ),
                                                    ),
                                                    ClipOval(
                                                      child: ZpwQdsImage(_myHeadImg.value, 68.w, 68.w),
                                                    ),
                                                  ],
                                                )
                                              else
                                                GestureDetector(
                                                  onTap: _uploadNewHeadImg,
                                                  behavior: HitTestBehavior.opaque,
                                                  child: Image.asset(
                                                    "no_head_img.png".make,
                                                    width: 76.w,
                                                    height: 76.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              Obx(
                                                () => Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Visibility(
                                                    visible: _showHeadImg.isTrue && ZpwHandleTool.instance.headImg.isNotEmpty,
                                                    child: GestureDetector(
                                                      onTap: _closeHeadImg,
                                                      behavior: HitTestBehavior.opaque,
                                                      child: Image.asset(
                                                        "make_close.png".make,
                                                        width: 18.w,
                                                        height: 18.w,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   bottom: -5.w,
                                              //   right: 0,
                                              //   child: GestureDetector(
                                              //     onTap: _uploadNewHeadImg,
                                              //     behavior: HitTestBehavior.opaque,
                                              //     child: Container(
                                              //       width: 76.w,
                                              //       height: 21.w,
                                              //       decoration: BoxDecoration(
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 12.w),
                                              //         gradient:
                                              //             const LinearGradient(
                                              //           colors: [
                                              //             Color(0xFFFF2EB8),
                                              //             Color(0xFFFF2E2E)
                                              //           ],
                                              //           begin: Alignment
                                              //               .centerLeft, // 渐变的起始点
                                              //           end: Alignment
                                              //               .centerRight, // 渐变的结束点
                                              //         ),
                                              //       ),
                                              //       child: Center(
                                              //         child: ZpwCommText(
                                              //           text: "上传新头像",
                                              //           textColor:
                                              //               const Color(0xFFFFFFFF),
                                              //           fontSize: 12.sp,
                                              //           fontWeight: FontWeight.w500,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),

                        // if (_hasAvatar.value) SizedBox(height: 12.w),
                        Expanded(
                          child: Container(
                            width: 1.sw,
                            height: 100.w,
                            color: _hasAvatar.isTrue ? const Color(0xFF191919) : Colors.transparent,
                            child: Column(
                              children: [
                                const Spacer(flex: 2),
                                GestureDetector(
                                  onTap: _make,
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 357.w,
                                    height: 52.w,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7EFAEF),
                                          Color(0xFF7FE1FB),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      // color: const Color(0xFFFF2E7E),
                                      borderRadius: BorderRadius.circular(26.w),
                                    ),
                                    child: Center(
                                      child: ZpwCommText(
                                        text: "一键制作",
                                        textColor: const Color(0xFF191919),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 3),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 10.w),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
