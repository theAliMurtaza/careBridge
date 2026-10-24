// Optional visual review helper, separate from the regression test suite.
// flutter test tool/render_preview.dart --dart-define=PREVIEW_FONT=/path/to/font.ttf
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carebridge_ai/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final size in [const Size(1440, 1200), const Size(390, 844)]) {
    testWidgets('render ${size.width.toInt()} pixel preview', (tester) async {
      await tester.runAsync(() async {
        const fontPath = String.fromEnvironment('PREVIEW_FONT');
        if (fontPath.isNotEmpty) {
          for (final family in ['Arial', 'Roboto']) {
            final loader = FontLoader(family);
            loader.addFont(
              File(fontPath).readAsBytes().then(ByteData.sublistView),
            );
            await loader.load();
          }
        }
        final icons = FontLoader('MaterialIcons');
        icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
      });
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundaryKey, child: const CareBridgeApp()),
      );
      await tester.pumpAndSettle();
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final folder = Directory('build/previews');
        await folder.create(recursive: true);
        await File(
          '${folder.path}/dashboard-${size.width.toInt()}.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      expect(tester.takeException(), isNull);
    });
  }
}
