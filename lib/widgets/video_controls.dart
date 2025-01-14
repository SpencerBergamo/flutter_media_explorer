import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

extension on Duration {
  String get timestamp =>
      "${inMinutes.toString().padLeft(2, '0')}:${(inSeconds % 60).toString().padLeft(2, '0')}";
}

class VideoControls extends StatefulWidget {
  const VideoControls({
    super.key,
    required this.videoPlayerController,
    required this.animationController,
    // required this.provider,
    // required this.isVisible,
  });

  // final MediaPageviewProvider provider;
  final VideoPlayerController videoPlayerController;
  final AnimationController animationController;
  // final bool isVisible;

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  VideoPlayerController get controller => widget.videoPlayerController;
  VideoPlayerValue get video => controller.value;
  AnimationController get animationController => widget.animationController;

  void listener() => setState(() {});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  void initState() {
    controller.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // isVisible ? animationController.reverse() : animationController.forward();
    final Duration currentPosition = controller.value.position;
    final Duration totalDuration = controller.value.duration;

    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      )),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatDuration(currentPosition)),
              Expanded(
                child: Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.seekTo(Duration(seconds: value.toInt()));
                  },
                  // activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.5),
                ),
              ),
              Text(formatDuration(totalDuration)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }
}
