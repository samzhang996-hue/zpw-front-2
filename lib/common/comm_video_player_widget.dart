import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CommVideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int initialPage;
  final bool autoPlay;
  final void Function(int index, VideoPlayerController? videoPlayerController)?
      onPageChanged;

  const CommVideoPlayerWidget({
    super.key,
    required this.videoUrls,
    required this.initialPage,
    required this.onPageChanged,
    required this.autoPlay,
  });

  @override
  State<CommVideoPlayerWidget> createState() => _CommVideoPlayerWidgetState();
}

class _CommVideoPlayerWidgetState extends State<CommVideoPlayerWidget> {
  late PageController _pageController;
  // late final _currentIndex = 0.obs;
  List<VideoPlayerController?> _controllers = [];
  void _initializeControllers() {
    var temp = widget.videoUrls.length > 5 ? 5 : widget.videoUrls.length;

    _controllers = List.generate(widget.videoUrls.length, (index) => null);
    for (int i = 0; i < temp && i < widget.videoUrls.length; i++) {
      _initVideoController(index: i);
    }
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
      itemCount: null,
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
