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

class Media {
  final String docId;
  final String downloadUrl;
  final String thumbUrl;
  final MediaType type;

  Media({
    required this.docId,
    required this.downloadUrl,
    required this.thumbUrl,
    required this.type,
  });

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      docId: map['docId'] as String,
      downloadUrl: map['downloadUrl'] as String,
      thumbUrl: map['thumbUrl'] as String,
      type: MediaType.fromString(map['type'] as String),
    );
  }
}
