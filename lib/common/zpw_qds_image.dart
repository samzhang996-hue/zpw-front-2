//图片加载
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zpw/base/zpw_base_config.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_style.dart';

Widget ZpwQdsImage(String url, double width, double height,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = ZpwBaseConfig.zpwDefaultPlaceholder}) {
  if (url.isEmpty) {
    return imagePlaceholder.isEmpty
        ? Container(
            color: ZpwColorPlate.zpwThemeBgColor,
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
  //             color: ZpwColorPlate.themeBgColor,
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
            color: ZpwColorPlate.zpwThemeBgColor,
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
Widget ZpwQdsImageCorner(String url, double width, double height, double corner,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = ZpwBaseConfig.zpwDefaultPlaceholder}) {
  return ClipRRect(
      child: ZpwQdsImage(url, width, height,
          fit: fit, imagePlaceholder: imagePlaceholder),
      borderRadius: BorderRadius.all(Radius.circular(corner)));
}

//圆形图片加载
Widget ZpwQdsImageCircle(String url, double width, double height,
    {BoxFit fit = BoxFit.cover,
    String imagePlaceholder = ZpwBaseConfig.zpwDefaultPlaceholder,
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
      child: ZpwQdsImage(url, width, height,
          fit: fit, imagePlaceholder: imagePlaceholder));
}