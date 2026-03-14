import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/multi_image/zpw_multi_image.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_permission.dart';

class ZpwReportView extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<ZpwReportView> getState() => _ZpwCustomerServicePageState();
}

class _ZpwCustomerServicePageState extends ZpwBaseWidgetState<ZpwReportView> {
  late final textController = TextEditingController();
  final ZpwMultiImageController multiImageController = ZpwMultiImageController();

  /// 打开图片选择
  void onAddImage() async {
    // final res = await ZpwPermissionUtils.checkFilesAccessPermission();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    bool storagePermission = await Permission.storage.isGranted;
    if (sdkInt >= 34) {
      // Android 15 (UpsideDownCake)
      // Android 15 及以上版本，请求 READ_MEDIA_IMAGES 和 READ_MEDIA_VIDEO
      PermissionStatus imagesStatus = await Permission.photos.status;
      PermissionStatus videoStatus = await Permission.videos.status;
      if (!videoStatus.isGranted || !imagesStatus.isGranted) {
        ZpwPermissionUtils.showTopSnackbar();
        imagesStatus = await Permission.photos.request();
        // videoStatus = await Permission.videos.request();
        Get.back();
      }
    } else if (sdkInt == 33) {
      // Android 13 (Tiramisu)
      // Android 13，请求 READ_MEDIA_IMAGES 和 READ_MEDIA_VIDEO
      PermissionStatus imagesStatus = await Permission.photos.status;
      PermissionStatus videoStatus = await Permission.videos.status;
      if (!imagesStatus.isGranted || !videoStatus.isGranted) {
        ZpwPermissionUtils.showTopSnackbar();
        imagesStatus = await Permission.photos.request();
        videoStatus = await Permission.videos.request();
        Get.back();
      }
    } else {
      if (!storagePermission) {
        ZpwPermissionUtils.showTopSnackbar();
        storagePermission = await Permission.storage.request().isGranted;
        if (storagePermission) Get.back();
      }
    }
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.hasAccess) {
      final res = await ZpwPermissionUtils.checkFilesAccessPermission();
      if (!res) {
        ZpwHandleTool.showAppToastText('没有权限,请到设置中打开权限');
        return;
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, compressionQuality: 0, allowMultiple: true);
    if (result != null) {
      onSelectedImages(result);
    }
    // selectImages(onSelected: onSelectedImages);
  }

  void onSelectedImages(FilePickerResult picker) {
    for (var file in picker.files) {
      multiImageController.add(ZpwMultiImageProps(file: file.path));
    }
  }

  /// 提交
  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (multiImageController
        .getValue()
        .length > 3) {
      ZpwHandleTool.showAppToastText('最多选择3张');
      return;
    }

    if (textController.text.isEmpty) {
      ZpwHandleTool.showAppToastText('请输入反馈内容');
      return;
    }

    EasyLoading.show();

    /// 随机2-6s
    await Future.delayed(Duration(milliseconds: Random().nextInt(4000) + 2000));
    ZpwHandleTool.showAppToastText('提交成功');
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.dismiss();
    Get.back();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Color get backgroundColor => Colors.white;

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Column(
            children: [
              zpwYAppBar(title: "", bgColor: Colors.transparent),
              10.verticalSpace,
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text('很抱歉为您带来不便，请告诉我们您举报的原因，您可以添加截图进行补充说明',
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF191919),
                              fontWeight: FontWeight.w500)),
                    ),
                    14.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        maxLines: 10,
                        minLines: 6,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: '请输入举报原因',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9A9A9A),
                            fontSize: 14.sp,
                          ),
                          border: GradientOutlineInputBorder(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFCCCCCC),
                                Color(0xFFCCCCCC),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    14.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ZpwMultiImage(
                        controller: multiImageController,
                        border: Border.all(
                            width: 0, color: const Color(0x96F2F2F2)),
                        borderRadius: BorderRadius.circular(8.r),
                        zpwImagePadding: EdgeInsets.zero,
                        addView: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x96F2F2F2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('zpw_report_picture.png'.mine,
                                  width: 30.w, height: 30.w, fit: BoxFit.cover),
                              Text(
                                '选择照片',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFB2B2B2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onAdd: onAddImage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Visibility(
            visible: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0,
            child: SafeArea(
              child: GestureDetector(
                onTap: onSubmit,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    width: 358.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27.w),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Center(
                      child: Text('确认',
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF191919),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
