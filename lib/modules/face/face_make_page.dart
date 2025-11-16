import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/comm_bottom_tips.dart';
import 'package:zpw/common/comm_error.dart';
import 'package:zpw/common/comm_images_widget.dart';
import 'package:zpw/common/comm_success.dart';
import 'package:zpw/common/comm_video_player_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/face_dialog.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/model/group_other_func_list_bean.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import '../../utils/sp_utils.dart';

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

class _FaceMakePageState extends BaseWidgetState<FaceMakePage> with AppMixin {
  // late final _hasAvatar = (widget.apiType == 10 || widget.apiType == 2 || widget.apiType == 9 || widget.apiType == 3 || widget.apiType == 1 || widget.apiType == 0 ? true.obs : false.obs);
  /// _hasAvatar: 0 表示人脸，1 表示全身照， 2表示其它
  late final _hasAvatar = (widget.apiType == 10 || widget.apiType == 2 || widget.apiType == 9 || widget.apiType == 3 || widget.apiType == 1 || widget.apiType == 16 || widget.apiType == 4
      ? 0.obs
      : widget.apiType == 0
          ? 1.obs
          : 2.obs);
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
      _hasAvatar.value = 0;
    } else if (apiType == 0) {
      _hasAvatar.value = 1;
    } else {
      _hasAvatar.value = 2;
    }

    // Log.e("_hasAvatar:${_hasAvatar.value}");
  }

  // // 检查并显示弹窗
  // Future<bool> _checkFaceAndShowDialog() async {
  //   if (_apiType == 9 || _apiType == 10 || _apiType == 4 || _apiType == 16 || _apiType == 2) {
  //     String lastShownDate = await SpUtils.getString('lastFaceShownDate_$_apiType');
  //     String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //     // 如果当天没有弹过窗，或者日期不同，则显示弹窗
  //     if (lastShownDate != todayDate) {
  //       await SpUtils.setString('lastFaceShownDate_$_apiType', todayDate); // 更新为今天的日期
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  // }

  // Future<bool> _checkWholeBodyAndShowDialog() async {
  //   String lastShownDate = await SpUtils.getString('lastWholeBodyShownDate');
  //   String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //   // 如果当天没有弹过窗，或者日期不同，则显示弹窗
  //   if (lastShownDate != todayDate) {
  //     await SpUtils.setString('lastWholeBodyShownDate', todayDate); // 更新为今天的日期
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  void _make() async {
    // final params = {
    //   "funcId": _funcID,
    //   "imgUrls": [_myHeadImg.value],
    //   // "prompt": "",
    // };

    // Log.e("params------:$params");
    // return;
    UmengCommonSdk.onEvent('Make_click_event', {'name': widget.groupId == -1 ? widget.title : _tags[_currentIndex.value]});
    if (_myHeadImg.isEmpty && (_hasAvatar.value == 0)) {
      _uploadNewHeadImg();
      return;
    }

    _canBack = true;
    _autoPlay.value = false;

    if ((await wxLogin() == true)) {
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

      if (_apiType == 0) {
        // final result = await _checkWholeBodyAndShowDialog();
        // if (result == false) {
        //   await Get.bottomSheet<bool?>(const WholeBodyPhotoBottomSheet(), isDismissible: false);
        // }
        final res = await Get.to<String>(() => Photo_listPage(isNew: false, hasAvatar: _hasAvatar.value == 0));
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
        final res = await Get.to<String>(() => Photo_listPage(isNew: false, hasAvatar: _hasAvatar.value == 0));
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
      // final bean = await HandleTool.instance.QDSUpload<UploadBean>(Api.uploadFile,
      //     params: formData, onModel: (v) => UploadBean.fromJson(v));
      // if (bean == null) return;
      // Log.e("bean:${bean.url}");
      // Log.e("_myHeadImg.value:${_myHeadImg.value}");
      // return;

      final params = {
        "funcId": _funcID,
        "imgUrls": [_myHeadImg.value],
        // "prompt": "",
      };

      try {
        final response = await HttpClient().post(
          ApiConfig.addPhotoRecord,
          data: params,
        );

        if (response.isSuccess && response.data != null) {
          _showSuccess();
        } else {
          _showError();
        }
      } catch (e) {
        _showError();
      }
      return;
    }
  }

  Future<bool> _checkFaceDialog() async {
    String faceDialog = await SpUtils.getString('faceDialog');
    if (faceDialog.isEmpty) {
      var isOK = false;
      await Get.dialog(
        FaceDialog(
          title: "功能授权",
          message: """为了提供更好的服务，我们将会向您申请“AI换脸”功能授权；
功能说明：为了给用户提供“换脸”效果，应用程序需要找出特征点（如眼睛、鼻子、嘴巴等）。
数据收集类型：照片中人脸的特征点（如眼睛、鼻子、嘴巴等）以进行人脸处理。
使用范围与期限：您的图片传输到阿里云服务器（第三方）。所用面部合成后的地址为阿里云临时地址，有效期为30分钟，过期后阿里云会自动删除。我们将不会保存您的任何个人信息，请您放心使用。""",
          onConfirm: () {
            SpUtils.setString('faceDialog', 'faceDialog');
            isOK = true;
          },
        ),
        barrierDismissible: false,
        useSafeArea: false,
      );
      return isOK;
    }

    return true;
  }

  void _uploadNewHeadImg() async {
    // final result = await _checkFaceAndShowDialog();
    // if (result == false) {
    //   await Get.bottomSheet<bool?>(const FacePhotoBottomSheet(), isDismissible: false);
    // }
    final checkOK = await _checkFaceDialog();
    if (checkOK == false) {
      return;
    }
    _autoPlay.value = false;

    if ((await wxLogin() == true)) {
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
      if (res?.isNotEmpty == true) {
        _myHeadImg.value = res ?? '';
        if (_myHeadImg.isNotEmpty) {
          _showHeadImg.value = true;
        }
        // setState(() {});
        return;
      }
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

  Future<void> _getData() async {
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

    _funcIds.clear();

    try {
      final response = await HttpClient().get(
        "${ApiConfig.getGroupOtherFuncList}?funcId=${widget.funcId}&groupId=${widget.groupId}",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => GroupOtherFuncListBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
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
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // _checkImage();
    UmengCommonSdk.onPageStart("FaceMakePage");
    _getData();
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
    return Stack(
      // alignment: Alignment.center,
      children: [
        Container(
          color: Colors.white,
          // margin: widget.videoUrl.isEmpty
          //     ? EdgeInsets.zero
          //     : EdgeInsets.only(
          //         top: ScreenUtil().statusBarHeight,
          //       ),
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
            bgColor: Colors.white,
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
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'arrow_back.png'.comm,
                      width: 16.w,
                      height: 16.w,
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ).paddingOnly(left: 10),
                  ),
                ),
                Container(
                  width: 44,
                  height: 50,
                  color: Colors.white,
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
                          style: const TextStyle(color: Color(0xFF191919), fontSize: 18, fontWeight: FontWeight.w500)),
                    )),
                const Spacer(),
                Container(
                  width: 94,
                  height: 50,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 2),
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () async {
                      if ((await wxLogin() == true)) {
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
                            color: const Color(0xFF656565),
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
            // minimum: EdgeInsets.only(bottom: 10.w),
            child: Container(
              // height: 88.w,
              width: 1.sw,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    width: 1.sw,
                    // height: 180.w,

                    child: Column(
                      children: [
                        SizedBox(height: 8.w),
                        Obx(
                          () => _hasAvatar.value == 0
                              ? Image.asset(
                                  "has_avatar.png".make,
                                  width: 335.w,
                                  height: 140.w,
                                )
                              : _hasAvatar.value == 1
                                  ? Image.asset(
                                      "has_body.png".make,
                                      width: 335.w,
                                      height: 140.w,
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CommText(
                                            text: "温馨提示：",
                                            textColor: const Color(0xFF191919),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(height: 4.w),
                                          CommText(
                                            text: """1.图片内容必须遵守法律法规，不得包含违法、色情、暴力、恐怖主义、赌博、诈骗等信息。\n2.禁止上传侵犯他人版权或含有侮辱、诽谤、恶意攻击等不当内容的图片。\n3.不得上传含有广告、虚假宣传等不良信息的图片。\n4.图片在每次使用后均会被删除，不会在服务器上保存‌。""",
                                            textColor: const Color(0xFFA5A5A5),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                        ),
                        SizedBox(height: 8.w),
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
                        const CommBottomTips(),
                        SizedBox(height: 10.w),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
