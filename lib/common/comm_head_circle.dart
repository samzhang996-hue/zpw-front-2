import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CommHeadCircle extends StatelessWidget {
  const CommHeadCircle({super.key});

  Future<File?> _loadImage() async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/your_image.jpg';
    final imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      return imageFile; // 返回图片文件
    } else {
      return null; // 如果文件不存在，返回null
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _loadImage(), // 调用加载图片的Future
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 如果数据还在加载，显示加载指示器
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 如果加载图片时发生错误，显示错误信息
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          // 如果有数据（即图片文件），显示图片
          return Image.file(snapshot.data!);
        } else {
          // 如果没有找到图片，显示提示信息
          return const SizedBox.shrink();
        }
      },
    );
  }
}
