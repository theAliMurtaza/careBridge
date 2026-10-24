import 'package:flutter/material.dart';
import 'main.dart' show Reading, Appointment;
import 'dashboard.dart' show shortDate;
import 'ui.dart';

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key, this.action});
  final String title, subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 26),
    child: Wrap(
      spacing: 24,
      runSpacing: 18,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 29,
                letterSpacing: -.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: muted, height: 1.7),
            ),
          ],
        ),
        ?action,
      ],
    ),
  );
}

class ChatMessage {
  ChatMessage(this.text, this.isUser);
  final String text;
  final bool isUser;
}

String demoReply(String text) {
  return 'This is a preview of the CareBridge conversation experience. Your message has not been sent to an AI or a clinician.\n\nIn the connected version, you’ll be able to discuss symptoms, explore trusted health information, and choose which records to share. For now, try logging a reading in My health or checking in with Daily care.';
}

class AssistantPage extends StatefulWidget {
  const AssistantPage({
    super.key,
    required this.messages,
    required this.onSend,
  });
  final List<ChatMessage> messages;
  final ValueChanged<String> onSend;
  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final controller = TextEditingController();
  final latest = GlobalKey();
  void send([String? prompt]) {
    final value = (prompt ?? controller.text).trim();
    if (value.isEmpty) return;
    widget.onSend(value);
    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (latest.currentContext != null) {
        Scrollable.ensureVisible(
          latest.currentContext!,
          duration: const Duration(milliseconds: 250),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const PageHeading(
        'A little clarity. A little care.',
        'Your space for health questions and thoughtful conversations.',
      ),
      Panel(
        color: mint,
        padding: 18,
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 19, color: teal),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Interactive preview · Replies are scripted, not AI-generated. This experience does not provide medical advice or emergency care. No records are shared.',
                style: TextStyle(fontSize: 12, height: 1.6, color: teal),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                IconTile(Icons.auto_awesome_outlined),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CareBridge assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Here to help you understand',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ],
                  ),
                ),
                Tag('PREVIEW'),
              ],
            ),
            const SizedBox(height: 32),
            if (widget.messages.isEmpty) ...[
              const Text(
                'What’s on your mind?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Start with a question, or choose a place to begin.',
                style: TextStyle(fontSize: 13, color: muted),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final item in [
                    'I’d like to discuss my symptoms',
                    'Help me understand a report',
                    'Let’s talk about my daily habits',
                  ])
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 16, color: teal),
                      label: Text(item, style: const TextStyle(fontSize: 12)),
                      onPressed: () => send(item),
                    ),
                ],
              ),
              const SizedBox(height: 50),
            ],
            for (final message in widget.messages)
              Align(
                alignment: message.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 620),
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: message.isUser ? teal : canvas,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : ink,
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            Row(
              key: latest,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 2000,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(
                      hintText: 'Write your question…',
                      counterText: '',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  tooltip: 'Send message',
                  onPressed: send,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Avoid entering private medical information in this demo.',
              style: TextStyle(fontSize: 10, color: muted),
            ),
          ],
        ),
      ),
    ],
  );
}

class ReadingDialog extends StatefulWidget {
  const ReadingDialog({super.key});
  @override
  State<ReadingDialog> createState() => _ReadingDialogState();
}

