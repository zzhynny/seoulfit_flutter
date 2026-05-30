import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum MascotVariant { full, chip, loading }

class MascotWidget extends StatefulWidget {
  final double size;
  final MascotVariant variant;

  const MascotWidget({
    super.key,
    this.size = 120,
    this.variant = MascotVariant.full,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _float = Tween(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == MascotVariant.chip) return _buildChip();
    return AnimatedBuilder(
      animation: _float,
      builder: (ctx, _) => Transform.translate(
        offset: Offset(0, -_float.value),
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MascotPainter(
            showLoader: widget.variant == MascotVariant.loading,
          ),
        ),
      ),
    );
  }

  Widget _buildChip() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kYellowLight,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: kYellow, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(painter: _MascotPainter(mini: true)),
          ),
          const SizedBox(width: 6),
          Text(
            'SeoulFit Buddy',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: kInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final bool mini;
  final bool showLoader;

  _MascotPainter({this.mini = false, this.showLoader = false});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    if (mini) {
      _drawBody(canvas, s, 0, 0);
      return;
    }

    // Cloud/paper-airplane platform
    _drawCloud(canvas, s);

    // Body (yellow)
    _drawBody(canvas, s, 0, -s * 0.12);

    // Mint scarf
    _drawScarf(canvas, s, -s * 0.12);

    if (showLoader) {
      _drawLoadingDots(canvas, s);
    }
  }

  void _drawCloud(Canvas canvas, double s) {
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    // Airplane body
    final planePaint = Paint()..color = kMint;
    final path = Path()
      ..moveTo(s * 0.1, s * 0.78)
      ..lineTo(s * 0.5, s * 0.68)
      ..lineTo(s * 0.9, s * 0.78)
      ..lineTo(s * 0.5, s * 0.74)
      ..close();
    canvas.drawPath(path, planePaint);

    // Wing
    final wing = Path()
      ..moveTo(s * 0.5, s * 0.68)
      ..lineTo(s * 0.7, s * 0.62)
      ..lineTo(s * 0.65, s * 0.72)
      ..close();
    canvas.drawPath(wing, planePaint..color = kMintLight);

    // Cloud puffs
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawCircle(Offset(s * 0.25, s * 0.82), s * 0.08, cloudPaint);
    canvas.drawCircle(Offset(s * 0.38, s * 0.78), s * 0.1, cloudPaint);
    canvas.drawCircle(Offset(s * 0.52, s * 0.82), s * 0.09, cloudPaint);
    canvas.drawCircle(Offset(s * 0.64, s * 0.78), s * 0.1, cloudPaint);
    canvas.drawCircle(Offset(s * 0.76, s * 0.82), s * 0.08, cloudPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.17, s * 0.79, s * 0.66, s * 0.1),
        const Radius.circular(8),
      ),
      cloudPaint,
    );
  }

  void _drawBody(Canvas canvas, double s, double dx, double dy) {
    final bodyPaint = Paint()..color = kYellow;
    final cx = s * 0.5 + dx;
    final cy = s * 0.42 + dy;

    // Main body - rounded egg shape
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: s * 0.46, height: s * 0.54),
      bodyPaint,
    );

    // Head highlight
    canvas.drawCircle(
      Offset(cx - s * 0.06, cy - s * 0.12),
      s * 0.06,
      Paint()..color = Colors.white.withOpacity(0.35),
    );

    // Eyes
    final eyePaint = Paint()..color = kInk;
    canvas.drawCircle(Offset(cx - s * 0.08, cy - s * 0.06), s * 0.028, eyePaint);
    canvas.drawCircle(Offset(cx + s * 0.08, cy - s * 0.06), s * 0.028, eyePaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - s * 0.07, cy - s * 0.08), s * 0.01, shinePaint);
    canvas.drawCircle(Offset(cx + s * 0.09, cy - s * 0.08), s * 0.01, shinePaint);

    // Cheek blush
    final blushPaint = Paint()..color = Colors.orange.withOpacity(0.25);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx - s * 0.14, cy + s * 0.02),
          width: s * 0.1,
          height: s * 0.06),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx + s * 0.14, cy + s * 0.02),
          width: s * 0.1,
          height: s * 0.06),
      blushPaint,
    );

    // Beak
    final beakPaint = Paint()..color = const Color(0xFFFF8C00);
    final beak = Path()
      ..moveTo(cx - s * 0.04, cy + s * 0.06)
      ..lineTo(cx + s * 0.04, cy + s * 0.06)
      ..lineTo(cx, cy + s * 0.12)
      ..close();
    canvas.drawPath(beak, beakPaint);

    // Wings
    final wingPaint = Paint()..color = kYellow.withOpacity(0.85);
    final leftWing = Path()
      ..moveTo(cx - s * 0.22, cy + s * 0.02)
      ..quadraticBezierTo(cx - s * 0.3, cy + s * 0.1, cx - s * 0.2, cy + s * 0.18)
      ..quadraticBezierTo(cx - s * 0.14, cy + s * 0.22, cx - s * 0.13, cy + s * 0.1)
      ..close();
    canvas.drawPath(leftWing, wingPaint);

    final rightWing = Path()
      ..moveTo(cx + s * 0.22, cy + s * 0.02)
      ..quadraticBezierTo(cx + s * 0.3, cy + s * 0.1, cx + s * 0.2, cy + s * 0.18)
      ..quadraticBezierTo(cx + s * 0.14, cy + s * 0.22, cx + s * 0.13, cy + s * 0.1)
      ..close();
    canvas.drawPath(rightWing, wingPaint);

    // Feet
    final feetPaint = Paint()
      ..color = const Color(0xFFFF8C00)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - s * 0.08, cy + s * 0.25), Offset(cx - s * 0.13, cy + s * 0.3), feetPaint);
    canvas.drawLine(Offset(cx - s * 0.08, cy + s * 0.25), Offset(cx - s * 0.04, cy + s * 0.31), feetPaint);
    canvas.drawLine(Offset(cx + s * 0.08, cy + s * 0.25), Offset(cx + s * 0.04, cy + s * 0.31), feetPaint);
    canvas.drawLine(Offset(cx + s * 0.08, cy + s * 0.25), Offset(cx + s * 0.13, cy + s * 0.3), feetPaint);
  }

  void _drawScarf(Canvas canvas, double s, double dy) {
    final cx = s * 0.5;
    final cy = s * 0.48 + dy;

    final scarfPaint = Paint()..color = kMint;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - s * 0.2, cy, s * 0.4, s * 0.06),
        const Radius.circular(4),
      ),
      scarfPaint,
    );
    // Scarf tail
    final tail = Path()
      ..moveTo(cx + s * 0.12, cy + s * 0.02)
      ..lineTo(cx + s * 0.22, cy + s * 0.1)
      ..lineTo(cx + s * 0.18, cy + s * 0.06)
      ..lineTo(cx + s * 0.2, cy + s * 0.06)
      ..lineTo(cx + s * 0.16, cy + s * 0.02)
      ..close();
    canvas.drawPath(tail, scarfPaint);

    // Scarf stripe
    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(cx - s * 0.15, cy + s * 0.03),
      Offset(cx + s * 0.1, cy + s * 0.03),
      stripePaint,
    );
  }

  void _drawLoadingDots(Canvas canvas, double s) {
    final dotPaint = Paint()..color = kMint;
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(s * 0.35 + i * s * 0.15, s * 0.88),
        s * 0.04,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}