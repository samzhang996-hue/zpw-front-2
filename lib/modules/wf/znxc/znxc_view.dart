import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';

class ZnxcPage extends StatefulWidget {
  const ZnxcPage({Key? key}) : super(key: key);

  @override
  State<ZnxcPage> createState() => _ZnxcPageState();
}

class _ZnxcPageState extends State<ZnxcPage> {
  File? _image; // 用户选择的图片
  ui.Image? _paintImage; // 用于绘制的图片
  List<Offset> _points = []; // 用户涂抹的点
  GlobalKey _globalKey = GlobalKey(); // 用于获取绘制的区域

  // ============ 原 ZnxcLogic 的方法 ============

  Future<void> smartRemove(String img, String mask) async {
    try {
      final response = await HttpClient().post(
        ApiConfig.smartRemove,
        data: {"imgUrls": [img], "mask": mask},
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final Map data = response.data as Map;
        setState(() {});
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  // ============ 图片处理方法 ============

  // 选择图片
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _points.clear(); // 清空涂抹点
      });

      // 加载图片到内存
      final bytes = await _image!.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      setState(() {
        _paintImage = frame.image;
      });
    }
  }

  // 生成 Mask 图
  Future<Uint8List> _generateMask() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 绘制黑色背景
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, _paintImage!.width.toDouble(), _paintImage!.height.toDouble()),
      paint,
    );

    // 绘制用户涂抹的区域（白色）
    final maskPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < _points.length - 1; i++) {
      if (_points[i] != Offset(-1, -1) && _points[i + 1] != Offset(-1, -1)) {
        canvas.drawLine(_points[i], _points[i + 1], maskPaint);
      }
    }

    // 生成图片
    final picture = recorder.endRecording();
    final maskImage = await picture.toImage(_paintImage!.width, _paintImage!.height);
    final byteData = await maskImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // 消除图片并保存到相册
  Future<void> _eraseImage() async {
    if (_image == null || _points.isEmpty) return;

    // 生成 Mask 图
    final maskBytes = await _generateMask();

    // 保存 Mask 图到临时文件
    final tempDir = Directory.systemTemp;
    final maskFile = File('${tempDir.path}/mask_${DateTime.now().millisecondsSinceEpoch}.png');
    await maskFile.writeAsBytes(maskBytes);

    // 调用 OpenCV 的 inpaint 函数
    final outputFile = File('${tempDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.png');
    final success = await inpaint(_image!.path, maskFile.path, outputFile.path, 10);

    if (success) {
      // 保存图片到相册
      final result = await GallerySaver.saveImage(
        outputFile.path,
        albumName: 'MyAlbum',
        toDcim: true,
      );

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('图片已保存到相册')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败，请重试')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('图片修复失败')),
      );
    }

    // 删除临时文件
    maskFile.delete();
    outputFile.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片消除'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _eraseImage,
            tooltip: '消除并保存',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _image == null
                ? Center(child: Text('请选择一张图片'))
                : GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        // 将全局坐标转换为相对于图片的局部坐标
                        RenderBox renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
                        Offset localPosition = renderBox.globalToLocal(details.globalPosition);

                        // 计算图片的实际显示尺寸
                        final imageWidth = _paintImage!.width.toDouble();
                        final imageHeight = _paintImage!.height.toDouble();
                        final containerSize = renderBox.size;

                        // 计算缩放比例
                        final scaleX = imageWidth / containerSize.width;
                        final scaleY = imageHeight / containerSize.height;

                        // 转换坐标
                        final scaledPosition = Offset(
                          localPosition.dx * scaleX,
                          localPosition.dy * scaleY,
                        );

                        _points.add(scaledPosition);
                      });
                    },
                    onPanEnd: (details) {
                      _points.add(Offset(-1, -1)); // 添加一个结束标记
                    },
                    child: Center(
                      child: FittedBox(
                        key: _globalKey,
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: _paintImage!.width.toDouble(),
                          height: _paintImage!.height.toDouble(),
                          child: CustomPaint(
                            painter: ImagePainter(_paintImage!, _points),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('选择图片'),
          ),
        ],
      ),
    );
  }
}

// 自定义绘制器
class ImagePainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> points;

  ImagePainter(this.image, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制原图
    canvas.drawImage(image, Offset.zero, Paint());

    // 绘制用户涂抹的区域（白色）
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset(-1, -1) && points[i + 1] != Offset(-1, -1)) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
