import 'package:flutter/material.dart';

const ink = Color(0xFF203B38);
const muted = Color(0xFF81908A);
const teal = Color(0xFF277E70);
const canvas = Color(0xFFF6F8F5);
const line = Color(0xFFE7ECE7);
const mint = Color(0xFFEAF3ED);
const coral = Color(0xFFE99B85);

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 24,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: line),
    ),
    child: Padding(padding: EdgeInsets.all(padding), child: child),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -.4,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Text(action!, style: const TextStyle(fontSize: 12)),
        ),
    ],
  );
}

class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    super.key,
    this.color = teal,
    this.background = mint,
    this.size = 42,
  });
  final IconData icon;
  final Color color, background;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(icon, size: size * .48, color: color),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.color = teal, this.background = mint});
  final String text;
  final Color color, background;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
    ),
  );
}

class TrendPainter extends CustomPainter {
  TrendPainter({required this.values, this.color = teal, this.grid = false});
  final List<double> values;
  final Color color;
  final bool grid;
  @override
  void paint(Canvas canvas, Size size) {
    if (grid) {
      final p = Paint()
        ..color = line
        ..strokeWidth = 1;
      for (var i = 0; i < 4; i++) {
        final y = size.height * i / 3;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
      }
    }
    final points = List.generate(
      values.length,
      (i) => Offset(
        i * size.width / (values.length - 1),
        size.height * (1 - values[i]),
      ),
    );
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1];
      final b = points[i];
      path.cubicTo(
        (a.dx + b.dx) / 2,
        a.dy,
        (a.dx + b.dx) / 2,
        b.dy,
        b.dx,
        b.dy,
      );
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .16), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = grid ? 3 : 2
        ..strokeCap = StrokeCap.round,
    );
    if (grid) {
      canvas.drawCircle(points.last, 5, Paint()..color = color);
      canvas.drawCircle(points.last, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

class AppButton extends StatelessWidget {
  const AppButton(this.label, {super.key, required this.onPressed, this.icon});
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onPressed,
    icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17),
    label: Text(label),
  );
}
