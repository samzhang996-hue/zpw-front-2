import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'face_state.dart';

class FaceLogic extends GetxController {
  final FaceState state = FaceState();

  ScrollController? scrollController;
  final isAppBArPinned = false.obs; //判断APPbar是否吸顶
  double kExpandedHeight = 240.w;
  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_onScroll);

    super.onInit();
  }

  void _onScroll() {
    if (scrollController!.hasClients &&
        scrollController!.offset > kExpandedHeight - kToolbarHeight) {
      isAppBArPinned.value = true;
    } else {
      isAppBArPinned.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController!.dispose();
  }
}
