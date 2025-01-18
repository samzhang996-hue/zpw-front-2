import 'package:get/get.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';

import 'guide_state.dart';

class GuideLogic extends GetxController {
  final GuideState state = GuideState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    CustomPhotoDialogUtils.showCustomDialog(context: navigator!.context, onPressed: (){});
  }
}
