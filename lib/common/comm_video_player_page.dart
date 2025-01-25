import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CommVideoPlayerController extends GetxController {
  late VideoPlayerController controller;
  CommVideoPlayerController({required String videoUrl}) {
    controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

class CommVideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const CommVideoPlayerPage({super.key, required this.videoUrl});

  @override
  State<CommVideoPlayerPage> createState() => _CommVideoPlayerPageState();
}

class _CommVideoPlayerPageState extends State<CommVideoPlayerPage> {
  late final _logic =
      Get.put(CommVideoPlayerController(videoUrl: widget.videoUrl));

  @override
  void initState() {
    super.initState();
    _logic.controller.initialize().then((_) {
      setState(() {});
      _logic.controller.setLooping(true);
      _logic.controller.play();
    });
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _logic.controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _logic.controller.value.aspectRatio,
              child: VideoPlayer(_logic.controller),
            )
          : const CircularProgressIndicator(),
      // 显示加载进度
    );
  }
}
