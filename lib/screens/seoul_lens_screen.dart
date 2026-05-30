import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class SeoulLensScreen extends StatefulWidget {
  const SeoulLensScreen({super.key});

  @override
  State<SeoulLensScreen> createState() => _SeoulLensScreenState();
}

class _SeoulLensScreenState extends State<SeoulLensScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanCtrl;
  bool _isPlaying = false;
  double _playProgress = 0.32;
  bool _sheetExpanded = true;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final sheetH = _sheetExpanded ? screenH * 0.52 : screenH * 0.25;

    return Scaffold(
      body: Stack(
        children: [
          // Camera background — DDP-inspired gradient
          Positioned.fill(child: _DDPBackground()),
          // Status bar
          SafeArea(
            child: Column(
              children: [
                const AppStatusBar(dark: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.camera_alt_rounded,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 5),
                          Text('Seoul Lens',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: kMint.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(children: [
                          const Icon(Icons.verified_rounded,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('Seoul Open Data',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AR scan frame
          Center(
            child: AnimatedBuilder(
              animation: _scanCtrl,
              builder: (_, __) => CustomPaint(
                size: const Size(220, 220),
                painter: _ScanFramePainter(
                    scanProgress: _scanCtrl.value),
              ),
            ),
          ),
          // AR detected label
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('DDP Detected · 98% confidence',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
          // Glassmorphism bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (d) {
                if (d.delta.dy < -5) setState(() => _sheetExpanded = true);
                if (d.delta.dy > 5) setState(() => _sheetExpanded = false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: sheetH,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                        color: kMint.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, -8)),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: kCardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location info
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dongdaemun Design Plaza',
                                        style: GoogleFonts.plusJakartaSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: kInk),
                                      ),
                                      Text('DDP · Dongdaemun-gu, Seoul',
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12, color: kSubtext)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: kMintLight,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.star_rounded,
                                        size: 13, color: kMint),
                                    const SizedBox(width: 3),
                                    Text('4.8',
                                        style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: kMint)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Info chips row
                            Wrap(spacing: 8, runSpacing: 6, children: const [
                              _InfoChip(
                                  Icons.access_time_rounded,
                                  '10:00 AM – 10:00 PM',
                                  kMintLight,
                                  kMint),
                              _InfoChip(
                                  Icons.directions_subway_rounded,
                                  'DDP Station (Line 2/4/5)',
                                  kCanvas,
                                  kSubtext),
                              _InfoChip(
                                  Icons.location_on_rounded,
                                  '281 Eulji-ro, Seoul',
                                  kCanvas,
                                  kSubtext),
                            ]),
                            const SizedBox(height: 14),
                            // Gemini docent text
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: kCanvas,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kCardBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: kMintLight,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Row(children: [
                                        const Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 11,
                                            color: kMint),
                                        const SizedBox(width: 4),
                                        Text('Gemini Docent',
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: kMint)),
                                      ]),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: kYellowLight,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text('CC',
                                          style:
                                              GoogleFonts.plusJakartaSans(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(
                                                      0xFFD97706))),
                                    ),
                                  ]),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Designed by the legendary architect Zaha Hadid, the DDP opened in 2014 as one of the world\'s largest asymmetric buildings. Its futuristic curves house cutting-edge exhibitions, fashion shows, and design events, making it a symbol of Seoul\'s creative evolution...',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: kInk,
                                        height: 1.55),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Audio player
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: kCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kCardBorder),
                                boxShadow: [
                                  BoxShadow(
                                      color: kMint.withOpacity(0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4))
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.library_music_rounded,
                                          size: 16,
                                          color: kMint),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'DDP Audio Guide — English',
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: kInk),
                                        ),
                                      ),
                                      Text('3:42',
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              color: kSubtext)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Scrubber
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: kMint,
                                      inactiveTrackColor: kMintLight,
                                      thumbColor: kMint,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                      trackHeight: 3,
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 12),
                                    ),
                                    child: Slider(
                                      value: _playProgress,
                                      onChanged: (v) =>
                                          setState(() => _playProgress = v),
                                      min: 0,
                                      max: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('1:11',
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              color: kSubtext)),
                                      const Spacer(),
                                      Text('-2:31',
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              color: kSubtext)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.replay_10_rounded,
                                            color: kSubtext,
                                            size: 24),
                                        onPressed: () {},
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => setState(
                                            () => _isPlaying = !_isPlaying),
                                        child: Container(
                                          width: 52,
                                          height: 52,
                                          decoration: const BoxDecoration(
                                              color: kMint,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            _isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.forward_10_rounded,
                                            color: kSubtext,
                                            size: 24),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    setState(() => _isPlaying = true),
                                icon: const Icon(
                                    Icons.headphones_rounded,
                                    size: 18),
                                label: const Text('Start Full Audio Guide'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kMint,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)),
                                  elevation: 0,
                                  textStyle: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppBottomNav(currentIndex: 2, onTap: (_) {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// DDP background — night cityscape using gradients and shapes
class _DDPBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0E1A),
            Color(0xFF0D1525),
            Color(0xFF0F1E30),
            Color(0xFF122040),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _DDPPainter(),
        child: Container(),
      ),
    );
  }
}

