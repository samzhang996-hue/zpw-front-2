import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/utils/log_utils.dart';
import 'photo_list_logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
class Photo_listPage extends BaseStatefulWidget {

  @override
  BaseWidgetState<Photo_listPage> getState()=>_Photo_listPageState();
}

class _Photo_listPageState extends BaseWidgetState<Photo_listPage> {
  final logic = Get.put(Photo_listLogic());
  final state = Get.find<Photo_listLogic>().state;
  late List<AssetEntity> _photos = [];

  Future<void> _loadPhotos() async {
     List<AssetPathEntity> resultList = await PhotoManager.getAssetPathList();
     Log.d("list----list----${resultList.length}");
    // 假设我们只获取第一个相册的照片
    if (resultList.isNotEmpty) {
      final AssetPathEntity firstAlbum = resultList.first;
      final List<AssetEntity> assetList = await firstAlbum.getAssetListRange(
        start: 0,
        end: 100,  // 这里可以指定你想要加载的照片数量
      );
      setState(() {
        _photos = assetList;
      });

    }
  }
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );
    print('file----${pickedFile?.path}');
    _loadPhotos();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPhotos();
  }
  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(title: "全部照片",right: InkWell(
            onTap: (){
              pickImage();
            },
            child: Image.asset("camera.png".comm,width: 28.w,)
          )),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16.w,right: 16.w),
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
                          return CommText(text: 'Error loading thumbnail');
                        }
                        Uint8List? thumbnail = snapshot.data;
                        if (thumbnail != null) {
                          return Image.memory(thumbnail, fit: BoxFit.cover);
                        } else {
                          return CommText(text: 'No thumbnail available');
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
      )
    );
  }
}
