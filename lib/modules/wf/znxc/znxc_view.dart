import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/utils/log_utils.dart';
import 'znxc_logic.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ZnxcPage extends BaseStatefulWidget {
  @override
  BaseWidgetState<ZnxcPage> getState() => _ZnxcPageState();
}

class _ZnxcPageState extends BaseWidgetState<ZnxcPage> {
  final logic = Get.put(ZnxcLogic());
  final state = Get.find<ZnxcLogic>().state;

  final List<Offset> _points = [];
  late String _originalBase64;
  // img.Image? _image

  Uint8List? _base64Image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 假设您已经有了原始图片的base64编码
    _originalBase64 = ""; // 替换为实际的base64编码
    // _loadImageFromBase64(_originalBase64!);
  }

  // Future<void> _loadImageFromBase64(String base64) async {
  //   Uint8List imageBytes = base64Decode(base64.split(',').last);
  //   _image = img.decodeImage(imageBytes)!;
  //   setState(() {
  //     _base64Image = Uint8List.fromList(imageBytes);
  //   });
  // }

  // Future<void> _generateMaskAndSendToApi() async {
  //   if (_image == null || _points.length < 2) return;
  //
  //   img.Image maskImage = img.Image(_image!.width, _image!.height);
  //   fillImageWithColor(maskImage, img.Color.setRgb(255, 255, 255)); // 白色表示不消除区域
  //
  //   // 简化处理：使用简单的线性插值来填充涂抹区域为黑色（表示消除）
  //   for (int i = 1; i < _points.length; i++) {
  //     Offset p1 = _points[i - 1];
  //     Offset p2 = _points[i];
  //     _drawLine(maskImage, p1, p2, img.Color.setRgb(0, 0, 0));
  //   }
  //
  //   Uint8List maskBytes = Uint8List.fromList(img.encodePng(maskImage));
  //   String maskBase64 = base64Encode(maskBytes);
  // }

  // void _drawLine(img.Image image, Offset p1, Offset p2, img.Color color) {
  //   int dx = p2.dx.toInt() - p1.dx.toInt();
  //   int dy = p2.dy.toInt() - p1.dy.toInt();
  //   int steps = max(dx.abs(), dy.abs());
  //   double xIncrement = dx / steps;
  //   double yIncrement = dy / steps;
  //
  //   for (int i = 0; i <= steps; i++) {
  //     int x = (p1.dx + xIncrement * i).toInt();
  //     int y = (p1.dy + yIncrement * i).toInt();
  //     image.setPixel(x, y, color);
  //   }
  // }
  //
  // void fillImageWithColor(img.Image image, img.Color color) {
  //   for (int x = 0; x < image.width; x++) {
  //     for (int y = 0; y < image.height; y++) {
  //       image.setPixel(x, y, color);
  //     }
  //   }
  // }

  @override
  Widget initDefaultBuild(BuildContext context) {
    final double imageWidth = 358.w;
    final double imageHeight = 526.w;
    img.Image? _image;
    Uint8List? _base64Image;
    String? _originalBase64;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            Log.d("details-------------${details.localPosition}");
            setState(() {
              _points.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            // 可选：在涂抹结束时执行一些操作，比如清除_points以开始新的涂抹
            // 但在这个例子中，我们保留所有点以便持续显示涂抹轨迹
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              QdsImage(
                'https://img2.baidu.com/it/u=559124887,2543760257&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1373',
                imageWidth,
                imageHeight,
                fit: BoxFit.cover,
              ),
              // 使用CustomPaint绘制涂抹轨迹
              // 使用CustomPaint绘制手势点
              CustomPaint(
                size: Size(imageWidth, imageHeight),
                painter: _ScribblePainter(_points),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScribblePainter extends CustomPainter {
  final List<Offset> points;

  _ScribblePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final Paint paint = Paint()
      ..color = Color(0xff4909D4BF)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 50.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    // 可选：在最后一个点和第一个点之间绘制一条线以形成闭环（如果需要的话）
    // canvas.drawLine(points.last, points.first, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 如果points列表发生变化，则应该重绘
    return oldDelegate != this;
  }
}
