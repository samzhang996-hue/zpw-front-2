import 'package:flutter/material.dart';
import 'package:zpw/common/view/empty_view.dart';

// ignore: must_be_immutable
class BaseContentPage extends StatefulWidget {
  late bool isShowEmpty;

  /// 是否显示空页面
  Widget? contentWidget;

  /// 内容视图
  late String? emptyText;

  /// 空页面展示提示文字
  late bool isShowLoadBtn;

  /// 是否显示加载按钮
  late String imagePath;
  Function? clickLoadAction;
  BaseContentPage(
      {super.key,
      this.isShowEmpty = false,
      this.clickLoadAction,
      this.contentWidget,
      this.emptyText,
      this.isShowLoadBtn = false,
      this.imagePath = 'empty_box.png'});

  @override
  State<BaseContentPage> createState() => _BaseContentPageState();
}

class _BaseContentPageState extends State<BaseContentPage> {
  @override
  Widget build(BuildContext context) {
    return widget.isShowEmpty == true
        ? EmptyView(
            text: widget.emptyText,
            isShowBtn: widget.isShowLoadBtn,
            imagePath: widget.imagePath,
            clickLoadAction: widget.clickLoadAction,
          )
        : widget.contentWidget ?? Container();
  }
}
