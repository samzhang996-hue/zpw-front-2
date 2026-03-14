import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ZpwMultiClosePosition {
  final double? left;

  final double? right;

  final double? top;

  final double? bottom;

  const ZpwMultiClosePosition({
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
}

class ZpwMultiImageController {
  final List<ZpwMultiImageProps>? zpwInitData;

  _ZpwMultiImageState? _zpwMultiImageState;

  ZpwMultiImageController({
    this.zpwInitData,
  });

  /// 绑定状态
  void _bindMultiImageState(_ZpwMultiImageState state) {
    this._zpwMultiImageState = state;
    state._data = zpwInitData ?? [];
  }

  /// 添加图片
  void add(ZpwMultiImageProps data) {
    _zpwMultiImageState?._add(data);
  }

  /// 添加图片
  void addAll(List<ZpwMultiImageProps> data) {
    _zpwMultiImageState?._addAll(data);
  }

  /// 设置编辑状态
  void setEdit(bool status) {
    _zpwMultiImageState?._setEdit(status);
  }

  /// 获取数据
  List<ZpwMultiImageProps> getValue() {
    return _zpwMultiImageState == null ? [] : _zpwMultiImageState!._data;
  }
}

class ZpwMultiImage extends StatefulWidget {
  /// 控制器
  final ZpwMultiImageController controller;

  /// 最大数量
  final int? zpwMaxLength;

  /// 水平间距
  final double zpwCrossAxisSpacing;

  /// 垂直间距
  final double zpwMainAxisSpacing;

  /// 每列数量
  final int zpwCrossAxisCount;

  final BoxBorder? border;

  final bool edit;

  final GestureTapCallback? onAdd;

  /// 删除图片时处罚
  final GestureTapCallback? onRemove;

  final Widget? addView;

  final BorderRadiusGeometry? borderRadius;

  final BorderRadius zpwImageRadius;

  final double zpwChildAspectRatio;

  final EdgeInsetsGeometry zpwImagePadding;

  final ZpwMultiClosePosition zpwClosePosition;

  const ZpwMultiImage({
    Key? key,
    required this.controller,
    this.zpwMaxLength,
    this.zpwCrossAxisSpacing = 5,
    this.zpwMainAxisSpacing = 5,
    this.zpwCrossAxisCount = 3,
    this.zpwChildAspectRatio = 1.0,
    this.border,
    this.onAdd,
    this.edit = true,
    this.addView,
    this.borderRadius,
    this.onRemove,
    this.zpwImagePadding = const EdgeInsets.all(5),
    this.zpwImageRadius = const BorderRadius.all(Radius.circular(5)),
    this.zpwClosePosition = const ZpwMultiClosePosition(right: 3, top: 3),
  }) : super(key: key);

  @override
  _ZpwMultiImageState createState() => _ZpwMultiImageState();
}

class _ZpwMultiImageState extends State<ZpwMultiImage> {
  List<ZpwMultiImageProps> _data = [];

  late bool _edit;

  @override
  initState() {
    super.initState();
    widget.controller._bindMultiImageState(this);
    _edit = widget.edit;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.zpwCrossAxisCount,
        crossAxisSpacing: widget.zpwCrossAxisSpacing,
        mainAxisSpacing: widget.zpwMainAxisSpacing,
        childAspectRatio: widget.zpwChildAspectRatio,
      ),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(5),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        if (_data.length > index) {
          return Container(
            decoration: BoxDecoration(
              border: widget.border ??
                  Border.all(
                      style: BorderStyle.solid,
                      color: Theme.of(context).dividerColor),
              borderRadius: widget.borderRadius,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: widget.zpwImagePadding,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: widget.zpwImageRadius,
                      child: _getImageView(_data[index]),
                    ),
                  ),
                ),
                if (_edit)
                  Positioned(
                    right: widget.zpwClosePosition.right,
                    top: widget.zpwClosePosition.top,
                    left: widget.zpwClosePosition.left,
                    bottom: widget.zpwClosePosition.bottom,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                      onTap: () {
                        _data.removeAt(index);
                        widget.onRemove?.call();
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          );
        }
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: widget.border ??
                  Border.all(
                      style: BorderStyle.solid,
                      color: Theme.of(context).dividerColor),
              borderRadius: widget.borderRadius,
            ),
            child: widget.addView ??
                Icon(Icons.add, color: Theme.of(context).dividerColor),
          ),
          onTap: () {
            widget.onAdd?.call();
          },
        );
      },
    );
  }

  int _getItemCount() {
    if (widget.zpwMaxLength != null) {
      return widget.zpwMaxLength! > _data.length
          ? _edit
              ? _data.length + 1
              : _data.length
          : widget.zpwMaxLength!;
    }
    return _edit ? _data.length + 1 : _data.length;
  }

  Widget _getImageView(ZpwMultiImageProps data) {
    return Image.file(File(data.file!),
        width: double.maxFinite, height: double.maxFinite, fit: BoxFit.cover);
  }

  void _add(ZpwMultiImageProps data) {
    _data.add(data);
    setState(() {});
  }

  void _addAll(List<ZpwMultiImageProps> data) {
    _data.addAll(data);
    setState(() {});
  }

  void _setEdit(bool status) {
    _edit = status;
    setState(() {});
  }
}

class ZpwMultiImageProps {
  final String? url;

  final String? file;

  final Uint8List? fileData;

  /// 用于需要拼接网络地址使用
  final String? baseUrl;

  dynamic data;

  ZpwMultiImageProps({
    this.url,
    this.file,
    this.baseUrl,
    this.fileData,
    this.data,
  });
}