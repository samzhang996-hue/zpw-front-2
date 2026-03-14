import 'package:flutter/material.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_permission.dart';
import 'zpw_photo_list_state.dart';
import 'package:permission_handler/permission_handler.dart';

class Photo_listLogic extends ZpwBaseGetxController {
  final Photo_listState state = Photo_listState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.type = map["type"] ?? 0;
      update();
    }
  }
}
