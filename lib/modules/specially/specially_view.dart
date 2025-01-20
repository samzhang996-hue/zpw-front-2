import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/specially/make_page.dart';

import 'specially_logic.dart';

class SpeciallyPage extends StatelessWidget {
  SpeciallyPage({Key? key}) : super(key: key);

  final logic = Get.put(SpeciallyLogic());
  final state = Get.find<SpeciallyLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: TextButton(
                onPressed: () {
                  Get.to(() => MakePage());
                },
                child: Text("天马行空")))
      ],
    );
  }
}