class _ReadingDialogState extends State<ReadingDialog> {
  static const units = {
    'Heart rate': 'bpm',
    'Blood pressure': 'mmHg',
    'Blood oxygen': '%',
    'Blood glucose': 'mg/dL',
    'Temperature': '°C',
    'Weight': 'kg',
  };
  final form = GlobalKey<FormState>();
  final value = TextEditingController();
  String type = 'Heart rate';
  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  String? validate(String? raw) {
    final text = (raw ?? '').trim();
    if (type == 'Blood pressure') {
      final match = RegExp(r'^(\d{2,3})\s*/\s*(\d{2,3})$').firstMatch(text);
      if (match == null) return 'Enter systolic/diastolic, for example 118/78.';
      final systolic = int.parse(match[1]!);
      final diastolic = int.parse(match[2]!);
      if (systolic <= diastolic || systolic > 350 || diastolic < 20) {
        return 'Check the two values and their order.';
      }
    } else {
      final number = double.tryParse(text);
      final max = switch (type) {
        'Heart rate' => 350,
        'Blood oxygen' => 100,
        'Blood glucose' => 1500,
        'Temperature' => 50,
        _ => 700,
      };
      if (number == null || !number.isFinite || number <= 0 || number > max) {
        return 'Enter a number greater than 0 and up to $max.';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Log a health reading'),
    scrollable: true,
    content: SizedBox(
      width: 400,
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record a measurement for this demo session.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            DropdownButtonFormField<String>(
              initialValue: type,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Measurement'),
              items: units.keys
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (item) => setState(() {
                type = item!;
                value.clear();
              }),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: value,
              keyboardType: type == 'Blood pressure'
                  ? TextInputType.text
                  : const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: type == 'Blood pressure'
                    ? 'Systolic / diastolic'
                    : 'Value',
                suffixText: units[type],
              ),
              validator: validate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),
            const Text(
              'Values are recorded without clinical interpretation. Use your device’s stated units.',
              style: TextStyle(fontSize: 11, color: muted, height: 1.6),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Navigator.pop(
              context,
              Reading(
                type,
                value.text.trim().replaceAll(' ', ''),
                units[type]!,
                DateTime.now(),
              ),
            );
          }
        },
        child: const Text('Save reading'),
      ),
    ],
  );
}

