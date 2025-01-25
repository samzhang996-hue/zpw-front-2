import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/main.dart';

class CommVideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const CommVideoPlayerPage({super.key, required this.videoUrl});

  @override
  State<CommVideoPlayerPage> createState() => _CommVideoPlayerPageState();
}

class _CommVideoPlayerPageState extends State<CommVideoPlayerPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    controller.initialize().then((_) {
      setState(() {});
      controller.setLooping(true);
      controller.play();
    });

    eventBus.on<VideoPlayerPauseEvent>().listen((e) {
      controller.pause();
    });

    eventBus.on<VideoPlayerPlayEvent>().listen((e) {
      controller.play();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : const CircularProgressIndicator(),
      // 显示加载进度
    );
  }
}

class VideoPlayerPauseEvent {
  VideoPlayerPauseEvent();
}

class VideoPlayerPlayEvent {
  VideoPlayerPlayEvent();
}
