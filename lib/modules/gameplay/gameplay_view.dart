import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gameplay_logic.dart';

class GameplayPage extends StatelessWidget {
  GameplayPage({Key? key}) : super(key: key);

  final logic = Get.put(GameplayLogic());
  final state = Get.find<GameplayLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
