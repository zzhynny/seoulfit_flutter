import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/mascot_widget.dart';

class ItineraryGenerationScreen extends StatefulWidget {
  const ItineraryGenerationScreen({super.key});

  @override
  State<ItineraryGenerationScreen> createState() =>
      _ItineraryGenerationScreenState();
}

class _ItineraryGenerationScreenState extends State<ItineraryGenerationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  static const _steps = [
    'Connecting to Seoul Course Catalogue...',
    'Searching via FAISS vector index...',
    'Retrieving top-k matched courses...',
    'Ranking by purpose-fit score...',
    'Drafting 1st itinerary...',
  ];
  int _stepIndex = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4));
    _progress = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.forward();
    _ctrl.addListener(() {
      final s = (_ctrl.value * _steps.length).floor().clamp(0, _steps.length - 1);
      if (s != _stepIndex) setState(() => _stepIndex = s);
    });
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.pushNamed(context, '/critic-repair');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCanvas,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const MascotWidget(size: 110, variant: MascotVariant.loading),
                    const SizedBox(height: 20),
                    Text(
                      'Generating Your Itinerary',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kInk),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        _steps[_stepIndex],
                        key: ValueKey(_stepIndex),
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, color: kMint),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress bar
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (_, __) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: kMintLight,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: _progress.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kMint,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(_progress.value * 100).toInt()}%',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kMint),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Draft itinerary skeleton
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '1st Raw Draft Preview',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kSubtext),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DayHeader(day: 'Day 1', date: 'Hongdae Area'),
                    ..._day1Places.map((p) => _SkeletonPlaceCard(place: p)),
                    const SizedBox(height: 12),
                    _DayHeader(day: 'Day 2', date: 'Seongsu Area'),
                    ..._day2Places.map((p) => _SkeletonPlaceCard(place: p)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            AppBottomNav(currentIndex: 0, onTap: (_) {}),
          ],
        ),
      ),
    );
  }

  static const _day1Places = [
    _PlaceData('Cafe Bora', '9:00 AM', 'Cafe'),
    _PlaceData('Sangsang Madang', '11:00 AM', 'K-POP'),
    _PlaceData('Hongik University Street', '1:00 PM', 'Shopping'),
    _PlaceData('Vinyl & Plastic (HYBE)', '3:00 PM', 'K-POP'),
  ];

  static const _day2Places = [
    _PlaceData('Blue Bottle Coffee Seongsu', '9:30 AM', 'Cafe'),
    _PlaceData('Daelim Warehouse', '11:30 AM', 'Art'),
    _PlaceData('Seongsu Hangang Park', '2:00 PM', 'Park'),
  ];
}

class _PlaceData {
  final String name;
  final String time;
  final String tag;
  const _PlaceData(this.name, this.time, this.tag);
}

class _DayHeader extends StatelessWidget {
  final String day;
  final String date;
  const _DayHeader({required this.day, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: kMint, borderRadius: BorderRadius.circular(50)),
          child: Text(day,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Text(date,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: kInk)),
      ]),
    );
  }
}

class _SkeletonPlaceCard extends StatelessWidget {
  final _PlaceData place;
  const _SkeletonPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.45,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kCardBorder),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: kMintLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.place_rounded, color: kMint, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(place.name,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kInk)),
              Text(place.time,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: kSubtext)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: kMintLight, borderRadius: BorderRadius.circular(20)),
            child: Text(place.tag,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: kMint)),
          ),
        ]),
      ),
    );
  }
}