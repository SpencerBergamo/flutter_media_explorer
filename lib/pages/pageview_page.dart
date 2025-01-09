import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/providers/media_pageview_provider.dart';
import 'package:flutter_media_explorer/widgets/animated_navbars.dart';
import 'package:flutter_media_explorer/widgets/media_item_expanded.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
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
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MediaPageviewProvider(
        mediaList: widget.mediaList,
        dragToPopDirection: DragToPopDirection.vertical,
        initialPage: widget.initialPage,
        vsync: this,
      ),
      child: Consumer<MediaPageviewProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AnimatedAppBar(
              appBar: AppBar(
                title: Text(
                  "${provider.currentIndex + 1} / ${provider.mediaList.length}",
                ),
              ),
              animationController: provider.animationController,
              isVisible: provider.showControls,
            ),
            body: OverscrollPop(
              enable: !provider.isZoomed,
              dragToPopDirection: provider.dragToPopDirection,
              child: GestureDetector(
                onTap: provider.toggleControls,
                onDoubleTap: provider.doubleTapToZoom,
                child: PageView.builder(
                  controller: provider.pageController,
                  itemCount: provider.mediaList.length,
                  onPageChanged: (page) => provider.pageChanged(page),
                  physics: provider.isZoomed
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MediaItemExpanded(
                      media: provider.mediaList[index],
                      provider: provider,
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: AnimatedBottomAppBar(
              bottomAppBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              animationController: provider.animationController,
              isVisible: provider.showControls,
            ),
          );
        },
      ),
    );
  }

  // Widget _mediaItem(Media media) {
  //   return Hero();
  // }
}
