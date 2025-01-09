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
    required this.isVisible,
  });

  final VideoPlayerController videoPlayerController;
  final AnimationController animationController;
  final bool isVisible;

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  VideoPlayerController get controller => widget.videoPlayerController;
  VideoPlayerValue get video => controller.value;
  AnimationController get animationController => widget.animationController;
  bool get isVisible => widget.isVisible;

  double? seekValue;

  Duration get bufferedPosition =>
      video.buffered.isEmpty ? Duration.zero : video.buffered.last.end;

  bool get isMuted => video.volume == 0;

  String get timestamp {
    final Duration currentPosition =
        seekValue == null ? video.position : doubleToDuration(seekValue!);

    return "${currentPosition.timestamp} / ${video.duration.timestamp}";
  }

  double durationToDouble(Duration duration) => duration.inSeconds.toDouble();

  Duration doubleToDuration(double position) =>
      Duration(minutes: position ~/ 60, seconds: (position % 60).truncate());

  void listener() => setState(() {});

  @override
  void initState() {
    controller.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // isVisible ? animationController.reverse() : animationController.forward();

    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      )),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: SliderComponentShape.noThumb,
                  ),
                  child: Slider(
                    max: durationToDouble(video.duration),
                    value: durationToDouble(video.position),
                    onChanged: null,
                  ),
                ),
                Slider(
                  max: durationToDouble(video.duration),
                  value: seekValue ?? durationToDouble(video.position),
                  onChanged: (value) => setState(() => seekValue = value),
                  onChangeEnd: (value) {
                    setState(() => seekValue = null);
                    controller.seekTo(doubleToDuration(value));
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(video.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (video.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    controller.setVolume(isMuted ? 1.0 : 0.0);
                  },
                ),
                Text(timestamp, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
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
