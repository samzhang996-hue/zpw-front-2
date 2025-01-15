import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';

import 'home_logic.dart';

class HomePage extends BaseStatefulWidget {
  @override
  BaseWidgetState<BaseStatefulWidget> getState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState {
  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container();
  }
}
