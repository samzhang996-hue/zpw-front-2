import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/gameplay/gameplay_state.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/log_utils.dart';

class GameplayLogic extends BaseGetxController with GetSingleTickerProviderStateMixin {
  final GameplayState state = GameplayState();
  TabController? tabController;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ListPhotoGroupBean>[];
  late final isOk = false.obs;
  late final showVip = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _getData() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.listPhotoGroup,
        queryParameters: {
          "groupType": 1,
          "tabType": 0,
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => ListPhotoGroupBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          listPhotoGroupBean = results;
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> _getData2() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.listPhotoGroup,
        queryParameters: {
          "groupType": 0,
          "tabType": 0,
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => ListPhotoGroupBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          final bean = results;

          listPhotoGroupBean2 = results;
          tabController = TabController(length: listPhotoGroupBean2.length, vsync: this);
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
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
