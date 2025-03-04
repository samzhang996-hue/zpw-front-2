import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/detail/report_view.dart';
import 'package:zpw/modules/mine/view/custom_del_dialog_utils.dart';
import 'package:zpw/utils/dowload.dart';
import 'package:zpw/utils/log_utils.dart';

import 'detail_logic.dart';

class DetailPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<DetailPage> getState() => _DetailPageState();
}

class _DetailPageState extends BaseWidgetState<DetailPage> {
  final logic = Get.put(DetailLogic());
  final state = Get.find<DetailLogic>().state;
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  late final _showMoreAction = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    Get.delete<DetailPage>();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    String videoUrl = logic.state.returnUrl.value;
    _controller = VideoPlayerController.network(videoUrl)..setLooping(true);
    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
        if (state.worksType.value == 1) {
          _controller.play();
        }
      });
    } catch (error) {
      Log.d('Error initializing video player: $error');
    }
  }

  Widget _buildContent() {
    int worksType = logic.state.worksType.value;
    int apiType = logic.state.apiType.value;
    Log.d("type----$worksType");
    Log.d("type----${logic.state.returnUrl.value}");

    if (worksType == 0) {
      if (apiType == -1) {
        return Align(
          child: QdsImage(
              logic.state.returnUrl.value,
              // "https://imgeffect.obs.cn-north-1.myhuaweicloud.com:443/photo%2F%2Fcfd0918d-89fe-49fa-ac4b-8d571f55ee8e.png",
              double.infinity,
              358.w,
              fit: BoxFit.contain),
          alignment: Alignment.center,
        );
      } else {
        return Expanded(
            child: Container(
          child: QdsImage(
              logic.state.returnUrl.value,
              // "https://imgeffect.obs.cn-north-1.myhuaweicloud.com:443/photo%2F%2Fcfd0918d-89fe-49fa-ac4b-8d571f55ee8e.png",
              double.infinity,
              double.infinity,
              fit: BoxFit.contain),
        ));
      }
    } else if (worksType == 1) {
      return _isVideoInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Center(child: CircularProgressIndicator());
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  void yCloseInputMethod() {
    _showMoreAction.value = false;
    super.yCloseInputMethod();
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<DetailLogic>(builder: (logic) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(child: _buildContent()),
                  _buildContent(),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90.w,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          height: 45.w,
                          width: 202.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width: 85.w,
                              // ),
                              Image.asset(
                                "down.png".mine,
                                width: 28.w,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              CommText(
                                text: "下载",
                                textColor: Color(0xff191919),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              // SizedBox(
                              //   width: 85.w,
                              // ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _showMoreAction.value = false;
                          if (state.returnUrl.value.isNotEmpty) {
                            downloadAndSaveMedia(
                                state.returnUrl.value, (res) {});
                          }
                        },
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Visibility(
                        visible: (state.apiType.value == -1 ||
                                state.apiType.value == 6 ||
                                state.apiType.value == 14)
                            ? false
                            : true,
                        child: InkWell(
                          onTap: () {
                            _showMoreAction.value = false;
                            if (state.apiType.value == -1 ||
                                state.apiType.value == 6 ||
                                state.apiType.value == 14) return;
                            _controller.pause();
                            Log.d("pause---${state.returnUrl.value}----");
                            logic.getFuncDetail(state.funcId.value);
                          },
                          child: Container(
                            height: 45.w,
                            width: 146.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.w,
                                    color: const Color(0xff191919)
                                        .withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 24.w,
                                // ),
                                Image.asset(
                                  "zccz.png".mine,
                                  width: 28.w,
                                ),
                                CommText(
                                  text: "再次创作",
                                  textColor: Color(0xff191919),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                // SizedBox(
                                //   width: 24.w,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: YAppBar(
                    title: state.tags.value,
                    right: InkWell(
                      onTap: () {
                        _showMoreAction.value = true;
                        // if (state.apiType.value == -1 ||
                        //     state.apiType.value == 6 ||
                        //     state.apiType.value == 14) return;
                        // _controller.pause();
                        // Log.d("pause---${state.returnUrl.value}----");
                        // logic.getFuncDetail(state.funcId.value);
                        // // Get.to(
                        // //   () => FaceMakePage(
                        // //     title: state.tags.value,
                        // //     funcId: state.id.value,
                        // //     imageUrl: "",
                        // //     videoUrl: state.returnUrl.value,
                        // //   ),
                        // // );
                      },
                      child: Image.asset(
                        "jubao_more.png".mine,
                        width: 38.w,
                        height: 38.w,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Positioned(
                top: ScreenUtil().statusBarHeight + 40.w,
                left: 0,
                right: 16.w,
                child: Obx(() => Visibility(
                      visible: _showMoreAction.isTrue,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 97.w,
                          height: 99.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14.w),
                                  bottomLeft: Radius.circular(14.w),
                                  bottomRight: Radius.circular(14.w)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x14000000),
                                    offset: Offset(0, 3),
                                    spreadRadius: 0,
                                    blurRadius: 10)
                              ]),
                          child: Column(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  _showMoreAction.value = false;
                                  CustomDelDialogUtils.showCustomDialog(
                                      context: context,
                                      onPressed: () {
                                        logic.delete();
                                      });
                                },
                                child: CommText(
                                  text: "删除",
                                  textColor: const Color(0xFF1A1A1A),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 64.w,
                                height: 1.w,
                                color: const Color(0x33979797),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  _showMoreAction.value = false;
                                  Get.to(() => ReportView());
                                },
                                child: CommText(
                                  text: "举报",
                                  textColor: const Color(0xFF1A1A1A),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    )),
              )
            ],
          )));
    });
  }
}
