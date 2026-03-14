import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class ZpwCommVideoPlayerWidget extends StatefulWidget {
  final List<String> videoUrls;
  final int initialPage;
  final bool autoPlay;
  final int groupId;
  final void Function(int index, BetterPlayerController? betterPlayerController)? onPageChanged;

  const ZpwCommVideoPlayerWidget({
    super.key,
    required this.videoUrls,
    required this.initialPage,
    required this.onPageChanged,
    required this.autoPlay,
    this.groupId = -1,
  });

  @override
  State<ZpwCommVideoPlayerWidget> createState() => _ZpwCommVideoPlayerWidgetState();
}

class _ZpwCommVideoPlayerWidgetState extends State<ZpwCommVideoPlayerWidget> {
  late PageController _pageController;
  BetterPlayerController? _currentController;
  int _currentIndex = 0;
  bool _isPageChanged = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPage;
    _pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: 1.0,
      keepPage: false,
    );
    // 延迟初始化，等待 context 可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initCurrentController();
      }
    });
  }

  void _initCurrentController() {
    if (_isInitializing) return;
    _isInitializing = true;

    // 先销毁旧控制器
    _disposeController();

    if (_currentIndex < 0 || _currentIndex >= widget.videoUrls.length) {
      _isInitializing = false;
      return;
    }

    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;

    final betterPlayerDataSource = BetterPlayerDataSource.network(
      widget.videoUrls[_currentIndex],
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
    );

    _currentController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoDispose: true,
        autoPlay: widget.autoPlay,
        looping: true,
        fit: BoxFit.cover,
        expandToFill: true,
        aspectRatio: screenSize.width / screenSize.height,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
          enablePlayPause: false,
          enableMute: false,
          enableProgressBar: false,
          enableSkips: false,
          enableOverflowMenu: false,
          enableFullscreen: false,
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _currentController!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
          if (!_isPageChanged) {
            widget.onPageChanged?.call(_currentIndex, _currentController);
          }
        }
      }
    });
  }

  void _disposeController() {
    if (_currentController != null) {
      try {
        _currentController!.pause();
        _currentController!.dispose();
      } catch (e) {
        // 忽略销毁错误
      }
      _currentController = null;
    }
  }

  void _onPageChanged(int newIndex) {
    final validIndex = newIndex % widget.videoUrls.length;

    if (validIndex == _currentIndex) return;

    _isPageChanged = true;
    _currentIndex = validIndex;

    // 重新初始化当前页的控制器
    _initCurrentController();

    widget.onPageChanged?.call(validIndex, _currentController);
  }

  @override
  void dispose() {
    _disposeController();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.black,
      width: screenSize.width,
      height: screenSize.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.groupId == -1 ? widget.videoUrls.length : null,
        onPageChanged: _onPageChanged,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final validIndex = index % widget.videoUrls.length;

          // 只渲染当前页面的视频
          if (validIndex != _currentIndex) {
            return Container(
              color: Colors.black,
              width: screenSize.width,
              height: screenSize.height,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (_currentController == null) {
            return Container(
              color: Colors.black,
              width: screenSize.width,
              height: screenSize.height,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          // 全屏显示视频
          return Container(
            color: Colors.black,
            width: screenSize.width,
            height: screenSize.height,
            child: BetterPlayer(
              key: ValueKey('video_$validIndex'),
              controller: _currentController!,
            ),
          );
        },
      ),
    );
  }
}