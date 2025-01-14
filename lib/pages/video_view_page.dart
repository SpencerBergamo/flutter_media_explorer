import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/providers/media_pageview_provider.dart';
import 'package:flutter_media_explorer/widgets/video_controls.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({
    super.key,
    required this.media,
    required this.mediaPageviewProvider,
  });

  final Media media;
  final MediaPageviewProvider mediaPageviewProvider;

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  Media get media => widget.media;
  MediaPageviewProvider get provider => widget.mediaPageviewProvider;
  VideoPlayerController? get controller => provider.videoController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MediaState>(
      valueListenable: provider.stateOfMedia,
      builder: (context, state, _) {
        if (state == MediaState.playVideo && controller != null) {
          return _videoPlayerBuilder();
        }

        return CachedNetworkImage(
          imageUrl: media.thumbUrl,
          fit: BoxFit.contain,
          imageBuilder: (context, imgProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imgProvider,
                fit: BoxFit.contain,
              ),
            ),
            child: Center(
              child: state == MediaState.loading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 80,
                      color: Colors.white,
                      onPressed: () {
                        provider.initVideoPlayerController(media.downloadUrl);
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget _videoPlayerBuilder() {
    final vdController = provider.videoController!;
    final animController = provider.animationController;

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: vdController.value.aspectRatio,
          child: VideoPlayer(vdController),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: ValueNotifier(provider.showControls),
          builder: (context, showControls, _) {
            return AnimatedOpacity(
              opacity: showControls ? 1.0 : 0.0,
              duration: animController.duration!,
              child: IconButton(
                icon: Icon(
                  vdController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: provider.playPauseVideo,
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: 10,
          right: 10,
          child: VideoControls(
            videoPlayerController: vdController,
            animationController: animController,
          ),
        ),
      ],
    );
  }
}
