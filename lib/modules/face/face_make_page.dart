import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/splash/photo_list/photo_list_view.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';

class FaceMakePage extends BaseStatefulWidget {
  final String title;
  final int funcId;
  final String imageUrl;
  final String videoUrl;
  FaceMakePage({
    required this.title,
    required this.funcId,
    required this.imageUrl,
    required this.videoUrl,
  });

  @override
  BaseWidgetState<FaceMakePage> getState() => _FaceMakePageState();
}

class _FaceMakePageState extends BaseWidgetState<FaceMakePage> {
  late final _currentZodiac = 0.obs;

  late final _show = false.obs;

  // late final _showHeadImg = true.obs;

  late VideoPlayerController? _controller;

  bool get _isNotEmptyVideoUrl => widget.videoUrl.isNotEmpty;

  late final _myHeadImg = ''.obs;

  void _toHistory() async {
    _controller?.pause();
    await Get.to(() => WorksPage());
    _controller?.play();
  }

  void _showSuccess() async {
    _show.value = true;
    await 3.delay();
    _show.value = false;
  }

  void _showError() async {
    final res = await Get.dialog(
        Material(
          type: MaterialType.transparency,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35.w, right: 35.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            width: 294.w,
                            height: 345.w,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19.w),
                              child: SizedBox(
                                width: 294.w,
                                height: 345.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 26.w),
                                    Center(
                                      child: Text(
                                        '制作失败',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: const Color(0xFF191919),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14.w),
                                    Text(
                                      '1.可能是你的照片不符合该特效的上传要求，请参考上传建议。',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    Text(
                                      '2.可能是你使用的照片违反了国家法律法规（比如明星、政治人物等等...）',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    Text(
                                      'PS：请上传符合要求的照片再试试哦..',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back(result: true);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 357.w,
                                        height: 44.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF2E7E),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "重新上传",
                                            textColor: const Color(0xFFFFFFFF),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.w),
                                    GestureDetector(
                                      onTap: () {
                                        Get.back(result: false);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 357.w,
                                        height: 44.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1.w,
                                              color: const Color(0xFFFF2E7E)),
                                          borderRadius:
                                              BorderRadius.circular(26.w),
                                        ),
                                        child: Center(
                                          child: CommText(
                                            text: "知道了",
                                            textColor: const Color(0xFFFF2E7E),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
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
          ),
        ),
        barrierDismissible: false);
    if (res == true) {}
    _show.value = false;
  }

  void _make() async {
    if (!HandleTool.instance.isMember) {
      Get.to(() => VipPage());
      return;
    }

    if (_myHeadImg.value.isEmpty) {
      final res = await Get.to<String>(() => Photo_listPage(isNew: false));
      if (res?.isNotEmpty == true) {
        _myHeadImg.value = res!;
      }
    }

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
    _show.value = false;
    final params = {
      "funcId": widget.funcId,
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
    // if (!HandleTool.instance.isMember) {
    //   Get.to(() => VipPage());
    //   return;
    // }

    // final res = await Get.to<String>(() => Photo_listPage(isNew: false));

    // Log.e("res:$res");
    // if (res?.isNotEmpty == true) {
    //   _myHeadImg.value = res ?? '';
    //   if (_myHeadImg.isNotEmpty) {
    //     // _showHeadImg.value = true;
    //   }
    //   setState(() {});
    //   return;
    // }

    // _myHeadImg.value = HandleTool.instance.headImg;
  }

  void _closeHeadImg() {
    // _showHeadImg.value = false;
    // _myHeadImg.value = "";
  }

  void _checkImage() {
    // File file = File(_myHeadImg.value);
    // bool isExists = file.existsSync();
    // if (!isExists) {
    //   _showHeadImg.value = false;
    // }
  }

  @override
  void initState() {
    super.initState();
    _checkImage();
    if (_isNotEmptyVideoUrl) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..setLooping(true)
        ..initialize().then((_) {
          // 确保在视频初始化完成后设置播放状态
          setState(() {
            _controller?.play();
          });
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void yCloseInputMethod() {
    _show.value = false;
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        // alignment: Alignment.center,
        children: [
          YAppBar(
            widget: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _toHistory,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "my_work_ic.png".make,
                        width: 22.w,
                        height: 22.w,
                      ),
                      Text(
                        "我的作品",
                        style: TextStyle(
                          color: const Color(0xFF191919),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            isMake: true,
            title: widget.title,
            rightPadding: 16.w,
            right: GestureDetector(
              onTap: _toHistory,
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "my_work_ic.png".make,
                    width: 22.w,
                    height: 22.w,
                  ),
                  Text(
                    "我的作品",
                    style: TextStyle(
                      color: const Color(0xFF191919),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.w),
                child: widget.videoUrl.isEmpty
                    ? LayoutBuilder(builder: (context, boxConstraints) {
                        return Container(
                          // color: Colors.grey,
                          color: Colors.white,
                          width: 1.sw,
                          height: boxConstraints.maxHeight,
                          child: QdsImage(
                            widget.imageUrl,
                            1.sw,
                            boxConstraints.maxHeight,
                          ),
                        );
                      })
                    : _controller != null
                        ? _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : const Center(child: CircularProgressIndicator())
                        : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          Obx(() => Visibility(
                visible: _show.isTrue,
                child: Positioned(
                  left: 0,
                  right: 0,
                  top: ScreenUtil().statusBarHeight,
                  child: Container(
                    height: 118.w,
                    width: 358.w,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 7,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 12.w),
                            Stack(
                              children: [
                                Container(
                                  width: 69.w,
                                  height: 94.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD8D8D8),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.w),
                                    child: QdsImage(
                                      _myHeadImg.value,
                                      69.w,
                                      94.w,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 69.w,
                                  height: 94.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xA3191919),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Center(
                                    child: CommText(
                                      text: "制作中",
                                      textColor: const Color(0xFFFFFFFF),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CommText(
                                      text: "作品正在制作中！",
                                      textColor: const Color(0xff191919),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    // Image.asset(
                                    //   "make_result_success.png".make,
                                    //   width: 26.w,
                                    //   height: 26.w,
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 9.w),
                                CommText(
                                  text: "制作完成即可在我的作品中查看",
                                  textColor: const Color(0xFF818181),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                // Row(
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         _show.value = false;
                                //       },
                                //       behavior: HitTestBehavior.opaque,
                                //       child: Container(
                                //         width: 110.w,
                                //         height: 33.w,
                                //         decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           border: Border.all(
                                //               width: 1.w,
                                //               color: const Color(0xFFFF2E7E)),
                                //           borderRadius:
                                //               BorderRadius.circular(26.w),
                                //         ),
                                //         child: Center(
                                //           child: CommText(
                                //             text: "稍后查看",
                                //             textColor: const Color(0xFFFF2E7E),
                                //             fontSize: 15.sp,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 14.w),
                                //     GestureDetector(
                                //       onTap: () {
                                //         _show.value = false;
                                //         _toHistory();
                                //       },
                                //       behavior: HitTestBehavior.opaque,
                                //       child: Container(
                                //         width: 110.w,
                                //         height: 33.w,
                                //         decoration: BoxDecoration(
                                //           color: const Color(0xFFFF2E7E),
                                //           borderRadius:
                                //               BorderRadius.circular(26.w),
                                //         ),
                                //         child: Center(
                                //           child: CommText(
                                //             text: "立即查看",
                                //             textColor: const Color(0xFFFFFFFF),
                                //             fontSize: 15.sp,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 120.w,
              width: 1.sw,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                children: [
                  // const Spacer(),
                  // Obx(
                  //   () => SizedBox(
                  //     width: 1.sw,
                  //     height: 76.w,
                  //     child: _showHeadImg.isFalse
                  //         ? Center(
                  //             child: GestureDetector(
                  //               onTap: _uploadNewHeadImg,
                  //               behavior: HitTestBehavior.opaque,
                  //               child: Image.asset(
                  //                 "no_head_img.png".make,
                  //                 width: 76.w,
                  //                 height: 76.w,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           )
                  //         : Center(
                  //             child: Stack(
                  //               clipBehavior: Clip.none,
                  //               children: [
                  //                 if (_myHeadImg.isNotEmpty)
                  //                   Stack(
                  //                     alignment: Alignment.center,
                  //                     children: [
                  //                       Container(
                  //                         width: 72.w,
                  //                         height: 72.w,
                  //                         decoration: const BoxDecoration(
                  //                           color: Colors.grey,
                  //                           shape: BoxShape.circle,
                  //                           gradient: LinearGradient(
                  //                             colors: [
                  //                               Color(0xFFFF2EB8),
                  //                               Color(0xFFFF2E2E)
                  //                             ],
                  //                             begin: Alignment
                  //                                 .centerLeft, // 渐变的起始点
                  //                             end: Alignment
                  //                                 .centerRight, // 渐变的结束点
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       ClipOval(
                  //                         child: Image.file(
                  //                           File(_myHeadImg.value),
                  //                           width: 68.w,
                  //                           height: 68.w,
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 else
                  //                   GestureDetector(
                  //                     onTap: _uploadNewHeadImg,
                  //                     behavior: HitTestBehavior.opaque,
                  //                     child: Image.asset(
                  //                       "no_head_img.png".make,
                  //                       width: 76.w,
                  //                       height: 76.w,
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                 Obx(
                  //                   () => Positioned(
                  //                     top: 0,
                  //                     right: 0,
                  //                     child: Visibility(
                  //                       visible: _showHeadImg.isTrue &&
                  //                           HandleTool
                  //                               .instance.headImg.isNotEmpty,
                  //                       child: GestureDetector(
                  //                         onTap: _closeHeadImg,
                  //                         behavior: HitTestBehavior.opaque,
                  //                         child: Image.asset(
                  //                           "make_close.png".make,
                  //                           width: 18.w,
                  //                           height: 18.w,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   bottom: -5.w,
                  //                   right: 0,
                  //                   child: GestureDetector(
                  //                     onTap: _uploadNewHeadImg,
                  //                     behavior: HitTestBehavior.opaque,
                  //                     child: Container(
                  //                       width: 76.w,
                  //                       height: 21.w,
                  //                       decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             BorderRadius.circular(12.w),
                  //                         gradient: const LinearGradient(
                  //                           colors: [
                  //                             Color(0xFFFF2EB8),
                  //                             Color(0xFFFF2E2E)
                  //                           ],
                  //                           begin:
                  //                               Alignment.centerLeft, // 渐变的起始点
                  //                           end:
                  //                               Alignment.centerRight, // 渐变的结束点
                  //                         ),
                  //                       ),
                  //                       child: Center(
                  //                         child: CommText(
                  //                           text: "上传新头像",
                  //                           textColor: const Color(0xFFFFFFFF),
                  //                           fontSize: 12.sp,
                  //                           fontWeight: FontWeight.w500,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //   ),
                  // ),
                  SizedBox(height: 12.w),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      height: 100.w,
                      color: Colors.white,
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
                                color: const Color(0xFFFF2E7E),
                                borderRadius: BorderRadius.circular(26.w),
                              ),
                              child: Center(
                                child: CommText(
                                  text: "一键制作",
                                  textColor: const Color(0xFFFFFFFF),
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
            ),
          )
        ],
      ),
    );
  }
}
