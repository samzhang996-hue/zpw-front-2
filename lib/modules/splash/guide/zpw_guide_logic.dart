import 'package:better_player_plus/better_player_plus.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/splash/guide/view/zpw_custom_photo_dialog_utils.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'zpw_guide_state.dart';

class ZpwGuideLogic extends ZpwBaseGetxController {
  final ZpwGuideState state = ZpwGuideState();
  BetterPlayerController? betterPlayerController;

  @override
  void onInit() {
    super.onInit();
    getFuncDetail();
  }

  @override
  void onClose() {
    betterPlayerController?.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    ZpwCustomPhotoDialogUtils.showCustomDialog(
        context: navigator!.context, onPressed: () {});
  }

  Future<void> getFuncDetail() async {
    final result = await getAsync<Map<String, dynamic>>(
      "${ZpwApi.zpwGetFuncDetail}?id=1",
      isShowProgress: true,
    );
    if (result.isSuccess && result.hasData) {
      final data = result.first!;
      state.showImgGif = data["showImgGif"];
      state.videoUrl = data["videoUrl"];
      if (state.videoUrl.isNotEmpty) {
        final betterPlayerDataSource = BetterPlayerDataSource.network(
          state.videoUrl,
          notificationConfiguration: BetterPlayerNotificationConfiguration(
            showNotification: false,
          ),
        );

        betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: true,
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
          ),
          betterPlayerDataSource: betterPlayerDataSource,
        );

        betterPlayerController?.addEventsListener((event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
            update();
          }
        });
      }
      state.funcName = data["tags"] ?? "";
      ZpwLog.d("fun---$data");
      update();
    }
  }
}