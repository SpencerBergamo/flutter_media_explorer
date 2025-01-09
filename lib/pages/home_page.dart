import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/providers/media_provider.dart';
import 'package:flutter_media_explorer/widgets/grid_view_builder.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Media Explorer"),
        centerTitle: true,
      ),
      body: Consumer<MediaProvider>(
        builder: (context, provider, child) {
          final List<Media> media = provider.media;

          if (media.isEmpty) {
            return const Center(
              child: Text("No media available."),
            );
          }

          return Scrollbar(
            thumbVisibility: true,
            child: RefreshIndicator(
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                provider.refreshMedia();
              },
              child: GridViewBuilder(media: media),
            ),
          );
        },
      ),
    );
  }
}
