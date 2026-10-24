# CareBridge AI — Flutter frontend

A responsive healthcare companion preview for Android, iOS, and web. Built with Flutter Material 3, a custom teal-and-cream design system, adaptive navigation, and hand-painted charts and botanical artwork. No runtime packages beyond Flutter are required.

## Run

Requires Flutter with Dart 3.12 or later.

```sh
flutter pub get
flutter run -d chrome
# Or select an Android emulator / iOS simulator:
flutter run
```

Building iOS requires macOS and Xcode. Android requires an Android SDK and a device or emulator.

```sh
flutter analyze
flutter test
flutter build web
```

## Implemented

- Responsive overview, sample trend charts with metric and period selectors, hydration, medication checklist, and upcoming visit summary.
- Assistant conversation UI with explicit scripted preview replies; conversation retained while navigating.
- Validated manual entries for six vital measurements, filterable reading history, and latest readings reflected on the dashboard.
- Fictional laboratory report with lab reference intervals, a flagged value, and consultation questions.
- Daily hydration, sleep, movement, and habit controls; sample medication adherence checklist; meal ideas by dietary preference.
- Demo appointment date, time, and consultation selection, plus appointment removal.
- Privacy and notification screens that accurately describe the disconnected preview.

## Demo boundary

This is a frontend prototype, not a clinical service. Data stays in memory and resets on reload. Dashboard trends and initial metrics are fictional examples, and remain separate from recorded measurements. No API requests, real AI, medical interpretation, actual bookings, authentication, encryption at rest, report uploads, device connections, or push notifications are implemented. Do not enter real medical records.

## Source layout

- `lib/main.dart` — app theme, responsive shell, session models and shared state.
- `lib/ui.dart` — reusable components and chart painter.
- `lib/dashboard.dart` — health overview and illustration.
- `lib/pages.dart` — assistant, readings, report preview, daily care, and appointment flows.
- `test/widget_test.dart` — responsive layout and interaction tests.
- `tool/render_preview.dart` — optional desktop/mobile PNG rendering helper. Run with `flutter test tool/render_preview.dart --dart-define=PREVIEW_FONT=/path/to/font.ttf`; images are written to `build/previews/`.

## Next integration phase

Replace session state with repository-backed state management and typed FastAPI clients. Implement authentication and consent before storing medical records. Connect report storage/OCR, server-side AI/RAG, appointments, BLE, and notifications through dedicated services. Keep OpenAI keys and all other secrets on the backend. Add clinical review and source attribution before presenting personalized medical guidance.
