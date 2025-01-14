import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/main.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/providers/media_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockMediaProvider extends Mock implements MediaProvider {
  @override
  List<Media> get media =>
      super.noSuchMethod(Invocation.getter(#media), returnValue: <Media>[])
          as List<Media>;
}

void main() {
  testWidgets("Renders GridView W/ Test Data", (WidgetTester tester) async {
    final mediaList = await tester.runAsync(() async {
      final String jsonData =
          await DefaultAssetBundle.of(tester.binding.rootElement!)
              .loadString("test/assets/test_data.json");
      final List<dynamic> decodedData = json.decode(jsonData);
      final List<Media> list =
          decodedData.map((map) => Media.fromMap(map)).toList();

      return list;

      // return (json.decode(data) as List<dynamic>)
      //     .map((map) => Media.fromMap(map))
      //     .toList();
    });

    if (mediaList == null || mediaList.isEmpty) {
      fail("JSON data is empty");
    }

    final MockMediaProvider mockProvider = MockMediaProvider();
    // when(mockProvider.media).thenReturn(jsonData);
    when(mockProvider.media).thenAnswer((_) => mediaList);

    debugPrint("\nMockProvider List: ${mockProvider.media.toList()}\n");

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MediaProvider>.value(value: mockProvider),
        ],
        child: const MyApp(),
      ),
    );

    // expect(find.byType(Image), findsWidgets);
    expect(find.byType(Scrollbar), findsOneWidget);
    debugPrint(json.runtimeType as String?);
  });
}
