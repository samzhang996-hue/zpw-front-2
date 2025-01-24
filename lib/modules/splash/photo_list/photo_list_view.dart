import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/permission.dart';

import 'photo_list_logic.dart';

class Photo_listPage extends BaseStatefulWidget {
  final bool isNew;

  Photo_listPage({this.isNew = true});

  @override
  BaseWidgetState<Photo_listPage> getState() => _Photo_listPageState();
}

class _Photo_listPageState extends BaseWidgetState<Photo_listPage> {
  final logic = Get.put(Photo_listLogic());
  final state = Get.find<Photo_listLogic>().state;
  late List<AssetEntity> _photos = [];

  int get _maxSize => 20 * 1000 * 1000;

  late final _isFilesAccessPermission = true.obs;

  Future<void> _loadPhotos() async {
    if (Platform.isIOS) {
      final res = await PermissionUtils.checkFilesAccessPermission();
      if (!res) {
        _isFilesAccessPermission.value = false;
        return;
      }
    } else {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.hasAccess) {
        _isFilesAccessPermission.value = false;
        return;
      }
    }
    _isFilesAccessPermission.value = true;
    List<AssetPathEntity> resultList = await PhotoManager.getAssetPathList();
    Log.d("list----list----${resultList.length}");
    // 假设我们只获取第一个相册的照片
    if (resultList.isNotEmpty) {
      final AssetPathEntity firstAlbum = resultList.first;
      final List<AssetEntity> assetList = await firstAlbum.getAssetListRange(
        start: 0,
        end: 100, // 这里可以指定你想要加载的照片数量
      );
      setState(() {
        _photos = assetList;
      });
    }
  }

  void _uploadImg(String? path) async {
    HandleTool.instance.checkImgAndSave(path, success: (headImageUrl) {
      Log.e("widget.isNew:${widget.isNew}");
      if (path == null) return;
      if (widget.isNew) {
        if (!HandleTool.instance.isMember) {
          Get.offAll(VipPage(), arguments: {"type": 1});
        } else {
          Get.offAll(() => const MainPage());
        }
      } else {
        Get.back(result: headImageUrl);
      }
    });

    // if (res?.isNotEmpty == true) {
    //   final formData = ffff.FormData.fromMap({
    //     "file": await ffff.MultipartFile.fromFile(res!),
    //   });
    //   final bean = await HandleTool.instance.QDSUpload<UploadBean>(
    //       Api.uploadFile,
    //       params: formData,
    //       onModel: (v) => UploadBean.fromJson(v));
    //   if (bean == null) return;

    //   HandleTool.instance.SMWPost('${Api.bindDefaultImg}?imgUrl=${bean.url}',
    //       isShowProgress: true, success: (isSuccess, code, message, results) {
    //     if (isSuccess == true && results.isNotEmpty) {
    //       Get.back();
    //       // HandleTool.showAppToastText("上传成功");
    //       HandleTool.instance.headImg = '${bean.url}';
    //       // Get.offAll(() => const MainPage());
    //       if (!HandleTool.instance.isMember) {
    //         gotoPushPage(VipPage(), arguments: {"type": 1});
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
    Log.e('file----${pickedFile.path}');
    if (Platform.isIOS) {
      int fileSize = await pickedFile.length();
      if (fileSize > _maxSize) {
        HandleTool.showAppToastText("文件过大,请重新选择");
        return;
      }
      Log.e("file:${formatFileSize(fileSize)}");
      // Get.back(result: pickedFile.path);
      _uploadImg(pickedFile.path);
      return;
    }

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
  Widget initDefaultBuild(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Visibility(
              visible: _isFilesAccessPermission.isTrue,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    YAppBar(
                        title: "全部照片",
                        left: !widget.isNew
                            ? null
                            : Center(
                                child: GestureDetector(
                                    onTap: () {
                                      if (!HandleTool.instance.isMember) {
                                        gotoPushPage(VipPage(),
                                            arguments: {"type": 1});
                                      } else {
                                        Get.offAll(() => const MainPage());
                                      }
                                      // Get.back();
                                    },
                                    child: Image.asset(
                                      "all_photos_close.png".comm,
                                      width: 28.w,
                                    )),
                              ),
                        leftClick: !widget.isNew
                            ? null
                            : () {
                                HandleTool.showAppToastText("message");
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
                    //                 child: CommText(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: _photos.length,
                          itemBuilder: (BuildContext context, int index) {
                            final AssetEntity photo = _photos[index];
                            return FutureBuilder<Uint8List?>(
                              future: photo.thumbnailData,
                              builder: (BuildContext context,
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return CommText(
                                        text: 'Error loading thumbnail');
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
                                            HandleTool.showAppToastText(
                                                "文件过大,请重新选择");
                                            return;
                                          }
                                          Log.e(
                                              "file:${formatFileSize(fileSize)}");
                                          _uploadImg(file.path);
                                          // Log.e(
                                          //     "file:${formatFileSize(fileSize)}");
                                          // Get.back(result: file.path);
                                        },
                                        child: Image.memory(thumbnail,
                                            fit: BoxFit.cover));
                                  } else {
                                    return CommText(
                                        text: 'No thumbnail available');
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
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                        topRight: Radius.circular(20.w)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 24.w),
                      Center(
                        child: CommText(
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
                          child: CommText(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: Get.back,
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 175.w,
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1.w,
                                            color: const Color(0xFFFF2E7E)),
                                        borderRadius:
                                            BorderRadius.circular(26.w),
                                      ),
                                      child: Center(
                                        child: CommText(
                                          text: "取消",
                                          textColor: const Color(0xFFFF2E7E),
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
                                        color: const Color(0xFFFF2E7E),
                                        borderRadius:
                                            BorderRadius.circular(26.w),
                                      ),
                                      child: Center(
                                        child: CommText(
                                          text: "去设置",
                                          textColor: const Color(0xFFFFFFFF),
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
