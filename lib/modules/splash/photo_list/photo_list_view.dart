import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/wf/aikt/aikt_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_permission.dart';
import 'package:zpw/modules/vip/view/custom_face_dialog_utils.dart';

import 'photo_list_logic.dart';

class Photo_listPage extends ZpwBaseStatefulWidget {
  final bool isNew;
  final bool hasAvatar;

  Photo_listPage({this.isNew = true, this.hasAvatar = true});

  @override
  ZpwBaseWidgetState<Photo_listPage> getState() => _Photo_listPageState();
}

class _Photo_listPageState extends ZpwBaseWidgetState<Photo_listPage> {
  final logic = Get.put(Photo_listLogic());
  final state = Get.find<Photo_listLogic>().state;
  late List<AssetEntity> _photos = [];

  int get _maxSize => 20 * 1000 * 1000;

  late final _isFilesAccessPermission = true.obs;

  Future<void> _loadPhotos() async {
    if (Platform.isIOS) {
      final res = await ZpwPermissionUtils.checkFilesAccessPermission();
      if (!res) {
        _isFilesAccessPermission.value = false;
        state.isPermission.value = false;
        return;
      }
    } else {
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
      ZpwLog.d("msg----${ps.hasAccess}");
      if (!ps.hasAccess) {
        final res = await ZpwPermissionUtils.checkFilesAccessPermission();
        if (!res) {
          _isFilesAccessPermission.value = false;
          state.isPermission.value = false;
          return;
        }
      }
    }
    _isFilesAccessPermission.value = true;
    state.isPermission.value = true;
    List<AssetPathEntity> resultList = await PhotoManager.getAssetPathList(type: RequestType.image);
    ZpwLog.d("list----list----${resultList.length}");
    // 假设我们只获取第一个相册的照片
    if (resultList.isNotEmpty) {
      final AssetPathEntity firstAlbum = resultList.first;
      EasyLoading.show();
      final count = await firstAlbum.assetCountAsync;
      EasyLoading.dismiss();
      final List<AssetEntity> assetList = await firstAlbum.getAssetListRange(
        start: 0,
        end: count, // 这里可以指定你想要加载的照片数量
      );
      setState(() {
        _photos = assetList;
      });
    }
  }

  Future<void> _uploadImg(String? path) async {
    if (state.type == 1) {
      // zpwGotoPushPage(AiktPage(), arguments: {"path": path});
      Get.off(AiktPage(), arguments: {"path": path});
      return;
    }
    final headImageUrl = await ZpwHandleTool.instance.checkImgAndSaveAsync(path, bindDefaultImg: widget.hasAvatar);
    ZpwLog.e("widget.isNew:${widget.isNew}");
    if (headImageUrl != null && headImageUrl.isNotEmpty) {
      if (widget.isNew) {
        Get.offAll(() => const MainPage());
      } else {
        if (widget.hasAvatar) {
          Get.find<MineLogic>().getUserInfo();
        }
        Get.back(result: headImageUrl);
      }
    } else {
      CustomFaceDialogUtils.showCustomDialog(onPressed: () {});
    }

    // if (res?.isNotEmpty == true) {
    //   final formData = ffff.FormData.fromMap({
    //     "file": await ffff.MultipartFile.fromFile(res!),
    //   });
    //   final bean = await ZpwHandleTool.instance.QDSUpload<UploadBean>(
    //       Api.uploadFile,
    //       params: formData,
    //       onModel: (v) => UploadBean.fromJson(v));
    //   if (bean == null) return;

    //   ZpwHandleTool.instance.SMWPost('${Api.bindDefaultImg}?imgUrl=${bean.url}',
    //       isShowProgress: true, success: (isSuccess, code, message, results) {
    //     if (isSuccess == true && results.isNotEmpty) {
    //       Get.back();
    //       // ZpwHandleTool.showAppToastText("上传成功");
    //       ZpwHandleTool.instance.headImg = '${bean.url}';
    //       // Get.offAll(() => const MainPage());
    //       if (!ZpwHandleTool.instance.isMember) {
    //         zpwGotoPushPage(VipPage(), arguments: {"type": 1});
    //       } else {
    //         Get.offAll(() => const MainPage());
    //       }
    //     } else {
    //       CustomFaceDialogUtils.showCustomDialog(
    //           context: context,
    //           onPressed: () {
    //             _uploadImg();
    //           });
    //     }
    //   });
    // }
  }

