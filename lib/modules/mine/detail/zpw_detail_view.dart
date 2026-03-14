import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_qds_image.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/modules/mine/detail/zpw_report_view.dart';
import 'package:zpw/modules/mine/view/zpw_custom_del_dialog_utils.dart';
import 'package:zpw/utils/zpw_dowload.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'zpw_detail_logic.dart';

class DetailPage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<DetailPage> getState() => _DetailPageState();
}

class _DetailPageState extends ZpwBaseWidgetState<DetailPage> {
  final logic = Get.put(DetailZpwLogic());
  final state = Get.find<DetailZpwLogic>().state;
  BetterPlayerController? _betterPlayerController;
  bool _isVideoInitialized = false;

  late final _showMoreAction = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    Get.delete<DetailPage>();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    String videoUrl = logic.state.returnUrl.value;

    final betterPlayerDataSource = BetterPlayerDataSource.network(
      videoUrl,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
          enablePlayPause: false,
          enableMute: false,
          enableProgressBar: false,
          enableSkips: false,
          enableOverflowMenu: false,
          enableFullscreen: false,
        ),
        errorBuilder: (context, errorMessage) {
          ZpwLog.e("Video error: $errorMessage");
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() {
          _isVideoInitialized = true;
          if (state.worksType.value == 1) {
            _betterPlayerController?.play();
          }
        });
      }
    });
  }

  Widget _buildContent() {
    int worksType = logic.state.worksType.value;
    int apiType = logic.state.apiType.value;
    ZpwLog.d("type----$worksType");
    ZpwLog.d("type----${logic.state.returnUrl.value}");

    if (worksType == 0) {
      if (apiType == -1) {
        return Align(
          child: ZpwQdsImage(
              logic.state.returnUrl.value,
              double.infinity,
              358.w,
              fit: BoxFit.contain),
          alignment: Alignment.center,
        );
      } else {
        return Expanded(
            child: Container(
          child: ZpwQdsImage(
              logic.state.returnUrl.value,
              double.infinity,
              double.infinity,
              fit: BoxFit.contain),
        ));
      }
    } else if (worksType == 1) {
      return _isVideoInitialized && _betterPlayerController != null
          ? Expanded(child: BetterPlayer(controller: _betterPlayerController!))
          : Center(child: CircularProgressIndicator());
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  void zpwYCloseInputMethod() {
    _showMoreAction.value = false;
    super.zpwYCloseInputMethod();
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return GetBuilder<DetailZpwLogic>(builder: (logic) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                              Image.asset(
                                "zpw_down.png".mine,
                                width: 28.w,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              ZpwCommText(
                                text: "下载",
                                textColor: Color(0xff191919),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
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
                            _betterPlayerController?.pause();
                            ZpwLog.d("pause---${state.returnUrl.value}----");
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
                                Image.asset(
                                  "zpw_zccz.png".mine,
                                  width: 28.w,
                                ),
                                ZpwCommText(
                                  text: "再次创作",
                                  textColor: Color(0xff191919),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
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
                child: zpwYAppBar(
                    title: state.tags.value,
                    right: InkWell(
                      onTap: () {
                        _showMoreAction.value = true;
                      },
                      child: Image.asset(
                        "zpw_jubao_more.png".mine,
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
                                child: ZpwCommText(
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
                                child: ZpwCommText(
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