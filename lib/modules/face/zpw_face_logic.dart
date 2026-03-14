import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/network/zpw_network_util.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'face_state.dart';

class FaceLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final FaceState state = FaceState();
  TabController? tabController;
  var listPhotoGroupBean = <ZpwListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ZpwListPhotoGroupBean>[];

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
        "tabType": 1,
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
        "tabType": 1,
      },
      onModel: (json) => ZpwListPhotoGroupBean.fromJson(json),
    );
    if (result.isSuccess && result.hasData) {
      final bean = result.data;
      ZpwLog.d("listPhotoGroup.bean----${bean.length}");
      listPhotoGroupBean2 = result.data;
      tabController =
          TabController(length: listPhotoGroupBean2.length, vsync: this);
      update();
    }
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
