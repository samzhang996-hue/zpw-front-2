import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'znxc_state.dart';

class ZnxcLogic extends ZpwBaseGetxController {
  final ZnxcState state = ZnxcState();


  smartRemove(String img, String mask) async {
    final result = await postAsync(ZpwApi.zpwSmartRemove, isShowProgress: true, params: {
      "imgUrls": [img],
      "mask": mask
    });
    if (result.isSuccess && result.hasData) {
      Map data = result.first as Map;
      // state.path.value=data["returnUrl"];
      ZpwLog.d("res---${result.first}");
      update();
    }
  }

}
