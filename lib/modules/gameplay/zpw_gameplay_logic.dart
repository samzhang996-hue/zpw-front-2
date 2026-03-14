import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/modules/gameplay/zpw_gameplay_state.dart';
import 'package:zpw/modules/main/model/zpw_user_info_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/network/zpw_network_util.dart';
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

  Future<void> _getData() async {
    final result = await ZpwDioUtils.instance.getAsync<ZpwListPhotoGroupBean>(
      ZpwApi.zpwListPhotoGroup,
      isShowProgress: true,
      params: {
        "groupType": 1,
        "tabType": 0,
      },
      onModel: (json) => ZpwListPhotoGroupBean.fromJson(json),
    );
    if (result.isSuccess && result.hasData) {
      listPhotoGroupBean = result.data;
      update();
    }
  }

  Future<void> _getData2() async {
    final result = await ZpwDioUtils.instance.getAsync<ZpwListPhotoGroupBean>(
      ZpwApi.zpwListPhotoGroup,
      isShowProgress: true,
      params: {
        "groupType": 0,
        "tabType": 0,
      },
      onModel: (json) => ZpwListPhotoGroupBean.fromJson(json),
    );
    if (result.isSuccess && result.hasData) {
      final bean = result.data;
      ZpwLog.d("listPhotoGroup.bean----${bean.length}");
      listPhotoGroupBean2 = result.data;
      tabController = TabController(length: listPhotoGroupBean2.length, vsync: this);
      update();
    }
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
