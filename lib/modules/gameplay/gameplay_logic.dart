import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/gameplay/gameplay_state.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class GameplayLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GameplayState state = GameplayState();
  TabController? tabController;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ListPhotoGroupBean>[];
  late final isOk = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void _getData() {
    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.listPhotoGroup,
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
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }

  void _getData2() {
    HandleTool.instance.QDSGet<ListPhotoGroupBean>(Api.listPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 0,
          "tabType": 0,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            final bean = results;

            Log.d("listPhotoGroup.bean----${bean.length}");
            listPhotoGroupBean2 = results;
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

  @override
  void onClose() {
    super.onClose();
  }
}
