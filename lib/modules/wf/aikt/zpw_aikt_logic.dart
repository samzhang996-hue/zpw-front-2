import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/model/zpw_upload_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:dio/src/form_data.dart' as ffff;
import 'package:dio/src/multipart_file.dart' as ffff;
import 'zpw_aikt_state.dart';

class ZpwAiktLogic extends ZpwBaseGetxController {
  final ZpwAiktState state = ZpwAiktState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.path.value = map["path"] ?? "";
      ZpwLog.d("path---${state.path.value}");
      update();
    }
  }



  Future<void> outPaint(double outPaintRatio) async {
    final formData = ffff.FormData.fromMap({
      "file": await ffff.MultipartFile.fromFile(state.path.value),
    });
    final bean = await ZpwHandleTool.instance.QDSUpload<ZpwUploadBean>(
        ZpwApi.zpwUploadFile,
        params: formData,
        onModel: (v) => ZpwUploadBean.fromJson(v));
    if (bean == null) {
      ZpwHandleTool.showAppToastText("扩图失败,请重试");
      return;
    }

    final result = await postAsync(ZpwApi.zpwOutPaint, isShowProgress: true, params: {
      "imgUrls": [bean.url],
      "outPaintRatio": outPaintRatio
    });
    if (result.isSuccess && result.hasData) {
      state.text.value = "保存图片";
      Map data = result.first;
      state.path.value = data["returnUrl"];
      ZpwLog.d("res---${data["returnUrl"]}");
      update();
    }
  }
}