class HealthPage extends StatefulWidget {
  const HealthPage({super.key, required this.readings, required this.onAdd});
  final List<Reading> readings;
  final VoidCallback onAdd;
  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  int tab = 0;
  String filter = 'All measurements';
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PageHeading(
        'Your health, in one place.',
        'Keep track of your readings and understand your records.',
        action: AppButton(
          'Log a reading',
          onPressed: widget.onAdd,
          icon: Icons.add,
        ),
      ),
      Wrap(
        spacing: 10,
        children: List.generate(
          3,
          (i) => ChoiceChip(
            label: Text(
              ['Vital signs', 'Medical reports', 'Privacy & access'][i],
            ),
            selected: tab == i,
            selectedColor: mint,
            showCheckmark: false,
            onSelected: (_) => setState(() => tab = i),
          ),
        ),
      ),
      const SizedBox(height: 24),
      if (tab == 0) ...[
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Reading history'),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                initialValue: filter,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Filter readings'),
                items: ['All measurements', ..._ReadingDialogState.units.keys]
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => filter = value!),
              ),
              const SizedBox(height: 20),
              if (widget.readings
                  .where(
                    (r) => filter == 'All measurements' || r.type == filter,
                  )
                  .isEmpty)
                emptyState(
                  Icons.monitor_heart_outlined,
                  'Your next step starts here',
                  'No readings yet for this view. Add a measurement\nto start your personal health history.',
                ),
              for (final reading in widget.readings.where(
                (r) => filter == 'All measurements' || r.type == filter,
              ))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      const IconTile(Icons.monitor_heart_outlined),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reading.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${shortDate(reading.date)} · ${TimeOfDay.fromDateTime(reading.date).format(context)}',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${reading.value} ${reading.unit}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Panel(
          color: mint,
          padding: 18,
          child: Row(
            children: [
              Icon(Icons.bluetooth, color: teal),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Device connections are coming later. For this preview, enter readings manually.',
                  style: TextStyle(fontSize: 12, height: 1.6, color: teal),
                ),
              ),
            ],
          ),
        ),
      ],
      if (tab == 1) ...[
        const Panel(
          color: mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.upload_file_outlined, color: teal, size: 30),
              SizedBox(height: 16),
              Text(
                'Your reports, made understandable',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'PDF and image upload, OCR, and AI analysis will be available after secure storage and the backend are connected. Explore the sample report below.',
                style: TextStyle(fontSize: 13, color: muted, height: 1.7),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Tag('FICTIONAL SAMPLE'),
              const SizedBox(height: 18),
              const SectionTitle('Laboratory report preview'),
              const SizedBox(height: 8),
              const Text(
                'Example Laboratory · Reference ranges supplied by this sample lab',
                style: TextStyle(fontSize: 11, color: muted),
              ),
              const SizedBox(height: 20),
              reportRow('Test', 'Result', 'Lab range', header: true),
              reportRow('Hemoglobin', '14.2 g/dL', '12.0–16.0'),
              reportRow('Vitamin D', '18 ng/mL', '20–50', flagged: true),
              reportRow('Platelets', '250 ×10³/µL', '150–400'),
              const SizedBox(height: 24),
              const Text(
                'What is highlighted',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 9),
              const Text(
                'The sample vitamin D result falls below the reference interval printed on this fictional report. A lab flag alone does not establish a diagnosis.',
                style: TextStyle(fontSize: 12, height: 1.7, color: muted),
              ),
              const SizedBox(height: 20),
              const Text(
                'Questions for your consultation',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 9),
              const Text(
                'How does this result fit with my history?\nDo I need any follow-up testing?\nCould my current medicines affect the results?',
                style: TextStyle(fontSize: 12, height: 1.9, color: muted),
              ),
            ],
          ),
        ),
      ],
      if (tab == 2)
        const Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(Icons.shield_outlined),
              SizedBox(height: 20),
              Text(
                'You decide what you share',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 14),
              Text(
                'This frontend preview keeps entries in memory for the current session. Closing or reloading the app clears them. It has no authentication, cloud storage, clinician access, or record sharing.\n\nThe connected version will need sign-in, encryption, explicit sharing consent, and access controls before it can be used with real medical records.',
                style: TextStyle(fontSize: 13, height: 1.8, color: muted),
              ),
              SizedBox(height: 18),
              Tag('NO RECORDS SHARED'),
            ],
          ),
        ),
    ],
  );
  Widget reportRow(
    String title,
    String value,
    String range, {
    bool header = false,
    bool flagged = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: BoxDecoration(
      color: flagged
          ? const Color(0xFFFBF0E9)
          : header
          ? canvas
          : Colors.white,
      border: const Border(bottom: BorderSide(color: line)),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: header ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: flagged ? const Color(0xFFA9623D) : ink,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            range,
            style: const TextStyle(fontSize: 11, color: muted),
          ),
        ),
      ],
    ),
  );
}

Widget emptyState(IconData icon, String title, String subtitle) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 35),
  child: Center(
    child: Column(
      children: [
        IconTile(icon, size: 56),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: muted, height: 1.7),
        ),
      ],
    ),
  ),
);

