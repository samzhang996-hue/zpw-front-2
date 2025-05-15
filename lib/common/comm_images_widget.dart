import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/qds_Image.dart';

class CommImagesWidget extends StatefulWidget {
  final List<String> images;
  final int initialPage;
  final int groupId;
  final void Function(int index)? onPageChanged;

  const CommImagesWidget({
    super.key,
    required this.images,
    required this.initialPage,
    this.onPageChanged,
    this.groupId = -1,
  });

  @override
  State<CommImagesWidget> createState() => _CommImagesWidgetState();
}

class _CommImagesWidgetState extends State<CommImagesWidget> {
  late PageController _pageController;

  void _onPageChanged(int newIndex) {
    int validIndex = newIndex % widget.images.length;
    widget.onPageChanged?.call(validIndex);
  }

  // 监听页面变化
  void _onPageChangedListener() {
    int newIndex = _pageController.page!.toInt();

    // 实现循环效果
    if (newIndex == widget.images.length) {
      _pageController.jumpToPage(0); // 循环到第一个
    }

    // else if (newIndex == 0) {
    //   _pageController.jumpToPage(widget.images.length); // 循环到最后一个
    // }
  }

  void _init() {
    _pageController = PageController(initialPage: widget.initialPage);
    Future.delayed(const Duration(milliseconds: 200), () {
      widget.onPageChanged?.call(widget.initialPage);
    });
    // _pageController.addListener(_onPageChangedListener);
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    // _pageController.removeListener(_onPageChangedListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.groupId == -1 ? widget.images.length : null,
      // physics: const BouncingScrollPhysics(),
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        int validIndex = index % widget.images.length;
        return Container(
          alignment: Alignment.center,
          color: Colors.black,
          width: 1.sw,
          height: 1.sh,
          child: QdsImage(widget.images[validIndex], 1.sw, 1.sh, fit: BoxFit.contain),
        );
      },
    );
  }
}
