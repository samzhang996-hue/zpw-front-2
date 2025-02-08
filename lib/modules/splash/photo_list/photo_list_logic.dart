import 'package:zpw/base/base_getx_controller.dart';
import 'package:get/get.dart';
import 'photo_list_state.dart';

class Photo_listLogic extends BaseGetxController {
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