class _DDPPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Night sky stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.6);
    final stars = [
      Offset(w * 0.12, h * 0.08),
      Offset(w * 0.28, h * 0.04),
      Offset(w * 0.45, h * 0.1),
      Offset(w * 0.62, h * 0.06),
      Offset(w * 0.78, h * 0.12),
      Offset(w * 0.88, h * 0.05),
      Offset(w * 0.95, h * 0.15),
      Offset(w * 0.05, h * 0.18),
      Offset(w * 0.35, h * 0.15),
    ];
    for (final s in stars) {
      canvas.drawCircle(s, 1.5, starPaint);
    }

    // DDP building — fluid curved silver structure
    final buildingPaint = Paint()
      ..color = const Color(0xFF1A2744)
      ..style = PaintingStyle.fill;

    // Main DDP curved body
    final ddpPath = Path();
    ddpPath.moveTo(w * 0.05, h * 0.72);
    ddpPath.quadraticBezierTo(w * 0.1, h * 0.45, w * 0.25, h * 0.42);
    ddpPath.quadraticBezierTo(w * 0.42, h * 0.38, w * 0.5, h * 0.44);
    ddpPath.quadraticBezierTo(w * 0.62, h * 0.52, w * 0.72, h * 0.48);
    ddpPath.quadraticBezierTo(w * 0.85, h * 0.42, w * 0.95, h * 0.55);
    ddpPath.lineTo(w * 0.95, h * 0.72);
    ddpPath.close();
    canvas.drawPath(ddpPath, buildingPaint);

    // Silver highlight on DDP curves
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.fill;
    final highlight = Path();
    highlight.moveTo(w * 0.1, h * 0.50);
    highlight.quadraticBezierTo(w * 0.3, h * 0.42, w * 0.5, h * 0.48);
    highlight.quadraticBezierTo(w * 0.65, h * 0.52, w * 0.8, h * 0.47);
    highlight.quadraticBezierTo(w * 0.65, h * 0.54, w * 0.5, h * 0.52);
    highlight.quadraticBezierTo(w * 0.3, h * 0.48, w * 0.1, h * 0.55);
    highlight.close();
    canvas.drawPath(highlight, highlightPaint);

    // Building windows / LED strips
    final ledPaint = Paint()
      ..color = kMint.withOpacity(0.5)
      ..strokeWidth = 1;
    for (double i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(w * (0.15 + i * 0.12), h * 0.58),
        Offset(w * (0.22 + i * 0.12), h * 0.55),
        ledPaint,
      );
    }

    // Yellow accent lights
    final yellowLed = Paint()
      ..color = kYellow.withOpacity(0.45)
      ..strokeWidth = 1;
    for (double i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(w * (0.20 + i * 0.15), h * 0.64),
        Offset(w * (0.28 + i * 0.15), h * 0.61),
        yellowLed,
      );
    }

    // Reflection on ground
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          kMint.withOpacity(0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.7, w, h * 0.3));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.7, w, h * 0.3), reflectionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanFramePainter extends CustomPainter {
  final double scanProgress;
  _ScanFramePainter({required this.scanProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kMint
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 28.0;
    final w = size.width;
    final h = size.height;

    // Corner brackets
    // Top-left
    canvas.drawLine(Offset(0, corner), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(corner, 0), paint);
    // Top-right
    canvas.drawLine(Offset(w - corner, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, corner), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h - corner), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(corner, h), paint);
    // Bottom-right
    canvas.drawLine(Offset(w - corner, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - corner), paint);

    // Scan line
    final scanY = h * scanProgress;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          kMint.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, scanY - 1, w, 3));
    canvas.drawLine(Offset(0, scanY), Offset(w, scanY), scanPaint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter old) =>
      old.scanProgress != scanProgress;
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color color;
  const _InfoChip(this.icon, this.label, this.bgColor, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCardBorder),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11, fontWeight: FontWeight.w500, color: kInk)),
      ]),
    );
  }
}