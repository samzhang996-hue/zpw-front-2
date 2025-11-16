import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/modules/gameplay/gameplay_state.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/log_utils.dart';

import '../main/main_logic.dart';
import '../splash/photo_list/photo_list_view.dart';
import 'home_detail.dart';

class HomeLogic extends BaseGetxController with GetSingleTickerProviderStateMixin {
  final GameplayState state = GameplayState();
  late final mainLogic = Get.find<MainLogic>();
  TabController? tabController;
  var listPhotoGroupBean = <ListPhotoGroupBean>[];
  var listPhotoGroupBean2 = <ListPhotoGroupBean>[];
  late final isOk = false.obs;

  late final list = ["全部", "视频", "图片", "特效"];
  late RxInt currentIndex = 0.obs;
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
          final bean = results;

          // listPhotoGroupBean2 = results;
          listPhotoGroupBean2 = [];
          final chatListPhotoGroupBean = ListPhotoGroupBean(groupName: "Ai对话");
          listPhotoGroupBean2.add(chatListPhotoGroupBean);
          listPhotoGroupBean2.addAll(results);
          tabController = TabController(length: list.length, vsync: this);
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  void bannerClick(int index) {
    if (index == 0) {
      Get.to(HomeDetail(title: '换发型', id: 28), transition: Transition.rightToLeft);
    }
    if (index == 1) {
      Get.to(Photo_listPage(isNew: false), transition: Transition.rightToLeft, arguments: {"type": 1});
    }
  }

  @override
  void onReady() {
    super.onReady();
    // tabController = TabController(length: list.length, vsync: this);
    // update();
    _getData();
    _getData2();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
