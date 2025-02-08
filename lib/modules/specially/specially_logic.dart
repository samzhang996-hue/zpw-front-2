import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/specially/specially_state.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';

class SpeciallyLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SpeciallyState state = SpeciallyState();
  TabController? tabController;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ListPhotoGroupBean>[];

  void _getData() {
    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.listPhotoGroup,
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
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }

  void _getData2() {
    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.listPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 0,
          "tabType": 2,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            listPhotoGroupBean2 = results;
            listPhotoGroupBean2
                .add(ListPhotoGroupBean(id: -1, groupName: "头像集"));
            tabController =
                TabController(length: listPhotoGroupBean2.length, vsync: this);
            update();
          }
        },
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }

  @override
  void onReady() {
    super.onReady();

    _getData();
    _getData2();
  }
}
