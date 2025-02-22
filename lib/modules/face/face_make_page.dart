import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/comm_error.dart';
import 'package:zpw/common/comm_images_widget.dart';
import 'package:zpw/common/comm_success.dart';
import 'package:zpw/common/comm_video_player_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/model/group_other_func_list_bean.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class FaceMakePage extends BaseStatefulWidget {
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
  BaseWidgetState<FaceMakePage> getState() => _FaceMakePageState();
}

class _FaceMakePageState extends BaseWidgetState<FaceMakePage> {
  late final _hasAvatar = (widget.apiType == 10 ||
          widget.apiType == 2 ||
          widget.apiType == 9 ||
          widget.apiType == 3 ||
          widget.apiType == 1 ||
          widget.apiType == 0
      ? true.obs
      : false.obs);
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

  late final _myHeadImg = HandleTool.instance.headImg.obs;
  var _showDialog = false;
  late final _list = <String>[].obs;
  VideoPlayerController? _videoPlayerController;

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
      const CommSuccess(),
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
    final res = await Get.dialog(const CommError(), barrierDismissible: false);
    if (res == true) {}
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.play();
    }
  }

  void _getNewHasAvatar() {
    if (widget.groupId == -1) {
      return;
    }
    var apiType = _apiTypes[_currentIndex.value];
    if (apiType == 10 ||
        apiType == 2 ||
        apiType == 9 ||
        apiType == 3 ||
        apiType == 1 ||
        apiType == 0) {
      _hasAvatar.value = true;
    } else {
      _hasAvatar.value = false;
    }

    // Log.e("_hasAvatar:${_hasAvatar.value}");
  }

  void _make() async {
    UmengCommonSdk.onEvent('Make_click_event', {
      'name': widget.groupId == -1 ? widget.title : _tags[_currentIndex.value]
    });
    _canBack = true;
    _autoPlay.value = false;
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.pause();
    }
    if (!HandleTool.instance.isMember) {
      Get.find<VipLogic>().getVipHome();
      await Get.to(() => VipPage());
      if (_isNotEmptyVideoUrl) {
        _videoPlayerController?.play();
      }
      return;
    }

    if (!_hasAvatar.value || _myHeadImg.value.isEmpty) {
      final res = await Get.to<String>(
          () => Photo_listPage(isNew: false, hasAvatar: _hasAvatar.value));
      _videoPlayerController?.play();
      Log.e("res:$res");
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
    // final bean = await HandleTool.instance.QDSUpload<UploadBean>(Api.uploadFile,
    //     params: formData, onModel: (v) => UploadBean.fromJson(v));
    // if (bean == null) return;
    // Log.e("bean:${bean.url}");
    // Log.e("_myHeadImg.value:${_myHeadImg.value}");
    // return;

    final params = {
      "funcId":
          widget.groupId == -1 ? widget.funcId : _funcIds[_currentIndex.value],
      "imgUrls": [_myHeadImg.value],
      // "prompt": "",
    };

    HandleTool.instance.SMWPost(Api.addPhotoRecord, params: params,
        success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        _showSuccess();
      } else {
        _showError();
      }
    });
    return;
  }

  void _uploadNewHeadImg() async {
    _autoPlay.value = false;
    if (_isNotEmptyVideoUrl) {
      _videoPlayerController?.pause();
    }
    if (!HandleTool.instance.isMember) {
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
    Log.e("res:$res");
    if (res?.isNotEmpty == true) {
      _myHeadImg.value = res ?? '';
      if (_myHeadImg.isNotEmpty) {
        _showHeadImg.value = true;
      }
      // setState(() {});
      return;
    }
    // _myHeadImg.value = HandleTool.instance.headImg;
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

    Log.e("params:$params");
    _funcIds.clear();
    HandleTool.instance.QDSGet<GroupOtherFuncListBean>(
      "${Api.getGroupOtherFuncList}?funcId=${widget.funcId}&groupId=${widget.groupId}",
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
      onModel: (json) => GroupOtherFuncListBean.fromJson(json),
    );
  }

  @override
  void initState() {
    super.initState();
    // _checkImage();
    UmengCommonSdk.onPageStart("FaceMakePage");
    _getData();
    Log.e("params:${widget.funcId},params:${widget.groupId}");
  }

  @override
  void dispose() {
    UmengCommonSdk.onPageEnd("FaceMakePage");
    _canBack = false;
    super.dispose();
  }

  @override
  void yCloseInputMethod() {}

  @override
  Widget initDefaultBuild(BuildContext context) {
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
                        : CommImagesWidget(
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
                        : CommVideoPlayerWidget(
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
            child: YAppBar(
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
                      child: const Icon(
                        Icons.arrow_back_ios,
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
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                  const Spacer(),
                  Container(
                    width: 94,
                    height: 50,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(top: 2),
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: _toHistory,
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
                                          color: const Color(0xFF051B38)
                                              .withOpacity(0.87),
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
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.grey,
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFF7EFAEF),
                                                            Color(0xFF7FE1FB),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft, // 渐变的起始点
                                                          end: Alignment
                                                              .centerRight, // 渐变的结束点
                                                        ),
                                                      ),
                                                    ),
                                                    ClipOval(
                                                      child: QdsImage(
                                                          _myHeadImg.value,
                                                          68.w,
                                                          68.w),
                                                    ),
                                                  ],
                                                )
                                              else
                                                GestureDetector(
                                                  onTap: _uploadNewHeadImg,
                                                  behavior:
                                                      HitTestBehavior.opaque,
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
                                                    visible:
                                                        _showHeadImg.isTrue &&
                                                            HandleTool
                                                                .instance
                                                                .headImg
                                                                .isNotEmpty,
                                                    child: GestureDetector(
                                                      onTap: _closeHeadImg,
                                                      behavior: HitTestBehavior
                                                          .opaque,
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
                                              //         child: CommText(
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
                            color: _hasAvatar.isTrue
                                ? const Color(0xFF191919)
                                : Colors.transparent,
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
                                      child: CommText(
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
