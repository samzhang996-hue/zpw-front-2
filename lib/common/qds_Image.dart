//图片加载
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zpw/base/base_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/style.dart';

Widget QdsImage(String url, double width, double height,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = baseConfig.defaultPlaceholder}) {
  if (url.isEmpty) {
    return imagePlaceholder.isEmpty
        ? Container(
            color: ColorPlate.themeBgColor,
            child: const Icon(
              Icons.error,
              color: Colors.black,
            ),
            width: width,
            height: height)
        : Image.asset(imagePlaceholder.mine,
            width: width, height: height, fit: fit);
  }

  // else if (url.endsWith(".webp")) {
  //   return CachedNetworkImage(
  //     imageUrl: url,
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     imageBuilder: (context, imageProvider) {
  //       if (imageProvider is NetworkImage) {
  //         return GifView.network(imageProvider.url);
  //       }
  //       if (imageProvider is CachedNetworkImageProvider) {
  //         return GifView.network(imageProvider.url);
  //       }
  //       return const Center(
  //         child: Text("网络错误", style: TextStyle(color: Colors.red)),
  //       );
  //     },
  //     placeholder: (context, url) => Image.asset(
  //       imagePlaceholder.mine,
  //       width: width,
  //       height: height,
  //       fit: fit,
  //     ),
  //     errorWidget: (context, url, e) => imagePlaceholder.isEmpty
  //         // ignore: sized_box_for_whitespace
  //         ? Container(
  //             color: ColorPlate.themeBgColor,
  //             child: Icon(
  //               Icons.error,
  //               color: Colors.black,
  //             ),
  //             width: width,
  //             height: height)
  //         : Image.asset(imagePlaceholder.mine,
  //             width: width, height: height, fit: fit),
  //   );

  // }

  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) => Image.asset(
      imagePlaceholder.mine,
      width: width,
      height: height,
      fit: fit,
    ),
    errorWidget: (context, url, e) => imagePlaceholder.isEmpty
        // ignore: sized_box_for_whitespace
        ? Container(
            color: ColorPlate.themeBgColor,
            child: const Icon(
              Icons.error,
              color: Colors.black,
            ),
            width: width,
            height: height)
        : Image.asset(imagePlaceholder.mine,
            width: width, height: height, fit: fit),
  );
}

//圆角图片加载
Widget QdsImageCorner(String url, double width, double height, double corner,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = baseConfig.defaultPlaceholder}) {
  return ClipRRect(
      child: QdsImage(url, width, height,
          fit: fit, imagePlaceholder: imagePlaceholder),
      borderRadius: BorderRadius.all(Radius.circular(corner)));
}

//圆形图片加载
Widget QdsImageCircle(String url, double width, double height,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = baseConfig.defaultPlaceholder,
    bool isLocal = false}) {
  if (isLocal) {
    File file = File(url);
    bool isExists = file.existsSync();
    if (isExists) {
      return ClipOval(
        child: Image.file(File(url), width: width, height: height, fit: fit),
      );
    }
  }

  return ClipOval(
      child: QdsImage(url, width, height,
          fit: fit, imagePlaceholder: imagePlaceholder));
}
