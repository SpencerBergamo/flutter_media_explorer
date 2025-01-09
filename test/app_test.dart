import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_media_explorer/models/media_model.dart';
import 'package:flutter_media_explorer/pages/home_page.dart';
import 'package:flutter_media_explorer/providers/media_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockMediaProvider extends Mock implements MediaProvider {}

void main() {
  testWidgets("Renders GridView W/ Test Data", (WidgetTester tester) async {
    final jsonData = await tester.runAsync(() async {
      final data = await DefaultAssetBundle.of(tester.binding.rootElement!)
          .loadString("test/assets/test_data.json");

      if (data.isEmpty) {
        fail("Failed to load JSON data");
      }

      return (json.decode(data) as List<dynamic>)
          .map((item) => Media.fromMap(item))
          .toList();
    });

    final mockProvider = MockMediaProvider();
    when(mockProvider.media).thenReturn(jsonData!);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MediaProvider>.value(value: mockProvider),
        ],
        child: const HomePage(),
      ),
    );

    expect(find.byType(GridView), findsOneWidget);
    // expect(find.byType(Image), findsWidgets);
  });
}
