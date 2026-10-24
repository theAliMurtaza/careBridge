import 'package:flutter/material.dart';
import 'main.dart' show Reading, Appointment;
import 'ui.dart';

String shortDate(DateTime date) =>
    '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.day}';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    required this.onNavigate,
    required this.onAddReading,
    required this.water,
    required this.onWater,
    required this.medications,
    required this.onMedication,
    required this.readings,
    required this.appointments,
    required this.onBook,
  });
  final ValueChanged<int> onNavigate;
  final VoidCallback onAddReading, onWater, onBook;
  final int water;
  final Map<String, bool> medications;
  final ValueChanged<String> onMedication;
  final List<Reading> readings;
  final List<Appointment> appointments;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int chart = 0;
  bool month = false;
  String reading(String type, String fallback) {
    final matches = widget.readings.where((item) => item.type == type);
    return matches.isEmpty ? fallback : matches.first.value;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR EVERYDAY HEALTH COMPANION',
                style: TextStyle(
                  color: teal.withValues(alpha: .8),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.7,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'A little better, every day.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome back, Jamie. Let’s make room for your wellbeing.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: widget.onAddReading,
            icon: const Icon(Icons.add, size: 17),
            label: const Text('Log a reading', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      const SizedBox(height: 26),
      LayoutBuilder(
        builder: (context, box) => box.maxWidth > 850
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: mainColumn()),
                  const SizedBox(width: 24),
                  Expanded(flex: 3, child: sideColumn()),
                ],
              )
            : Column(
                children: [
                  mainColumn(),
                  const SizedBox(height: 24),
                  sideColumn(),
                ],
              ),
      ),
      const SizedBox(height: 24),
      const Center(
        child: Text(
          'Made for your wellbeing  ·  Demo data, for preview only  ·  Changes reset when the app restarts',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 10, height: 1.6),
        ),
      ),
    ],
  );

  Widget mainColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE4EEE5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            children: [
              if (box.maxWidth > 490)
                const Positioned(
                  right: -12,
                  bottom: -8,
                  width: 220,
                  height: 220,
                  child: CustomPaint(painter: BotanicalPainter()),
                ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: SizedBox(
                  width: box.maxWidth > 490 ? box.maxWidth - 225 : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 15, color: teal),
                          SizedBox(width: 7),
                          Text(
                            'A SPACE TO CHECK IN',
                            style: TextStyle(
                              fontSize: 9,
                              color: teal,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'How are you\nfeeling today?',
                        style: TextStyle(
                          fontSize: 29,
                          height: 1.15,
                          letterSpacing: -.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'A question, a concern, or a small win.\nYour health companion is here to listen.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF648073),
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AppButton(
                        'Let’s check in',
                        onPressed: () => widget.onNavigate(1),
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 25),
      SectionTitle(
        'Your health at a glance',
        action: 'View all',
        onTap: () => widget.onNavigate(2),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, box) {
          final count = box.maxWidth > 550 ? 3 : (box.maxWidth > 340 ? 2 : 1);
          final width = (box.maxWidth - 12 * (count - 1)) / count;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: width,
                child: vital(
                  'Heart rate',
                  reading('Heart rate', '72'),
                  'bpm',
                  Icons.favorite_outline,
                  coral,
                  const Color(0xFFFBEEE8),
                  [.4, .5, .45, .8, .5, .6, .5, .65],
                ),
              ),
              SizedBox(
                width: width,
                child: vital(
                  'Blood pressure',
                  reading('Blood pressure', '118/78'),
                  'mmHg',
                  Icons.monitor_heart_outlined,
                  teal,
                  mint,
                  [.6, .5, .7, .55, .65, .5, .65, .55],
                ),
              ),
              SizedBox(
                width: width,
                child: vital(
                  'Blood oxygen',
                  reading('Blood oxygen', '98'),
                  '%',
                  Icons.water_drop_outlined,
                  const Color(0xFF7C91B6),
                  const Color(0xFFEDF1F8),
                  [.5, .6, .5, .7, .6, .75, .65, .75],
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 24),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'The bigger picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.4,
                    ),
                  ),
                ),
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 10)),
                  ),
                  segments: const [
                    ButtonSegment(value: false, label: Text('Week')),
                    ButtonSegment(value: true, label: Text('Month')),
                  ],
                  selected: {month},
                  onSelectionChanged: (value) =>
                      setState(() => month = value.first),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              children: List.generate(
                3,
                (i) => ChoiceChip(
                  label: Text(
                    ['Heart rate', 'Blood pressure', 'Weight'][i],
                    style: const TextStyle(fontSize: 10),
                  ),
                  selected: chart == i,
                  showCheckmark: false,
                  selectedColor: mint,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: chart == i ? mint : line),
                  onSelected: (_) => setState(() => chart = i),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ['72', '118/78', '68.4'][chart],
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 5),
                  child: Text(
                    ['bpm', 'mmHg', 'kg'][chart],
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                ),
                const Spacer(),
                const Tag('SAMPLE TREND'),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Illustrative data · not a clinical assessment',
              style: TextStyle(color: muted, fontSize: 10),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 140,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final label
                          in (chart == 0
                              ? ['100', '80', '60', '40']
                              : chart == 1
                              ? ['140', '120', '100', '80']
                              : ['72', '70', '68', '66']))
                        Text(
                          label,
                          style: const TextStyle(fontSize: 9, color: muted),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomPaint(
                      size: const Size(double.infinity, 140),
                      painter: TrendPainter(
                        grid: true,
                        values: month
                            ? [.4, .6, .5, .3, .5, .7, .6, .4, .6, .55, .65, .5]
                            : chart == 0
                            ? [.45, .55, .35, .68, .58, .72, .53]
                            : chart == 1
                            ? [.55, .65, .45, .6, .4, .55, .5]
                            : [.7, .65, .67, .5, .55, .4, .4],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final day
                      in (month
                          ? ['Week 1', 'Week 2', 'Week 3', 'Week 4']
                          : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']))
                    Text(
                      day,
                      style: const TextStyle(fontSize: 9, color: muted),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      SectionTitle(
        'A little support goes a long way',
        action: 'Explore',
        onTap: () => widget.onNavigate(1),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, box) => Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: box.maxWidth > 500
                  ? (box.maxWidth - 14) / 2
                  : box.maxWidth,
              child: actionCard(
                'Understand your reports',
                'Make sense of the numbers,\none result at a time.',
                Icons.description_outlined,
                const Color(0xFFF2EEE6),
                () => widget.onNavigate(2),
              ),
            ),
            SizedBox(
              width: box.maxWidth > 500
                  ? (box.maxWidth - 14) / 2
                  : box.maxWidth,
              child: actionCard(
                'Eat well, feel well',
                'Find a little inspiration\nfor your next meal.',
                Icons.restaurant_outlined,
                const Color(0xFFEDF0E7),
                () => widget.onNavigate(3),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget vital(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
    Color bg,
    List<double> values,
  ) => Panel(
    padding: 17,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconTile(icon, size: 32, color: color, background: bg),
            const Spacer(),
            const Icon(Icons.north_east, color: muted, size: 14),
          ],
        ),
        const SizedBox(height: 15),
        Text(label, style: const TextStyle(fontSize: 11, color: muted)),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 4,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                letterSpacing: -.8,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: const TextStyle(fontSize: 9, color: muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 30,
          width: double.infinity,
          child: CustomPaint(
            painter: TrendPainter(values: values, color: color),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.readings.any((r) => r.type == label)
              ? 'Latest session reading'
              : 'Sample reading',
          style: const TextStyle(fontSize: 9, color: muted),
        ),
      ],
    ),
  );

  Widget actionCard(
    String title,
    String subtitle,
    IconData icon,
    Color bg,
    VoidCallback action,
  ) => InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(22),
    child: Panel(
      padding: 19,
      color: bg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: teal, size: 23),
                const SizedBox(height: 17),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_outward, color: teal, size: 18),
        ],
      ),
    ),
  );

  Widget sideColumn() => Column(
    children: [
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your daily rhythm',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.4,
                    ),
                  ),
                ),
                Text(
                  shortDate(DateTime.now()),
                  style: const TextStyle(fontSize: 10, color: muted),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 135,
                height: 135,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 135,
                      height: 135,
                      child: CircularProgressIndicator(
                        value:
                            (widget.medications.values.where((v) => v).length +
                                (widget.water >= 8 ? 1 : 0)) /
                            3,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: mint,
                        color: teal,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.medications.values.where((v) => v).length + (widget.water >= 8 ? 1 : 0)} of 3',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'daily goals complete',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Every small step counts.',
                style: TextStyle(fontSize: 11, color: muted),
              ),
            ),
            const SizedBox(height: 22),
            const Divider(height: 1),
            const SizedBox(height: 19),
            Row(
              children: [
                const IconTile(
                  Icons.water_drop_outlined,
                  size: 34,
                  background: Color(0xFFEDF1F8),
                  color: Color(0xFF7C91B6),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Stay hydrated',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${widget.water}/8',
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                8,
                (i) => Icon(
                  Icons.water_drop_rounded,
                  size: 21,
                  color: i < widget.water ? const Color(0xFF7E9BB6) : line,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.water >= 8 ? null : widget.onWater,
                icon: const Icon(Icons.add, size: 14),
                label: Text(
                  widget.water >= 8 ? 'Daily goal complete' : 'Add a glass',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      Panel(
        padding: 21,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              'Today’s reminders',
              action: 'All',
              onTap: () => widget.onNavigate(3),
            ),
            const SizedBox(height: 9),
            const Text(
              'SAMPLE ROUTINE',
              style: TextStyle(fontSize: 9, letterSpacing: 1, color: muted),
            ),
            const SizedBox(height: 13),
            for (final entry in widget.medications.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const IconTile(
                      Icons.medication_outlined,
                      size: 34,
                      background: Color(0xFFF5EFE5),
                      color: Color(0xFFB49A70),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            entry.value
                                ? 'Marked as taken'
                                : 'After breakfast · Demo',
                            style: const TextStyle(fontSize: 9, color: muted),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: entry.value,
                      onChanged: (_) => widget.onMedication(entry.key),
                      activeColor: teal,
                      shape: const CircleBorder(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      Panel(
        padding: 21,
        color: const Color(0xFFF0F2EA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 15, color: teal),
                SizedBox(width: 8),
                Text(
                  'UP NEXT',
                  style: TextStyle(
                    fontSize: 9,
                    color: teal,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              widget.appointments.isEmpty
                  ? 'Make time for your health'
                  : widget.appointments.first.doctor,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              widget.appointments.isEmpty
                  ? 'Keep your next consultation\nclose at hand.'
                  : '${shortDate(widget.appointments.first.date)} · ${widget.appointments.first.time}\nDemo appointment',
              style: const TextStyle(fontSize: 11, color: muted, height: 1.7),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: widget.appointments.isEmpty
                  ? widget.onBook
                  : () => widget.onNavigate(4),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                widget.appointments.isEmpty
                    ? 'Plan a visit  →'
                    : 'View appointment  →',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class BotanicalPainter extends CustomPainter {
  const BotanicalPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * .65, size.height * .5),
      90,
      Paint()..color = const Color(0xFFD6E5D6),
    );
    final stem = Paint()
      ..color = const Color(0xFF547F62)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(105, 200)
        ..quadraticBezierTo(110, 100, 159, 25),
      stem,
    );
    canvas.drawPath(
      Path()
        ..moveTo(109, 190)
        ..quadraticBezierTo(75, 140, 45, 105),
      stem,
    );
    for (final leaf in <(double, double, double, Color)>[
      (125, 125, -.6, const Color(0xFF6B9678)),
      (142, 85, -.4, const Color(0xFF96B49A)),
      (118, 157, -.5, const Color(0xFF759E81)),
      (115, 112, 2.7, const Color(0xFFA6BDA0)),
      (134, 70, 2.5, const Color(0xFF6E9476)),
      (76, 147, 2.8, const Color(0xFF92AE8A)),
      (61, 126, -.7, const Color(0xFF5F8D6E)),
    ]) {
      canvas.save();
      canvas.translate(leaf.$1, leaf.$2);
      canvas.rotate(leaf.$3);
      canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(22, -31, 56, -4)
          ..quadraticBezierTo(32, 20, 0, 0),
        Paint()..color = leaf.$4,
      );
      canvas.restore();
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(78, 183, 62, 43),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFFDEBCA2),
    );
    canvas.drawCircle(
      const Offset(45, 62),
      5,
      Paint()..color = const Color(0xFFE8BC88),
    );
    canvas.drawCircle(
      const Offset(181, 157),
      4,
      Paint()..color = const Color(0xFFE8BC88),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
