import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/pages/video_view_page.dart';
import 'package:flutter_media_explorer/providers/media_pageview_provider.dart';
import 'package:flutter_media_explorer/widgets/animated_navbars.dart';
import 'package:provider/provider.dart';

class PageviewPage extends StatefulWidget {
  const PageviewPage({
    super.key,
    required this.mediaList,
    required this.initialPage,
  });

  final List<Media> mediaList;
  final int initialPage;

  @override
  State<PageviewPage> createState() => _PageviewPageState();
}

class _PageviewPageState extends State<PageviewPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MediaPageviewProvider(
        mediaList: widget.mediaList,
        initialPage: widget.initialPage,
        vsync: this,
      ),
      child: Consumer<MediaPageviewProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            key: const PageStorageKey("page-view"),
            extendBody: true,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            appBar: AnimatedAppBar(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                toolbarHeight: 40,
                title: Text(
                  "${provider.currentIndex + 1} of ${provider.mediaList.length}",
                ),
                actions: [
                  PopupMenuButton(
                    iconColor: Colors.white,
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enableFeedback: true,
                    onSelected: (value) {
                      switch (value) {
                        case "Save":
                          break;
                        case "Share":
                          break;
                        case "Report":
                          break;
                        case "Delete":
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: "Save",
                          child: Icon(Icons.save_alt),
                        ),
                        const PopupMenuItem(
                          value: "Share",
                          child: Icon(Icons.ios_share),
                        ),
                        const PopupMenuItem(
                          value: "Report",
                          child: Icon(Icons.flag_outlined),
                        ),
                        const PopupMenuItem(
                          value: "Delete",
                          child: Icon(Icons.delete_outline),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              animationController: provider.animationController,
              isVisible: provider.showControls,
            ),
            body: GestureDetector(
              onTap: provider.toggleControls,
              onDoubleTapDown: (details) => provider.doubleTapToZoom(details),
              child: PageView.builder(
                controller: provider.pageController,
                itemCount: provider.mediaList.length,
                onPageChanged: (page) => provider.pageChanged(page),
                physics: provider.isZoomed
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final Media media = provider.mediaList[index];
                  final bool isVideo = media.type == MediaType.video;

                  if (isVideo) {
                    return VideoViewPage(
                      media: media,
                      mediaPageviewProvider: provider,
                    );
                  }

                  return InteractiveViewer(
                    maxScale: 5.0,
                    transformationController: provider.transformationController,
                    child: CachedNetworkImage(
                      imageUrl: media.thumbUrl,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
            // bottomNavigationBar: AnimatedBottomAppBar(
            //   bottomAppBar: BottomAppBar(
            //     child: Row(
            //       children: [
            //         const Expanded(
            //           child: TextField(
            //             decoration: InputDecoration(
            //               contentPadding: EdgeInsets.all(8),
            //               hintText: "Add a comment...",
            //             ),
            //           ),
            //         ),
            //         IconButton(
            //           icon: const Icon(Icons.favorite_border),
            //           onPressed: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            //   animationController: provider.animationController,
            //   isVisible: provider.showControls,
            // ),
          );
        },
      ),
    );
  }
}
