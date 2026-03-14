import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

class ZpwCommHeadCircle extends StatelessWidget {
  final double width;
  const ZpwCommHeadCircle({super.key, this.width = 68});

  Future<String?> _loadImage() async {
    return Future.value(ZpwSpUtils.getString("my_ai_head"));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadImage(), // 调用加载图片的Future
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 如果数据还在加载，显示加载指示器
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 如果加载图片时发生错误，显示错误信息
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          // 如果有数据（即图片文件），显示图片
          return ClipOval(
            child: Image.file(
              File(
                snapshot.data ?? '',
              ),
              width: width.w,
              height: width.w,
              fit: BoxFit.cover,
            ),
          );
        } else {
          // 如果没有找到图片，显示提示信息
          return const SizedBox.shrink();
        }
      },
    );
  }
}