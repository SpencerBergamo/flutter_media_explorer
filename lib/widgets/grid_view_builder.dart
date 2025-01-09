import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/pages/pageview_page.dart';

class GridViewBuilder extends StatelessWidget {
  const GridViewBuilder({super.key, required this.media});
  final List<Media> media;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) {
        final Media currentMedia = media[index];
        final bool isVideo = media[index].type == MediaType.video;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              opaque: true,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PageviewPage(
                mediaList: media,
                initialPage: index,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),
          child: Hero(
            tag: currentMedia.docId,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(currentMedia.thumbUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: isVideo
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          // child: Stack(
          //   children: [
          //     Positioned.fill(
          //       child: Hero(
          //         tag: currentMedia.docId,
          //         child: Image.network(
          //           currentMedia.thumbUrl,
          //           fit: BoxFit.cover,
          //           loadingBuilder: (context, child, loadingProgress) {
          //             if (loadingProgress == null) {
          //               return child;
          //             } else {
          //               return Center(
          //                   child: CircularProgressIndicator(
          //                 value: loadingProgress.expectedTotalBytes != null
          //                     ? loadingProgress.cumulativeBytesLoaded /
          //                         loadingProgress.expectedTotalBytes!
          //                     : null,
          //               ));
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //     if (isVideo)
          //       const Positioned(
          //         bottom: 8,
          //         right: 8,
          //         child: Icon(
          //           Icons.play_arrow,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //   ],
          // ),
        );
      },
    );
  }
}
