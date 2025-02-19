import 'package:flutter/material.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/permission.dart';
import 'photo_list_state.dart';
import 'package:permission_handler/permission_handler.dart';

class Photo_listLogic extends BaseGetxController {
  final Photo_listState state = Photo_listState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.type = map["type"] ?? 0;
      update();
    }
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    // Log.d("per---123132");
    // final res= await PermissionUtils.checkFilesAccessPermission();
    // Log.d("per----$res");
    // if (res) {
    //   showTopSnackbar();
    // }
    // if(!state.isPermission.value){
    //   showTopSnackbar();
    // }
  }

  void showTopSnackbar() {
    Get.rawSnackbar(
      title: '相机、相册权限使用说明',
      message: 'AI照片王正在向您获取“相机”权限，同意后，将用于为您提供拍照、图片编辑、美化、保存服务。',
      snackPosition: SnackPosition.TOP,
      // 弹窗显示在顶部
      backgroundColor: Colors.blue,
      // 背景颜色
      borderRadius: 8,
      // 圆角
      margin: EdgeInsets.all(10),
      // 外边距
      padding: EdgeInsets.all(16),
      // 内边距
      titleText: Text(
        '相机、相册权限使用说明',
        style: TextStyle(
          color: Color(0xff191919), // 设置标题字体颜色
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      messageText: Text(
        'AI照片王正在向您获取“相机”权限，同意后，将用于为您提供拍照、图片编辑、美化、保存服务。',
        style: TextStyle(
          color: Color(0xff818181), // 设置消息字体颜色
          fontSize: 14,
        ),
      ),
      duration: null, // 设置为 null，弹窗不会自动关闭
    );
  }
}
