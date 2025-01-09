import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/pages/home_page.dart';
import 'package:flutter_media_explorer/providers/media_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initiate Test Data for App
  final String data = await rootBundle.loadString("test/assets/test_data.json");
  final List<dynamic> jsonData = json.decode(data);
  final List<Media> mediaList =
      jsonData.map((media) => Media.fromMap(media)).toList();

  MediaProvider().setMedia(mediaList);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MediaProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Media Explorer', home: HomePage());
  }
}
