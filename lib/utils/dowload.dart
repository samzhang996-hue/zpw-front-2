import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/log_utils.dart';
Future<void> downloadAndSaveMedia(String videoUrl) async {
  try {
    Log.d("video----$videoUrl");
    String endStr="temp_video.mp4";
    bool isMp4=true;
    if(videoUrl.toLowerCase().endsWith('.mp4')){
      endStr="temp_video.mp4";
      isMp4=true;
    }else{
      endStr="temp_photo.png";
      isMp4=false;
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
    if(isMp4){
      result = await GallerySaver.saveVideo(tempPath);
    }else{
      result = await GallerySaver.saveImage(tempPath);
    }
    if (result == true) {
      HandleTool.showAppToastText("已下载到相册");
    } else {
      HandleTool.showAppToastText("保存失败");
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
