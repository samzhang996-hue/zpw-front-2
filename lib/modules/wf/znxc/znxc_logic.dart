import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'znxc_state.dart';

class ZnxcLogic extends ZpwBaseGetxController {
  final ZnxcState state = ZnxcState();


  smartRemove(String img,String mask) async {
    Post(ZpwApi.zpwSmartRemove, isShowProgress: true, params: {
      "imgUrls": [img],
      "mask": mask
    }, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        // state.path.value=data["returnUrl"];
        ZpwLog.d("res---${results.first}");
        update();
      }
    });
  }

}
