import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/model/upload_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:dio/src/form_data.dart' as ffff;
import 'package:dio/src/multipart_file.dart' as ffff;
import 'aikt_state.dart';

class AiktLogic extends BaseGetxController {
  final AiktState state = AiktState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.path.value = map["path"] ?? "";
      Log.d("path---${state.path.value}");
      update();
    }
  }



  Future<void> outPaint(double outPaintRatio) async {
    final formData = ffff.FormData.fromMap({
      "file": await ffff.MultipartFile.fromFile(state.path.value),
    });
    final bean = await HandleTool.instance.QDSUpload<UploadBean>(
        Api.uploadFile,
        params: formData,
        onModel: (v) => UploadBean.fromJson(v));
    if (bean == null) {
      HandleTool.showAppToastText("扩图失败,请重试");
      return;
    }

    Post(Api.outPaint, isShowProgress: true, params: {
      "imgUrls": [bean.url],
      "outPaintRatio": outPaintRatio
    }, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        state.text.value="保存图片";
        Map data = results.first as Map;
        state.path.value=data["returnUrl"];
        Log.d("res---${data["returnUrl"]}");
        update();
      }
    });
  }
}
