import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PermissionUtils {
  /// 检查并请求文件访问权限
  static Future<bool> checkFilesAccessPermission() async {
    if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        showTopSnackbar();
        status = await Permission.photos.request();
        return status.isGranted;
      }
      return false;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool storagePermission = await Permission.storage.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;
    String release = androidInfo.version.release;
    Log.d("relse----$release");
    if (release.isNotEmpty) {
      List<String> releaseList = release.split('.');
      int firstValue = int.parse(releaseList.first);
      if (firstValue < 10) {
        manageExternal = true;
      }
    }
    if (!storagePermission || !manageExternal) {
      showTopSnackbar();
      if (!storagePermission) {
        storagePermission = await Permission.storage.request().isGranted;
        if(storagePermission) Get.back();
      }
      if (!manageExternal) {
        manageExternal = await Permission.manageExternalStorage.request().isGranted;
      }
    }

    return storagePermission && manageExternal;
  }

  /// 显示权限提示弹窗
  static void showTopSnackbar() {
    Get.rawSnackbar(
      title: '相机、相册权限使用说明',
      message: 'AI照片王正在向您获取“相机”权限，同意后，将用于为您提供拍照、图片编辑、美化、保存服务。',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      titleText: Text(
        '相机、相册权限使用说明',
        style: TextStyle(
          color: Color(0xff191919),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      messageText: Text(
        'AI照片王正在向您获取“相机”权限，同意后，将用于为您提供拍照、图片编辑、美化、保存服务。',
        style: TextStyle(
          color: Color(0xff818181),
          fontSize: 14,
        ),
      ),
      duration: null, // 设置为 null，弹窗不会自动关闭
    );
  }
}

// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:zpw/utils/log_utils.dart';
// class PermissionUtils {
//   // /// 存储权限
//   static Future<bool> checkFilesAccessPermission() async {
//     if (Platform.isIOS) {
//       PermissionStatus status = await Permission.photos.request();
//       if (status.isGranted) {
//         return true;
//       } else if (status.isLimited) {
//         return false;
//       }
//       return false;
//     }
//
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     bool storagePermission = await Permission.storage.isGranted;
//     bool manageExternal = await Permission.manageExternalStorage.isGranted;
//
//     String release = androidInfo.version.release;
//     Log.d("relse----$release");
//     if (release.isNotEmpty) {
//       List<String> releaseList = release.split('.');
//       int firstValue = int.parse(releaseList.first);
//       if (firstValue < 10) {
//         manageExternal = true;
//       }
//     }
//
//     if (!storagePermission) {
//       storagePermission = await Permission.storage.request().isGranted;
//     }
//
//     if (!manageExternal) {
//       manageExternal = await Permission.manageExternalStorage.request().isGranted;
//     }
//
//     bool isPermissionGranted = storagePermission && manageExternal;
//
//     if (isPermissionGranted) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
// static Future<bool> checkFilesAccessPermission() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   Permission permission;
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     if ((int.tryParse(androidInfo.version.release) ?? 0) < 13) {
//       permission = Permission.storage;
//     } else {
//       permission = Permission.manageExternalStorage;
//     }
//   } else {
//     permission = Permission.storage;
//   }
//   var storageStatus = await permission.status;
//   if (storageStatus != PermissionStatus.granted) {
//     storageStatus = await permission.request();
//     if (storageStatus != PermissionStatus.granted) {
//       return false;
//     }
//   }
//   return true;
// }
