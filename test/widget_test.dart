import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carebridge_ai/main.dart';
import 'package:carebridge_ai/pages.dart';

Future<void> openApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const CareBridgeApp());
  await tester.pumpAndSettle();
}

void main() {
  for (final width in [360.0, 390.0, 768.0, 1440.0]) {
    testWidgets('dashboard and pages fit a $width pixel viewport', (
      tester,
    ) async {
      await openApp(tester, Size(width, 900));
      expect(find.text('A little better, every day.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      for (final label
          in width >= 1050
              ? ['AI assistant', 'My health', 'Daily care', 'Appointments']
              : ['Assistant', 'Health', 'Care', 'Visits']) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$label at $width');
      }
    });
  }

  testWidgets('reading form rejects invalid data and saves to history', (
    tester,
  ) async {
    await openApp(tester, const Size(390, 844));
    await tester.tap(find.text('Log a reading'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '-2');
    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();
    expect(
      find.text('Enter a number greater than 0 and up to 350.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextFormField), '76');
    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();
    expect(find.text('76'), findsOneWidget);
    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();
    expect(find.text('76 bpm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'assistant responds honestly and keeps conversation on navigation',
    (tester) async {
      await openApp(tester, const Size(390, 844));
      await tester.tap(find.text('Assistant'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'How does this work?');
      await tester.ensureVisible(find.byTooltip('Send message'));
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(find.text('How does this work?'), findsOneWidget);
      expect(
        find.textContaining('Your message has not been sent'),
        findsOneWidget,
      );
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Assistant'));
      await tester.pumpAndSettle();
      expect(find.text('How does this work?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('demo appointments can be added and removed', (tester) async {
    await openApp(tester, const Size(390, 844));
    await tester.tap(find.text('Visits'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan a visit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add demo visit'));
    await tester.pumpAndSettle();
    expect(find.text('General consultation'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Remove demo visit'));
    await tester.tap(find.text('Remove demo visit'));
    await tester.pumpAndSettle();
    expect(
      find.text('Your upcoming consultations will appear here.'),
      findsOneWidget,
    );
  });

  testWidgets('hydration and medication changes are shared with dashboard', (
    tester,
  ) async {
    await openApp(tester, const Size(1440, 1000));
    await tester.tap(find.text('Daily care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add a glass'));
    await tester.pumpAndSettle();
    expect(find.text('6 / 8 glasses'), findsOneWidget);
    await tester.tap(find.text('Medications'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vitamin D3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Overview').first);
    await tester.pumpAndSettle();
    expect(find.text('6/8'), findsOneWidget);
    expect(find.text('2 of 3'), findsOneWidget);
  });

  testWidgets('blood pressure input requires systolic/diastolic order', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ReadingDialog())),
    );
    await tester.tap(find.text('Heart rate'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blood pressure').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '78/118');
    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();
    expect(find.text('Check the two values and their order.'), findsOneWidget);
  });
}
