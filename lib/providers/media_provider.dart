import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';

class MediaProvider extends ChangeNotifier {
  static final MediaProvider _instance = MediaProvider._internal();
  factory MediaProvider() => _instance;
  MediaProvider._internal();

  final List<Media> _media = [];
  List<Media> get media => _media;

  // For Testing Purposes
  void setMedia(List<Media> media) {
    _media.clear();
    _media.addAll(media);

    notifyListeners();
  }

  /// Media Provider to provide methods for cloud storage operations
  ///
  /// void fetchMedia() {}
  ///
  /// void uploadMedia() {}
  ///
  /// void deleteMedia() {}

  void refreshMedia() {}
}
