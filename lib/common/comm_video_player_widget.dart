import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CommVideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int initialPage;
  final bool autoPlay;
  final int groupId;
  final void Function(int index, VideoPlayerController? videoPlayerController)?
      onPageChanged;

  const CommVideoPlayerWidget({
    super.key,
    required this.videoUrls,
    required this.initialPage,
    required this.onPageChanged,
    required this.autoPlay,
    this.groupId = -1,
  });

  @override
  State<CommVideoPlayerWidget> createState() => _CommVideoPlayerWidgetState();
}

class _CommVideoPlayerWidgetState extends State<CommVideoPlayerWidget> {
  late PageController _pageController;
  // late final _currentIndex = 0.obs;
  List<VideoPlayerController?> _controllers = [];
  void _initializeControllers() {
    // var temp = widget.videoUrls.length > 5 ? 5 : widget.videoUrls.length;

    _controllers = List.generate(widget.videoUrls.length, (index) => null);

    final tempFirst = getClosestValues(widget.videoUrls, widget.initialPage);
    for (int i = tempFirst.first;
        i < tempFirst.last && i < widget.videoUrls.length;
        i++) {
      _initVideoController(index: i);
    }
  }

  List<int> getClosestValues(List<String> arr, int index) {
    if (arr.isEmpty || index < 0 || index >= arr.length) return [];

    int halfWindow = 2;
    int start = index - halfWindow;
    int end = index + halfWindow + 1;

    start = start < 0 ? 0 : start;
    end = end > arr.length ? arr.length : end;

    int leftSize = index - start;
    int rightSize = end - index - 1;

    if (leftSize < halfWindow) {
      end = end + (halfWindow - leftSize);
    }

    if (rightSize < halfWindow) {
      start = start - (halfWindow - rightSize);
    }

    return [start, end];
  }

  void _initVideoController({required int index, isZero = false}) {
    if (_controllers[index] != null) return;
    var controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrls[index]));
    controller.initialize().then((_) {
      if (mounted) {
        controller.setLooping(true);

        if (index == widget.initialPage || isZero == true) {
          if (widget.autoPlay) {
            controller.play();
          }
          widget.onPageChanged?.call(index, controller);
        }
        setState(() {});
      }
    });

    _controllers[index] = controller;
  }

  void _onPageChanged(int newIndex) {
    int validIndex = newIndex % widget.videoUrls.length;

    widget.onPageChanged?.call(validIndex, _controllers[validIndex]);

    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i] != null) {
        if (i == validIndex) {
          _controllers[i]!.play();
        } else {
          _controllers[i]!.pause();
        }
      }
    }

    if (validIndex + 1 < widget.videoUrls.length) {
      _initVideoController(index: validIndex + 1);
    }
    if (validIndex - 1 >= 0) {
      _initVideoController(index: validIndex - 1);
    }

    for (int i = 0; i < _controllers.length; i++) {
      if (i < validIndex - 2 || i > validIndex + 2) {
        _controllers[i]?.dispose();
        _controllers[i] = null;
      }
    }

    if (validIndex == 0) {
      _initVideoController(index: validIndex, isZero: true);
    }

    if (validIndex == widget.videoUrls.length - 1) {
      _initVideoController(index: validIndex, isZero: true);
    }
  }

  void _init() {
    _initializeControllers();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void initState() {
    super.initState();
    // Log.e(
    //     "widget.initialPage:${widget.initialPage},widget.videoUrls.length: ${widget.videoUrls.length}");
    _init();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      // itemCount: widget.videoUrls.length,
      itemCount: widget.groupId == -1 ? widget.videoUrls.length : null,
      onPageChanged: _onPageChanged,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        int validIndex = index % widget.videoUrls.length;

        var controller = _controllers[validIndex];
        return controller != null && controller.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