  Future<void> pickImage({ImageSource source = ImageSource.camera}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 60,
    );
    if (pickedFile == null) {
      return;
    }
    ZpwLog.e('file----${pickedFile.path}');
    // if (Platform.isIOS) {
    int fileSize = await pickedFile.length();
    if (fileSize > _maxSize) {
      ZpwHandleTool.showAppToastText("文件过大,请重新选择");
      return;
    }
    ZpwLog.e("file:${formatFileSize(fileSize)}");
    if (state.type == 1) {
      // zpwGotoPushPage(AiktPage(), arguments: {"path": pickedFile.path});
      Get.off(AiktPage(), arguments: {"path": pickedFile.path});
      return;
    }
    // Get.back(result: pickedFile.path);
    _uploadImg(pickedFile.path);
    return;
    // }

    _loadPhotos();
  }

  String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPhotos();
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Visibility(
              visible: _isFilesAccessPermission.isTrue,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    zpwYAppBar(
                        title: "全部照片",
                        left: !widget.isNew
                            ? null
                            : Center(
                                child: Image.asset(
                                  "all_photos_close.png".comm,
                                  width: 28.w,
                                ),
                              ),
                        leftClick: !widget.isNew
                            ? null
                            : () {
                                Get.offAll(() => const MainPage());
                              },
                        right: InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.asset(
                              "camera.png".comm,
                              width: 28.w,
                            ))),
                    // if (Platform.isIOS)
                    //   Expanded(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         InkWell(
                    //           child: Container(
                    //             // : EdgeInsets.only(left: 27.w, right: 27.w),
                    //             width: 120.w,
                    //             height: 44.w,
                    //             decoration: BoxDecoration(
                    //                 color: const Color(0xffFF2E7E),
                    //                 borderRadius: BorderRadius.circular(30)),
                    //             child: Center(
                    //                 child: ZpwCommText(
                    //               text: "相册选择",
                    //               fontSize: 18.sp,
                    //               fontWeight: FontWeight.bold,
                    //               textColor: Colors.white,
                    //             )),
                    //           ),
                    //           onTap: () {
                    //             pickImage(source: ImageSource.gallery);
                    //           },
                    //         )
                    //       ],
                    //     ),
                    //   )
                    // else
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: _photos.length,
                          itemBuilder: (BuildContext context, int index) {
                            final AssetEntity photo = _photos[index];
                            return FutureBuilder<Uint8List?>(
                              future: photo.thumbnailData,
                              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return ZpwCommText(text: 'Error loading thumbnail');
                                  }
                                  Uint8List? thumbnail = snapshot.data;
                                  if (thumbnail != null) {
                                    return GestureDetector(
                                        onTap: () async {
                                          final file = await photo.file;
                                          if (file == null) {
                                            return;
                                          }
                                          int fileSize = await file.length();

                                          if (fileSize > _maxSize) {
                                            ZpwHandleTool.showAppToastText("文件过大,请重新选择");
                                            return;
                                          }
                                          ZpwLog.e("file:${formatFileSize(fileSize)}");
                                          _uploadImg(file.path);
                                          // ZpwLog.e(
                                          //     "file:${formatFileSize(fileSize)}");
                                          // Get.back(result: file.path);
                                        },
                                        child: Image.memory(thumbnail, fit: BoxFit.cover));
                                  } else {
                                    return ZpwCommText(text: 'No thumbnail available');
                                  }
                                } else {
                                  // 可以显示一个占位符，比如一个圆形进度指示器
                                  return const CircularProgressIndicator();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        Obx(() => Visibility(
              visible: _isFilesAccessPermission.isFalse,
              child: Container(
                width: 1.sw,
                height: 1.sh,
                color: const Color(0xFF000000).withOpacity(0.71),
              ),
            )),
        Obx(() => Visibility(
              visible: _isFilesAccessPermission.isFalse,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 214.w,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 24.w),
                      Center(
                        child: ZpwCommText(
                          text: "相机、相册",
                          textColor: const Color(0xFF191919),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 11.w),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: Center(
                          child: ZpwCommText(
                            text: "AI照片王需要相机、相册权限为您提供服务，请在设置中开启",
                            textColor: const Color(0xFF999999),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          width: 1.sw,
                          height: 100.w,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: Get.back,
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 175.w,
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 1.w, color: const Color(0xFF191919)),
                                        borderRadius: BorderRadius.circular(26.w),
                                      ),
                                      child: Center(
                                        child: ZpwCommText(
                                          text: "取消",
                                          textColor: const Color(0xFF191919),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      openAppSettings();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 175.w,
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                        ),
                                        borderRadius: BorderRadius.circular(26.w),
                                      ),
                                      child: Center(
                                        child: ZpwCommText(
                                          text: "去设置",
                                          textColor: const Color(0xFF191919),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 10.w),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
