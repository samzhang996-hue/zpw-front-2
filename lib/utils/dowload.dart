import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
Future<void> downloadVideoToGallery(String videoUrl) async {
  try {
    // 获取临时目录路径
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/temp_video.mp4';
    EasyLoading.show();
    // 使用 Dio 下载文件
    Dio dio = Dio();
    await dio.download(videoUrl, tempPath);
    // 将视频保存到相册
    bool? result = await GallerySaver.saveVideo(tempPath);
    if (result == true) {
      HandleTool.showAppToastText("视频已下载到相册");
    } else {
      HandleTool.showAppToastText("保存视频失败");
    }
    EasyLoading.dismiss();

    // 删除临时文件
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  } catch (e) {
    HandleTool.showAppToastText("下载或保存视频时出错: $e");
  }
}
