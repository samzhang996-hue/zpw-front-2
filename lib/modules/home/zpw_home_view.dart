import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';

import 'zpw_home_logic.dart';

class ZpwHomePage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwBaseStatefulWidget> getState() => _ZpwHomePageState();
}

class _ZpwHomePageState extends ZpwBaseWidgetState {
  final zpwLogic = Get.put(ZpwHomeLogic());
  final zpwState = Get.find<ZpwHomeLogic>().zpwState;

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Container();
  }
}