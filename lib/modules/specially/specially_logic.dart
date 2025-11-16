import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/specially/specially_state.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SpeciallyLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SpeciallyState state = SpeciallyState();
  TabController? tabController;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ListPhotoGroupBean>[];

  Future<void> _getData() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.listPhotoGroup,
        queryParameters: {
          "groupType": 1,
          "tabType": 2,
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
          "tabType": 2,
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => ListPhotoGroupBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          listPhotoGroupBean2 = results;
          listPhotoGroupBean2
              .add(ListPhotoGroupBean(id: -1, groupName: "头像集"));
          tabController =
              TabController(length: listPhotoGroupBean2.length, vsync: this);
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();

    _getData();
    _getData2();
  }
}
