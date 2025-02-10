import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';

import 'guide_state.dart';

class GuideLogic extends BaseGetxController {
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
    get("${Api.getFuncDetail}?id=1", isShowProgress: true,
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
        Log.d("fun---$data");
        update();
      }
    });
  }
}
