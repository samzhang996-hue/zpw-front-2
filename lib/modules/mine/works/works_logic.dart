import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';

import 'works_state.dart';

class WorksLogic extends BaseGetxController {
  final WorksState state = WorksState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    photoRecord(1);
  }

  photoRecord(int type) {
    Map<String, dynamic> dataMap = {
      "pageIndex": 1,
      "pageSize": 100,
      "worksType": type,
    };
    Get(Api.photoRecord, isShowProgress: true, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {}
    });
  }
}
