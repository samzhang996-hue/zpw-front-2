import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

typedef DownloadCallback = void Function(bool success);
Future<void> downloadAndSaveMedia(
    String videoUrl, DownloadCallback callback) async {
  try {
    String endStr = "temp_video.mp4";
    bool isMp4 = true;
    if (videoUrl.toLowerCase().endsWith('.mp4')) {
      endStr = "temp_video.mp4";
      isMp4 = true;
    } else {
      endStr = "temp_photo.png";
      isMp4 = false;
    }
    // 获取临时目录路径
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$endStr';
    EasyLoading.show();
    // 使用 Dio 下载文件
    Dio dio = Dio();
    await dio.download(videoUrl, tempPath);
    // 将视频保存到相册
    bool? result;
    if (isMp4) {
      result = await GallerySaver.saveVideo(
        tempPath,
        albumName: 'MyAlbum', // 可选：保存到指定相册
        toDcim: true, // 可选：保存到 DCIM 文件夹
      );
    } else {
      result = await GallerySaver.saveImage(
        tempPath,
        albumName: 'MyAlbum', // 可选：保存到指定相册
        toDcim: true, // 可选：保存到 DCIM 文件夹
      );
    }
    if (result == true) {
      HandleTool.showAppToastText("已下载到相册");
      callback(true);
    } else {
      HandleTool.showAppToastText("保存失败");
      callback(false);
    }
    EasyLoading.dismiss();

    // 删除临时文件
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  } catch (e) {
    HandleTool.showAppToastText("下载或保存时出错: $e");
  }
}
