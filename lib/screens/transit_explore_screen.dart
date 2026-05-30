import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class TransitExploreScreen extends StatefulWidget {
  const TransitExploreScreen({super.key});

  @override
  State<TransitExploreScreen> createState() => _TransitExploreScreenState();
}

class _TransitExploreScreenState extends State<TransitExploreScreen> {
  int _selectedTab = 0;
  static const _tabs = ['Cafes', 'Food', 'Photo', 'Shop'];

  static const _transitSteps = [
    _TransitStep('Board', 'Line 3 Orange', 'At Hongdae · Platform 2', Color(0xFFD97706)),
    _TransitStep('Transfer', 'Euljiro 3-ga', 'Change to Line 2 Green · Exit 5', Color(0xFF34A853)),
    _TransitStep('Arrive', 'Seongsuigyo', 'Best Exit: Exit 4 · 2 min walk', kMint),
  ];

  static const _cafes = [
    _SpotCard('Blue Bottle Coffee', 'Seongsu-dong', '★ 4.8', '8 min'),
    _SpotCard('Cafe Onion', 'Seongsu-dong', '★ 4.7', '5 min'),
    _SpotCard('Anthracite Coffee', 'Seongsu-dong', '★ 4.6', '12 min'),
    _SpotCard('Fritz Coffee', 'Dorim-ro', '★ 4.7', '15 min'),
  ];

  static const _food = [
    _SpotCard('Gwangjang Market', 'Jongno', '★ 4.8', '22 min'),
    _SpotCard('Seongsu Burger', 'Seongsu-dong', '★ 4.5', '6 min'),
    _SpotCard('Seoul Forest BBQ', 'Seongsu-dong', '★ 4.6', '10 min'),
    _SpotCard('Wangsimni Pork Belly', 'Wangsimni', '★ 4.4', '18 min'),
  ];

  List<_SpotCard> get _currentSpots => _selectedTab == 0 ? _cafes : _food;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text('Transit & Explore',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kInk)),
                    const SizedBox(height: 2),
                    Text('Real-time guide for your journey',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, color: kSubtext)),
                    const SizedBox(height: 16),
                    // Transit card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: kInk,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.directions_subway_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Subway Route',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: kMint.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('~25 min',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: kMint)),
                            ),
                          ]),
                          const SizedBox(height: 14),
                          ...List.generate(_transitSteps.length, (i) =>
                              _TransitStepRow(
                                step: _transitSteps[i],
                                isLast: i == _transitSteps.length - 1,
                              )),
                          const SizedBox(height: 8),
                          Text('💡 Tip: T-money card accepted on all lines',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.6))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Events Near You
                    Row(children: [
                      const Icon(Icons.celebration_rounded,
                          size: 16, color: kMint),
                      const SizedBox(width: 6),
                      Text('Events Near You',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kInk)),
                    ]),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          _EventCard(
                            'K-POP Popup\nToday',
                            'SM Town Coex',
                            '2km away',
                            kYellow,
                          ),
                          SizedBox(width: 10),
                          _EventCard(
                            'Seoul DDP\nExhibition',
                            'Design Plaza',
                            'Now open',
                            kMintLight,
                          ),
                          SizedBox(width: 10),
                          _EventCard(
                            'Seongsu\nArtisan Fair',
                            'Seongsu-dong',
                            'Sat & Sun',
                            kYellowLight,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Explore section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Explore Nearby',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: kInk)),
                        Text('Within 1km',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11, color: kSubtext)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Category tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_tabs.length, (i) {
                          final sel = i == _selectedTab;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTab = i),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: sel ? kMint : kCard,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: sel ? kMint : kCardBorder),
                              ),
                              child: Text(_tabs[i],
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: sel ? Colors.white : kSubtext)),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Place grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: _currentSpots.length,
                      itemBuilder: (_, i) =>
                          _NearbySpotCard(spot: _currentSpots[i]),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/seoul-lens'),
                        icon: const Icon(Icons.camera_alt_rounded, size: 18),
                        label: const Text('Try Seoul Lens AR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMint,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                          textStyle: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            AppBottomNav(currentIndex: 3, onTap: (_) {}),
          ],
        ),
      ),
    );
  }
}

class _TransitStep {
  final String action;
  final String line;
  final String detail;
  final Color color;
  const _TransitStep(this.action, this.line, this.detail, this.color);
}

class _TransitStepRow extends StatelessWidget {
  final _TransitStep step;
  final bool isLast;
  const _TransitStepRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: step.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.action[0],
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
          ),
          if (!isLast)
            Container(
                width: 2,
                height: 22,
                color: Colors.white.withOpacity(0.15),
                margin: const EdgeInsets.symmetric(vertical: 2)),
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(step.line,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text(step.detail,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65))),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SpotCard {
  final String name;
  final String area;
  final String rating;
  final String distance;
  const _SpotCard(this.name, this.area, this.rating, this.distance);
}

class _EventCard extends StatelessWidget {
  final String title;
  final String venue;
  final String meta;
  final Color bgColor;
  const _EventCard(this.title, this.venue, this.meta, this.bgColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.event_rounded, size: 20, color: kInk),
          const SizedBox(height: 6),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13, fontWeight: FontWeight.w700, color: kInk),
              maxLines: 2),
          const SizedBox(height: 4),
          Text(venue,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, color: kSubtext),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(meta,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: kInk)),
          ),
        ],
      ),
    );
  }
}

class _NearbySpotCard extends StatelessWidget {
  final _SpotCard spot;
  const _NearbySpotCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(spot.rating,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD97706))),
              Text(spot.distance,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, color: kSubtext)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(spot.name,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kInk),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Text(spot.area,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: kSubtext)),
            ],
          ),
        ],
      ),
    );
  }
}