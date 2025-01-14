import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/pages/pageview_page.dart';

/// GridViewBuilder is a stateless widget that builds a grid of media items.
///
/// This widget is designed to be stateless because it relies on external state
/// management (provided by MediaProvider) to handle updates to the media list.
/// By keeping this widget stateless, we ensure that it is simple an efficient,
/// only rebuilding when the media list changes.
///
/// Each tile in the grid is assigned a unique key using ValueKey (media.docId). This
/// is important for the following reasons:
///
/// 1. **Efficien Updates:** Keys help Flutter efficiently update the list when
///    changes occur, such as when items are added, removed, or reordered. This
///    prevents unnecessary rebuilds of the entire list, improving performance.
/// 2. **State Preservation:** Keys ensure that the state of each tile is preserved
///    correctly. When the media list is updated, Flutter can match the keys of the
///    existing tiles with the new tiles, maintaining the state of each tile.
///
/// The GridViewBuilder widget is a reusable widget that can be used in multiple
/// parts of the application to display a grid of media items. It is designed to be
/// flexible and customizable, allowing for different configurations of the grid.

class GridViewBuilder extends StatelessWidget {
  const GridViewBuilder({
    super.key,
    required this.media,
    this.physics,
    this.shrinkWrap = false,
    // this.animationDuration = const Duration(milliseconds: 300),
  });

  final List<Media> media;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  // final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const PageStorageKey('media_grid'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: media.length,
      itemBuilder: (context, index) {
        final Media currentMedia = media[index];
        final bool isVideo = media[index].type == MediaType.video;

        return Material(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                opaque: true,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return PageviewPage(mediaList: media, initialPage: index);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(currentMedia.thumbUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: isVideo ? _durationBuilder(currentMedia) : null,
            ),
          ),
        );
      },
    );
  }

  Container _durationBuilder(Media media) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.center,
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          media.formattedDuration,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
