import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // /// 存储权限
  static Future<bool> checkFilesAccessPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        await Permission.photos.request();
        var status2 = await Permission.photos.status;
        return status2.isGranted;
      }
      return false;
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool storagePermission = await Permission.storage.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    String release = androidInfo.version.release;

    if (release.isNotEmpty) {
      List<String> releaseList = release.split('.');
      int firstValue = int.parse(releaseList.first);
      if (firstValue < 10) {
        manageExternal = true;
      }
    }

    if (!storagePermission) {
      storagePermission = await Permission.storage.request().isGranted;
    }

    if (!manageExternal) {
      manageExternal =
          await Permission.manageExternalStorage.request().isGranted;
    }

    bool isPermissionGranted = storagePermission && manageExternal;

    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }

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
}
