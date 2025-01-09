import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/providers/media_pageview_provider.dart';
import 'package:flutter_media_explorer/widgets/video_controls.dart';
import 'package:video_player/video_player.dart';

class MediaItemExpanded extends StatefulWidget {
  const MediaItemExpanded({
    super.key,
    required this.media,
    required this.provider,
  });

  final Media media;
  final MediaPageviewProvider provider;

  @override
  State<MediaItemExpanded> createState() => _MediaItemExpandedState();
}

class _MediaItemExpandedState extends State<MediaItemExpanded> {
  Media get media => widget.media;
  bool get isVideo => widget.media.type == MediaType.video;
  MediaPageviewProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    if (provider.videoController != null) {
      return _videoPlayerBuilder(provider.videoController!);
    }

    return Hero(
      tag: media.docId,
      child: InteractiveViewer(
        maxScale: 5.0,
        minScale: 0.1,
        transformationController: provider.transformationController,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(media.thumbUrl),
              fit: BoxFit.contain,
            ),
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: provider.loadingVideo,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return isVideo
                  ? IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 50,
                      color: Colors.white,
                      onPressed: () =>
                          provider.initVideoPlayerController(media.downloadUrl),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _videoPlayerBuilder(VideoPlayerController controller) {
    controller.play();

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Positioned(
          bottom: 60 + kBottomNavigationBarHeight,
          left: 10,
          right: 10,
          child: VideoControls(
            videoPlayerController: controller,
            animationController: provider.animationController,
            isVisible: provider.showControls,
          ),
        ),
      ],
    );
  }
}
