import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'guide_state.dart';

class GuideLogic extends ZpwBaseGetxController {
  final GuideState state = GuideState();
  VideoPlayerController? videoPlayerController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFuncDetail();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    CustomPhotoDialogUtils.showCustomDialog(
        context: navigator!.context, onPressed: () {});
  }

  getFuncDetail() {
    get("${ZpwApi.zpwGetFuncDetail}?id=1", isShowProgress: true,
        success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.showImgGif = data["showImgGif"];
        state.videoUrl = data["videoUrl"];
        if (state.videoUrl.isNotEmpty) {
          videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(state.videoUrl))
                ..setLooping(true)
                ..initialize().then((_) {
                  // 确保在视频初始化完成后设置播放状态
                  videoPlayerController?.play();
                  update();
                });
        }
        state.funcName = data["tags"] ?? "";
        ZpwLog.d("fun---$data");
        update();
      }
    });
  }
}
