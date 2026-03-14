import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

typedef ZpwDownloadCallback = void Function(bool success);
Future<void> zpwDownloadAndSaveMedia(
    String videoUrl, ZpwDownloadCallback callback) async {
  try {
    ZpwLog.d("video----$videoUrl");
    String zpwEndStr = "temp_video.mp4";
    bool zpwIsMp4 = true;
    if (videoUrl.toLowerCase().endsWith('.mp4')) {
      zpwEndStr = "temp_video.mp4";
      zpwIsMp4 = true;
    } else {
      zpwEndStr = "temp_photo.png";
      zpwIsMp4 = false;
    }
    // 获取临时目录路径
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$zpwEndStr';
    ZpwLog.d("path---$tempPath");
    EasyLoading.show();
    // 使用 Dio 下载文件
    Dio dio = Dio();
    await dio.download(videoUrl, tempPath);
    // 将视频保存到相册
    bool? result;
    if (zpwIsMp4) {
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
      ZpwHandleTool.showAppToastText("已下载到相册");
      callback(true);
    } else {
      ZpwHandleTool.showAppToastText("保存失败");
      callback(false);
    }
    EasyLoading.dismiss();

    // 删除临时文件
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  } catch (e) {
    ZpwHandleTool.showAppToastText("下载或保存时出错: $e");
  }
}

// 兼容旧函数名
typedef DownloadCallback = void Function(bool success);
Future<void> downloadAndSaveMedia(String videoUrl, DownloadCallback callback) =>
    zpwDownloadAndSaveMedia(videoUrl, callback);