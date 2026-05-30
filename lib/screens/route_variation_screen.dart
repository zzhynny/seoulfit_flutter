import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class RouteVariationScreen extends StatelessWidget {
  const RouteVariationScreen({super.key});

  static const _items = [
    _RouteItem.place('Cafe Bora', 'Hongdae', '9:00 AM', 'Cafe', kMint),
    _RouteItem.transit('12 min walk', Icons.directions_walk_rounded, kSubtext),
    _RouteItem.place('Vinyl & Plastic', 'Hongdae', '9:30 AM', 'K-POP', kYellow),
    _RouteItem.transit('Subway Line 2 · Exit 4', Icons.directions_subway_rounded, Color(0xFF34A853)),
    _RouteItem.place('Sangsang Madang', 'Hongdae', '11:00 AM', 'K-POP', kMint),
    _RouteItem.transit('18 min subway', Icons.directions_subway_rounded, Color(0xFF1D70B8)),
    _RouteItem.place('Blue Bottle Coffee', 'Seongsu', '12:30 PM', 'Cafe', kYellow),
    _RouteItem.transit('8 min walk', Icons.directions_walk_rounded, kSubtext),
    _RouteItem.place('Daelim Warehouse', 'Seongsu', '1:30 PM', 'Art', kMint),
    _RouteItem.transit('25 min subway', Icons.directions_subway_rounded, Color(0xFFD97706)),
    _RouteItem.place('Changdeokgung Palace', 'Jongno', '3:30 PM', 'Heritage', kMint),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCanvas,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: kMintLight,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text('6 stops selected',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kMint)),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.map_rounded,
                          size: 16, color: kMint),
                      label: Text('Map View',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: kMint)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text('Your Route',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kInk)),
                  Text('Swipe to explore stops & transit details',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: kSubtext)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Horizontal scroll view
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final item = _items[i];
                  if (item.isTransit) {
                    return _TransitConnector(item: item);
                  } else {
                    return _PlaceCard(item: item, index: i ~/ 2);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Full route summary card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Route Summary',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 10),
                    ..._buildSummaryCards(),
                    const SizedBox(height: 16),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kMintLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _StatItem('Total', '2 Days'),
                          _StatItem('Stops', '6'),
                          _StatItem('Walk', '~38 min'),
                          _StatItem('Transit', '~43 min'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // KakaoMap CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.navigation_rounded, size: 18),
                        label: const Text('Open Full Route in KakaoMap'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE000),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                          textStyle: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/transit-explore'),
                        icon: const Icon(Icons.directions_transit_rounded,
                            size: 18),
                        label: const Text('Transit Guide & Explore'),
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

  List<Widget> _buildSummaryCards() {
    int stopNum = 0;
    return _items.where((it) => !it.isTransit).map((item) {
      stopNum++;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kCardBorder),
        ),
        child: Row(children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                color: kMint, shape: BoxShape.circle),
            child: Center(
              child: Text('$stopNum',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kInk)),
              Text('${item.area!} · ${item.time!}',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: kSubtext)),
            ]),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('KakaoMap',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
          ),
        ]),
      );
    }).toList();
  }
}

class _RouteItem {
  final bool isTransit;
  final String? name;
  final String? area;
  final String? time;
  final String? tag;
  final Color? accentColor;
  final String? transitLabel;
  final IconData? transitIcon;
  final Color? transitColor;

  const _RouteItem.place(
      this.name, this.area, this.time, this.tag, this.accentColor)
      : isTransit = false,
        transitLabel = null,
        transitIcon = null,
        transitColor = null;

  const _RouteItem.transit(
      this.transitLabel, this.transitIcon, this.transitColor)
      : isTransit = true,
        name = null,
        area = null,
        time = null,
        tag = null,
        accentColor = null;
}

class _PlaceCard extends StatelessWidget {
  final _RouteItem item;
  final int index;
  const _PlaceCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: item.accentColor!.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: item.accentColor!.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.accentColor!.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.place_rounded,
                color: item.accentColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kInk),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(item.time!,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, color: kSubtext)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: item.accentColor!.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item.tag!,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: item.accentColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransitConnector extends StatelessWidget {
  final _RouteItem item;
  const _TransitConnector({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.transitIcon, size: 18, color: item.transitColor),
          const SizedBox(height: 4),
          Text(
            item.transitLabel!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: item.transitColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: kMint)),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11, color: kSubtext)),
      ],
    );
  }
}