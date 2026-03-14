import 'package:flutter/material.dart';
import 'package:zpw/common/view/zpw_empty_view.dart';

// ignore: must_be_immutable
class ZpwBaseContentPage extends StatefulWidget {
  late bool zpwIsShowEmpty;

  /// 是否显示空页面
  Widget? zpwContentWidget;

  /// 内容视图
  late String? zpwEmptyText;

  /// 空页面展示提示文字
  late bool zpwIsShowLoadBtn;

  /// 是否显示加载按钮
  late String zpwImagePath;
  Function? zpwClickLoadAction;
  ZpwBaseContentPage(
      {super.key,
      this.zpwIsShowEmpty = false,
      this.zpwClickLoadAction,
      this.zpwContentWidget,
      this.zpwEmptyText,
      this.zpwIsShowLoadBtn = false,
      this.zpwImagePath = 'empty_box.png'});

  @override
  State<ZpwBaseContentPage> createState() => _ZpwBaseContentPageState();
}

class _ZpwBaseContentPageState extends State<ZpwBaseContentPage> {
  @override
  Widget build(BuildContext context) {
    return widget.zpwIsShowEmpty == true
        ? ZpwEmptyView(
            text: widget.zpwEmptyText,
            isShowBtn: widget.zpwIsShowLoadBtn,
            imagePath: widget.zpwImagePath,
            clickLoadAction: widget.zpwClickLoadAction,
          )
        : widget.zpwContentWidget ?? Container();
  }
}