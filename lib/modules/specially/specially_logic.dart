import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/zpw_list_photo_group_bean.dart';
import 'package:zpw/modules/specially/specially_state.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class SpeciallyLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SpeciallyState state = SpeciallyState();
  TabController? tabController;
  var listPhotoGroupBean = <ZpwListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ZpwListPhotoGroupBean>[];

  void _getData() {
    ZpwHandleTool.instance.QDSGet<ZpwListPhotoGroupBean>(ZpwApi.zpwListPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 1,
          "tabType": 2,
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
          "tabType": 2,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            listPhotoGroupBean2 = results;
            listPhotoGroupBean2
                .add(ZpwListPhotoGroupBean(zpwId: -1, zpwGroupName: "头像集"));
            tabController =
                TabController(length: listPhotoGroupBean2.length, vsync: this);
            update();
          }
        },
        onModel: (json) => ZpwListPhotoGroupBean.fromJson(json));
  }

  @override
  void onReady() {
    super.onReady();

    _getData();
    _getData2();
  }
}
