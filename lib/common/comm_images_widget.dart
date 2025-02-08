import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/utils/log_utils.dart';

class CommImagesWidget extends StatefulWidget {
  final List<String> images;
  final int initialPage;
  final void Function(int index)? onPageChanged;
  const CommImagesWidget({
    super.key,
    required this.images,
    required this.initialPage,
    this.onPageChanged,
  });

  @override
  State<CommImagesWidget> createState() => _CommImagesWidgetState();
}

class _CommImagesWidgetState extends State<CommImagesWidget> {
  late PageController _pageController;

  void _onPageChanged(int newIndex) {}

  void _init() {
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void initState() {
    super.initState();
    Log.e('widget.initialPage:${widget.initialPage}');
    _init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.images.length,
      physics: const BouncingScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          width: 1.sw,
          height: 1.sh,
          child: QdsImage(
            widget.images[index],
            1.sw,
            1.sh,
          ),
        );
      },
    );
  }
}
