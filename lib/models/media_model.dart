enum MediaType {
  image,
  video;

  static MediaType fromString(String type) {
    switch (type) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      default:
        throw Exception('Unknown media type: $type');
    }
  }
}

extension on Duration {
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (inSeconds < 3600) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class Media {
  final String docId;
  final String downloadUrl;
  final String thumbUrl;
  final MediaType type;
  final int width;
  final int height;
  final Duration? duration;

  Media({
    required this.docId,
    required this.downloadUrl,
    required this.thumbUrl,
    required this.type,
    required this.width,
    required this.height,
    this.duration,
  }) {
    if (type == MediaType.video && duration == null) {
      throw ArgumentError("Video media must have a duration");
    }
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      docId: map['docId'] as String,
      downloadUrl: map['downloadUrl'] as String,
      thumbUrl: map['thumbUrl'] as String,
      type: MediaType.fromString(map['type'] as String),
      width: map['width'] as int,
      height: map['height'] as int,
      duration: map['duration'] != null
          ? Duration(seconds: map['duration'] as int)
          : null,
    );
  }

  String get formattedDuration => duration?.toFormattedString() ?? '';
}
