import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/utils/dowload.dart';
import 'package:zpw/utils/log_utils.dart';
import 'detail_logic.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<DetailPage> getState() => _DetailPageState();
}

class _DetailPageState extends BaseWidgetState<DetailPage> {
  final logic = Get.put(DetailLogic());
  final state = Get.find<DetailLogic>().state;
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

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

    if (worksType == 0) {
      return QdsImage(
        logic.state.returnUrl.value,
        double.infinity,
        double.infinity,
      );
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
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<DetailLogic>(builder: (logic) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YAppBar(
              title: state.tags.value,
              right: InkWell(
                  onTap: () {},
                  child: CommText(
                    text: "再次创作",
                    textColor: ColorPlate.themeColor,
                    fontSize: 13.sp,
                  ))),
          Expanded(child: _buildContent()),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.w, top: 25.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    height: 45.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: ColorPlate.themeColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 85.w,
                        ),
                        Image.asset(
                          "down.png".mine,
                          width: 28.w,
                        ),
                        CommText(
                          text: "下载",
                          textColor: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 85.w,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (state.returnUrl.value.isNotEmpty) {
                      downloadVideoToGallery(state.returnUrl.value);
                    }
                  },
                ),
                SizedBox(
                  width: 8.w,
                ),
                InkWell(
                  onTap: () {
                    logic.delete();
                  },
                  child: Container(
                    height: 45.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: Color(0xffFFF1F6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24.w,
                        ),
                        Image.asset(
                          "lj.png".mine,
                          width: 28.w,
                        ),
                        CommText(
                          text: "删除",
                          textColor: Color(0xffFF0707),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
