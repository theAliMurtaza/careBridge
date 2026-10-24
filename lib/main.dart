import 'package:flutter/material.dart';
import 'ui.dart';
import 'dashboard.dart';
import 'pages.dart';

void main() => runApp(const CareBridgeApp());

class CareBridgeApp extends StatelessWidget {
  const CareBridgeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CareBridge AI',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Arial',
      colorScheme: ColorScheme.fromSeed(
        seedColor: teal,
        primary: teal,
        surface: Colors.white,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Arial',
        bodyColor: ink,
        displayColor: ink,
      ),
      dividerColor: line,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: line),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: canvas,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
      ),
    ),
    home: const AppShell(),
  );
}

class Reading {
  Reading(this.type, this.value, this.unit, this.date);
  final String type, value, unit;
  final DateTime date;
}

class Appointment {
  Appointment(this.doctor, this.specialty, this.date, this.time);
  final String doctor, specialty, time;
  final DateTime date;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int page = 0;
  int water = 5;
  double sleep = 7.5;
  double movement = 25;
  final habits = <String, bool>{
    'Morning walk': true,
    'Mindful moment': false,
    'Evening wind-down': false,
  };
  final medications = <String, bool>{
    'Vitamin D3': false,
    'Daily multivitamin': true,
  };
  final readings = <Reading>[];
  final appointments = <Appointment>[];
  final messages = <ChatMessage>[];
  static const names = [
    'Overview',
    'AI assistant',
    'My health',
    'Daily care',
    'Appointments',
  ];
  static const icons = [
    Icons.grid_view_rounded,
    Icons.auto_awesome_outlined,
    Icons.favorite_border_rounded,
    Icons.spa_outlined,
    Icons.calendar_month_outlined,
  ];

  void navigate(int index) => setState(() => page = index);
  void notify(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
  Future<void> addReading() async {
    final result = await showDialog<Reading>(
      context: context,
      builder: (_) => const ReadingDialog(),
    );
    if (result != null && mounted) {
      setState(() => readings.insert(0, result));
      notify('Reading added to your session.');
    }
  }

  Future<void> bookAppointment() async {
    final result = await showDialog<Appointment>(
      context: context,
      builder: (_) => const AppointmentDialog(),
    );
    if (result != null && mounted) {
      setState(() => appointments.add(result));
      notify('Demo appointment added. No booking has been sent.');
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final desktop = constraints.maxWidth >= 1050;
      final wide = constraints.maxWidth >= 760;
      final content = switch (page) {
        0 => Dashboard(
          onNavigate: navigate,
          onAddReading: addReading,
          water: water,
          onWater: () => setState(() {
            if (water < 8) water++;
          }),
          medications: medications,
          onMedication: (key) =>
              setState(() => medications[key] = !medications[key]!),
          readings: readings,
          appointments: appointments,
          onBook: bookAppointment,
        ),
        1 => AssistantPage(
          messages: messages,
          onSend: (text) => setState(() {
            messages.add(ChatMessage(text, true));
            messages.add(ChatMessage(demoReply(text), false));
          }),
        ),
        2 => HealthPage(readings: readings, onAdd: addReading),
        3 => CarePage(
          sleep: sleep,
          movement: movement,
          onSleep: (value) => setState(() => sleep = value),
          onMovement: (value) => setState(() => movement = value),
          water: water,
          onWater: (value) => setState(() => water = value.clamp(0, 8)),
          habits: habits,
          onHabit: (key) => setState(() => habits[key] = !habits[key]!),
          medications: medications,
          onMedication: (key) =>
              setState(() => medications[key] = !medications[key]!),
        ),
        _ => AppointmentsPage(
          appointments: appointments,
          onBook: bookAppointment,
          onCancel: (item) => setState(() => appointments.remove(item)),
        ),
      };
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (desktop) sidebar(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 82,
                      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: line)),
                      ),
                      child: Row(
                        children: [
                          if (!desktop) ...[
                            const Icon(
                              Icons.health_and_safety_rounded,
                              color: teal,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              desktop ? names[page] : 'CareBridge',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          if (wide) const Tag('DEMO WORKSPACE'),
                          const SizedBox(width: 14),
                          IconButton(
                            tooltip: 'Notifications',
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('You’re all caught up'),
                                content: const Text(
                                  'This is a frontend preview. Medication reminders, health alerts, and push notifications will appear here after the backend is connected.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Got it'),
                                  ),
                                ],
                              ),
                            ),
                            icon: const Badge(
                              smallSize: 5,
                              backgroundColor: coral,
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFF2E5D8),
                            child: Text(
                              'JD',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8C7056),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (wide) ...[
                            const SizedBox(width: 10),
                            const Text(
                              'Jamie Davis',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey(page),
                        padding: EdgeInsets.all(wide ? 32 : 20),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1450),
                            child: content,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: desktop
            ? null
            : NavigationBar(
                selectedIndex: page,
                onDestinationSelected: navigate,
                backgroundColor: Colors.white,
                indicatorColor: mint,
                destinations: List.generate(
                  5,
                  (i) => NavigationDestination(
                    icon: Icon(icons[i], size: 23),
                    label: ['Home', 'Assistant', 'Health', 'Care', 'Visits'][i],
                  ),
                ),
              ),
      );
    },
  );

  Widget sidebar() => Container(
    width: 228,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(right: BorderSide(color: line)),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 38,
                  decoration: BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.health_and_safety_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CareBridge',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.8,
                      ),
                    ),
                  ),
                ),
                const Text(
                  ' AI',
                  style: TextStyle(
                    fontSize: 10,
                    color: teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 46, top: 4),
              child: Text(
                'A little care. Every day.',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ),
            const SizedBox(height: 47),
            const Padding(
              padding: EdgeInsets.only(left: 14, bottom: 16),
              child: Text(
                'YOUR WORKSPACE',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (var i = 0; i < names.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Material(
                  color: page == i ? mint : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(11),
                    onTap: () => navigate(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icons[i],
                            color: page == i ? teal : muted,
                            size: 20,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Text(
                              names[i],
                              style: TextStyle(
                                color: page == i ? teal : ink,
                                fontSize: 12,
                                fontWeight: page == i
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (i == 1) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.circle, color: coral, size: 6),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: canvas,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite_outline, color: teal, size: 23),
                  const SizedBox(height: 11),
                  const Text(
                    'Care that grows with you',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Small steps today. A healthier you tomorrow.',
                    style: TextStyle(fontSize: 11, color: muted, height: 1.6),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => navigate(3),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Explore daily care  →',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Row(
              children: [
                Icon(Icons.shield_outlined, size: 15, color: muted),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your health. Your space.',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
