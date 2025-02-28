import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';

import 'znxc_state.dart';

class ZnxcLogic extends BaseGetxController {
  final ZnxcState state = ZnxcState();


  smartRemove(String img,String mask) async {
    Post(Api.smartRemove, isShowProgress: true, params: {
      "imgUrls": [img],
      "mask": mask
    }, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        // state.path.value=data["returnUrl"];
        Log.d("res---${results.first}");
        update();
      }
    });
  }

}
