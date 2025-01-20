import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/face/face_make_page.dart';

import 'face_logic.dart';

class FacePage extends StatelessWidget {
  FacePage({Key? key}) : super(key: key);

  final logic = Get.put(FaceLogic());
  final state = Get.find<FaceLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: TextButton(
                onPressed: () {
                  Get.to(() => FaceMakePage());
                },
                child: Text("千种风情人生")))
      ],
    );
  }
}
