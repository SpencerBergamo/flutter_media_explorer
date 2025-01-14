import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:video_player/video_player.dart';

enum MediaState { thumbnail, loading, playVideo, error }

class MediaPageviewProvider extends ChangeNotifier {
  final List<Media> mediaList;
  final PageController pageController;
  final AnimationController animationController; // for AppBar & Video Controls
  final TransformationController transformationController; // for Zoom Controls
  final TickerProvider vsync;

  MediaPageviewProvider({
    required this.mediaList,
    required int initialPage,
    required this.vsync,
  })  : pageController = PageController(initialPage: initialPage),
        transformationController = TransformationController(),
        animationController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 200),
        ),
        currentIndex = initialPage {
    transformationController.addListener(_onZoomChanged);
  }

  bool isZoomed = false;
  bool showControls = true;
  int currentIndex;

  ValueNotifier<MediaState> stateOfMedia = ValueNotifier(MediaState.thumbnail);
  VideoPlayerController? videoController;

  void toggleControls() {
    showControls = !showControls;

    if (showControls) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    notifyListeners();
  }

  void pageChanged(int page) {
    videoController?.dispose();
    currentIndex = page;

    notifyListeners();
  }

  void doubleTapToZoom() {
    if (mediaList[currentIndex].type == MediaType.video) return;

    isZoomed = !isZoomed;
    if (isZoomed) {
      transformationController.value = Matrix4.identity();
    } else {
      transformationController.value = Matrix4.identity();
    }

    notifyListeners();
  }

  void _onZoomChanged() {
    final scale = transformationController.value.getMaxScaleOnAxis();
    isZoomed = scale > 1.0;

    notifyListeners();
  }

  Future<void> initVideoPlayerController(String url) async {
    if (videoController != null) return;

    stateOfMedia.value = MediaState.loading;
    notifyListeners();

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize().whenComplete(() {
      controller.play();
      videoController = controller;
      stateOfMedia.value = MediaState.playVideo;
      Timer(const Duration(seconds: 2), () {
        showControls = false;
        animationController.reverse();
        notifyListeners();
      });
      notifyListeners();
    }).catchError((e) {
      stateOfMedia.value = MediaState.error;
      notifyListeners();
    });
  }

  void playPauseVideo() {
    if (videoController == null) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
      toggleControls();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    transformationController.dispose();
    animationController.dispose();
    videoController?.dispose();

    super.dispose();
  }
}
