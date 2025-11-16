import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
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

  Future<void> getFuncDetail() async {
    try {
      final response = await HttpClient().get(
        "${ApiConfig.getFuncDetail}?id=1",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          Map data = dataList.first as Map;
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
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
