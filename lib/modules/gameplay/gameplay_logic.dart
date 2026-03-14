import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/modules/gameplay/gameplay_state.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

class GameplayLogic extends ZpwBaseGetxController with GetSingleTickerProviderStateMixin {
  final GameplayState state = GameplayState();
  TabController? tabController;
  var listPhotoGroupBean = <ZpwListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ZpwListPhotoGroupBean>[];
  late final isOk = false.obs;
  late final showVip = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void _getData() {
    ZpwHandleTool.instance.QDSGet<ZpwListPhotoGroupBean>(ZpwApi.zpwListPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 1,
          "tabType": 0,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            listPhotoGroupBean = results;
            update();
          }
        },
        onModel: (json) => ZpwListPhotoGroupBean.fromJson(json));
  }

  void _getData2() {
    ZpwHandleTool.instance.QDSGet<ZpwListPhotoGroupBean>(ZpwApi.zpwListPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 0,
          "tabType": 0,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            final bean = results;

            ZpwLog.d("listPhotoGroup.bean----${bean.length}");
            listPhotoGroupBean2 = results;
            tabController = TabController(length: listPhotoGroupBean2.length, vsync: this);
            update();
          }
        },
        onModel: (json) => ZpwListPhotoGroupBean.fromJson(json));
  }

  stateShowVip(bool isVip) {
    showVip.value = isVip;
    update();
  }

  @override
  void onReady() {
    super.onReady();

    _getData();
    _getData2();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
