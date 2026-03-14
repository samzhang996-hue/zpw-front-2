import 'dart:io';

import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'wf_state.dart';

class WfZpwLogic extends ZpwBaseGetxController {
  final WfState state = WfState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    final result = await getAsync<ZpwListPhotoGroupBean>(
      ZpwApi.zpwListPhotoGroup,
      isShowProgress: true,
      params: {
        "groupType": 2,
      },
      onModel: (json) => ZpwListPhotoGroupBean.fromJson(json),
    );

    if (result.isSuccess && result.hasData) {
      if (Platform.isIOS) {
        state.listPhotoGroupBean = result.data.where((item) => item.frontType != 'SJHF').toList();
      } else {
        state.listPhotoGroupBean = result.data;
      }
      ZpwLog.d("list----${state.listPhotoGroupBean[1].toJson()}");
      update();
    }
  }
}