class CarePage extends StatefulWidget {
  const CarePage({
    super.key,
    required this.water,
    required this.onWater,
    required this.habits,
    required this.onHabit,
    required this.medications,
    required this.onMedication,
    required this.sleep,
    required this.movement,
    required this.onSleep,
    required this.onMovement,
  });
  final int water;
  final double sleep, movement;
  final ValueChanged<double> onSleep, onMovement;
  final ValueChanged<int> onWater;
  final Map<String, bool> habits, medications;
  final ValueChanged<String> onHabit, onMedication;
  @override
  State<CarePage> createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {
  String diet = 'Balanced';
  int tab = 0;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const PageHeading(
        'Small steps. Lasting habits.',
        'Build a daily rhythm that feels good for you.',
      ),
      Wrap(
        spacing: 10,
        children: List.generate(
          3,
          (i) => ChoiceChip(
            label: Text(['Lifestyle', 'Medications', 'Meal inspiration'][i]),
            selected: tab == i,
            showCheckmark: false,
            selectedColor: mint,
            onSelected: (_) => setState(() => tab = i),
          ),
        ),
      ),
      const SizedBox(height: 24),
      if (tab == 0) ...[
        LayoutBuilder(
          builder: (context, box) => Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: box.maxWidth > 700
                    ? (box.maxWidth - 20) / 2
                    : box.maxWidth,
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IconTile(Icons.water_drop_outlined),
                      const SizedBox(height: 20),
                      const SectionTitle('A moment to hydrate'),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.water} / 8 glasses',
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      LinearProgressIndicator(
                        value: widget.water / 8,
                        minHeight: 8,
                        backgroundColor: mint,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          IconButton.outlined(
                            tooltip: 'Remove a glass',
                            onPressed: widget.water > 0
                                ? () => widget.onWater(widget.water - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          AppButton(
                            'Add a glass',
                            onPressed: () => widget.onWater(widget.water + 1),
                            icon: Icons.add,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Example goal only. Individual fluid needs vary.',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: box.maxWidth > 700
                    ? (box.maxWidth - 20) / 2
                    : box.maxWidth,
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IconTile(
                        Icons.bedtime_outlined,
                        background: Color(0xFFEEEAF5),
                        color: Color(0xFF9A88B4),
                      ),
                      const SizedBox(height: 20),
                      const SectionTitle('Rest & movement'),
                      const SizedBox(height: 10),
                      Text(
                        'Sleep · ${widget.sleep.toStringAsFixed(1)} hours',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Slider(
                        value: widget.sleep,
                        min: 0,
                        max: 16,
                        divisions: 32,
                        label: '${widget.sleep.toStringAsFixed(1)} hours',
                        onChanged: widget.onSleep,
                      ),
                      Text(
                        'Movement · ${widget.movement.round()} minutes',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Slider(
                        value: widget.movement,
                        min: 0,
                        max: 180,
                        divisions: 36,
                        label: '${widget.movement.round()} minutes',
                        onChanged: widget.onMovement,
                      ),
                      const Text(
                        'Adjust to log today’s routine in this view.',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Make a little time for yourself'),
              const SizedBox(height: 16),
              for (final entry in widget.habits.entries)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: entry.value,
                  onChanged: (_) => widget.onHabit(entry.key),
                  title: Text(entry.key, style: const TextStyle(fontSize: 14)),
                  subtitle: Text(
                    entry.value ? 'Complete for today' : 'At your own pace',
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                  secondary: Icon(
                    entry.key == 'Morning walk'
                        ? Icons.directions_walk
                        : entry.key == 'Mindful moment'
                        ? Icons.self_improvement
                        : Icons.nights_stay_outlined,
                    color: teal,
                  ),
                ),
            ],
          ),
        ),
      ],
      if (tab == 1)
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Your daily medication checklist'),
              const SizedBox(height: 12),
              const Text(
                'Sample entries illustrate adherence tracking. They are not prescriptions or recommendations. Follow your clinician’s instructions.',
                style: TextStyle(fontSize: 12, color: muted, height: 1.7),
              ),
              const SizedBox(height: 22),
              for (final item in widget.medications.entries)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const IconTile(Icons.medication_outlined),
                  title: Text(item.key),
                  subtitle: Text(
                    item.value
                        ? 'Marked as taken today · Demo'
                        : 'Not yet marked · Demo',
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                  value: item.value,
                  onChanged: (_) => widget.onMedication(item.key),
                ),
              const SizedBox(height: 20),
              const Tag('PUSH REMINDERS NOT CONNECTED'),
            ],
          ),
        ),
      if (tab == 2) ...[
        const Panel(
          color: mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.restaurant_outlined, color: teal, size: 30),
              SizedBox(height: 15),
              Text(
                'Something good on your plate',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Browse sample meal ideas. These are not personalized diet plans. Medical restrictions and allergies are not evaluated in this preview.',
                style: TextStyle(fontSize: 12, color: muted, height: 1.7),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: [
            for (final option in ['Balanced', 'Vegetarian', 'Plant-based'])
              ChoiceChip(
                label: Text(option),
                selected: diet == option,
                showCheckmark: false,
                selectedColor: mint,
                onSelected: (_) => setState(() => diet = option),
              ),
          ],
        ),
        const SizedBox(height: 20),
        for (final meal in <(String, String, String, IconData)>[
          (
            'BREAKFAST',
            'Berry & oat breakfast bowl',
            'Oats · berries · seeds',
            Icons.breakfast_dining_outlined,
          ),
          (
            'LUNCH',
            diet == 'Balanced'
                ? 'Chicken & garden grain bowl'
                : 'Chickpea & garden grain bowl',
            'Brown rice · vegetables · lemon dressing',
            Icons.lunch_dining_outlined,
          ),
          (
            'DINNER',
            diet == 'Balanced'
                ? 'Baked fish & roasted vegetables'
                : diet == 'Vegetarian'
                ? 'Paneer & roasted vegetables'
                : 'Tofu & roasted vegetables',
            'Seasonal vegetables · herbs · whole grains',
            Icons.dinner_dining_outlined,
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Panel(
              child: Row(
                children: [
                  IconTile(
                    meal.$4,
                    size: 54,
                    background: const Color(0xFFF3EFE5),
                    color: const Color(0xFFA79067),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.$1,
                          style: const TextStyle(
                            fontSize: 9,
                            color: teal,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          meal.$2,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          meal.$3,
                          style: const TextStyle(fontSize: 11, color: muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ],
  );
}

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({super.key});
  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  String specialty = 'General consultation';
  DateTime date = DateUtils.dateOnly(
    DateTime.now(),
  ).add(const Duration(days: 1));
  String time = '09:00 AM';
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Plan a consultation'),
    content: SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Tag('DEMO BOOKING'),
            const SizedBox(height: 14),
            const Text(
              'Try the appointment flow. No clinician is contacted and no real slot is reserved.',
              style: TextStyle(fontSize: 12, color: muted, height: 1.7),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: specialty,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Consultation type'),
              items: [
                'General consultation',
                'Nutrition consultation',
                'Follow-up visit',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => specialty = v!),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateUtils.dateOnly(DateTime.now());
                final chosen = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: now.add(const Duration(days: 1)),
                  lastDate: now.add(const Duration(days: 365)),
                );
                if (chosen != null && mounted) setState(() => date = chosen);
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text('${shortDate(date)}, ${date.year}'),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: time,
              decoration: const InputDecoration(
                labelText: 'Preferred time (local)',
              ),
              items: [
                '09:00 AM',
                '10:30 AM',
                '02:00 PM',
                '04:30 PM',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => time = v!),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(
          context,
          Appointment('Demo care team', specialty, date, time),
        ),
        child: const Text('Add demo visit'),
      ),
    ],
  );
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({
    super.key,
    required this.appointments,
    required this.onBook,
    required this.onCancel,
  });
  final List<Appointment> appointments;
  final VoidCallback onBook;
  final ValueChanged<Appointment> onCancel;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PageHeading(
        'Care, on your calendar.',
        'Make space for a conversation with your care team.',
        action: AppButton('Plan a visit', onPressed: onBook, icon: Icons.add),
      ),
      const Panel(
        color: mint,
        padding: 18,
        child: Row(
          children: [
            Icon(Icons.info_outline, color: teal, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Appointments are local previews. Scheduling, record sharing, and clinician messaging are not connected.',
                style: TextStyle(fontSize: 12, color: teal, height: 1.7),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      if (appointments.isEmpty)
        Panel(
          child: Column(
            children: [
              emptyState(
                Icons.calendar_month_outlined,
                'A little planning goes a long way',
                'Your upcoming consultations will appear here.',
              ),
              AppButton(
                'Add your first demo visit',
                onPressed: onBook,
                icon: Icons.add,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      for (final item in appointments)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const IconTile(Icons.person_outline, size: 52),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.specialty,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.doctor,
                            style: const TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const Tag('DEMO'),
                  ],
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    Text(
                      '${shortDate(item.date)}, ${item.date.year}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(item.time, style: const TextStyle(fontSize: 13)),
                    const Text(
                      'Time on your device',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => onCancel(item),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Remove demo visit'),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
