import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mine_logic.dart';

class MinePage extends StatelessWidget {
  MinePage({Key? key}) : super(key: key);

  final logic = Get.put(MineLogic());
  final state = Get.find<MineLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
