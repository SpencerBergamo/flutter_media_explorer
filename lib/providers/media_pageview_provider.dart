import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:video_player/video_player.dart';

class MediaPageviewProvider extends ChangeNotifier {
  final List<Media> mediaList;
  final PageController pageController;
  final AnimationController animationController; // for AppBar & Video Controls
  final TransformationController transformationController; // for Zoom Controls
  final DragToPopDirection dragToPopDirection; // Direction to Pop Page
  final TickerProvider vsync;

  bool isZoomed = false;
  bool showControls = true;
  int currentIndex;

  VideoPlayerController? videoController;
  ValueNotifier<bool> loadingVideo = ValueNotifier(false);

  MediaPageviewProvider({
    required this.mediaList,
    required this.dragToPopDirection,
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

  void toggleControls() {
    showControls = !showControls;
    notifyListeners();
  }

  void pageChanged(int page) {
    videoController?.dispose();
    videoController = null;
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

  void initVideoPlayerController(String url) async {
    if (videoController != null) return;

    loadingVideo.value = true;
    notifyListeners();

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    videoController = controller;
    loadingVideo.value = false;

    notifyListeners();
  }

  // Future<VideoPlayerController> getVideoController(String url) async {
  //   if (videoController != null) return videoController!;

  //   final controller = VideoPlayerController.networkUrl(Uri.parse(url));
  //   await controller.initialize();
  //   videoController = controller;

  //   return controller;
  // }

  void playPauseVideo() {
    if (videoController == null) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
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
