import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'face_logic.dart';

class FacePage extends StatelessWidget {
  FacePage({Key? key}) : super(key: key);

  final logic = Get.put(FaceLogic());
  final state = Get.find<FaceLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
