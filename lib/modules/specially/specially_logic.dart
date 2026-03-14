import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/modules/specially/specially_state.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/network/zpw_network_util.dart';

class SpeciallyLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SpeciallyState state = SpeciallyState();
  TabController? tabController;
  var listPhotoGroupBean = <ZpwListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ZpwListPhotoGroupBean>[];

  Future<void> _getData() async {
    final result = await ZpwDioUtils.instance.getAsync<ZpwListPhotoGroupBean>(
      ZpwApi.zpwListPhotoGroup,
      isShowProgress: true,
      params: {
        "groupType": 1,
        "tabType": 2,
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
        "tabType": 2,
      },
      onModel: (json) => ZpwListPhotoGroupBean.fromJson(json),
    );
    if (result.isSuccess && result.hasData) {
      listPhotoGroupBean2 = result.data;
      listPhotoGroupBean2
          .add(ZpwListPhotoGroupBean(zpwId: -1, zpwGroupName: "头像集"));
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
}
