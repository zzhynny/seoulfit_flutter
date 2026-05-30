import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final List<bool> _selected = [true, true, false, true, true, false, true, true, false];

  static const _places = [
    _PlaceItem('Cafe Bora', 'Hongdae', 'Cafe', 'High Cafe-hopping match', true),
    _PlaceItem('Vinyl & Plastic (HYBE)', 'Hongdae', 'K-POP', 'High K-POP relevance', true),
    _PlaceItem('Hongik University Street', 'Hongdae', 'Shopping', 'Popular shopping district', false),
    _PlaceItem('Sangsang Madang', 'Hongdae', 'K-POP', 'Cultural K-POP hub', true),
    _PlaceItem('Blue Bottle Coffee', 'Seongsu', 'Cafe', 'Trendy cafe destination', true),
    _PlaceItem('Daelim Warehouse', 'Seongsu', 'Art', 'Weak K-POP relevance', false),
    _PlaceItem('Seongsu Artisan Market', 'Seongsu', 'Shopping', 'Unique local crafts', true),
    _PlaceItem('Changdeokgung Palace', 'Jongno', 'Heritage', 'UNESCO heritage site', true),
    _PlaceItem('Gyeongui Line Forest Park', 'Mapo', 'Park', 'Nice walking route', false),
  ];

  int get _selectedCount => _selected.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    int orderNum = 0;
    return Scaffold(
      backgroundColor: kCanvas,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Sticky header
            Container(
              color: kCard,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Your Stops',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: kInk)),
                        Text('Pick the places you want to visit',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12, color: kSubtext)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: kMint,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '$_selectedCount / ${_places.length}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: _places.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  if (_selected[i]) orderNum++;
                  final num = _selected[i] ? orderNum : null;
                  return _SelectionCard(
                    place: _places[i],
                    selected: _selected[i],
                    orderNumber: num,
                    onChanged: (v) {
                      setState(() => _selected[i] = v);
                    },
                  );
                },
              ),
            ),
            // Bottom CTA
            Container(
              color: kCard,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _selectedCount >= 2
                          ? () =>
                              Navigator.pushNamed(context, '/route-variation')
                          : null,
                      icon: const Icon(Icons.route_rounded, size: 18),
                      label:
                          Text('Build My Route ($_selectedCount stops)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kMint,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: kCardBorder,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 0,
                        textStyle: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppBottomNav(currentIndex: 1, onTap: (_) {}),
          ],
        ),
      ),
    );
  }
}

class _PlaceItem {
  final String name;
  final String area;
  final String tag;
  final String rationale;
  final bool isHighRelevance;
  const _PlaceItem(
      this.name, this.area, this.tag, this.rationale, this.isHighRelevance);
}

class _SelectionCard extends StatelessWidget {
  final _PlaceItem place;
  final bool selected;
  final int? orderNumber;
  final ValueChanged<bool> onChanged;

  const _SelectionCard({
    required this.place,
    required this.selected,
    this.orderNumber,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = !place.isHighRelevance;

    return GestureDetector(
      onTap: () => onChanged(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? kCard : kCanvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? kMint : kCardBorder,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: kMint.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        child: Row(
          children: [
            // Checkbox / Order badge
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: orderNumber != null
                  ? Container(
                      key: ValueKey(orderNumber),
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          color: kMint, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '$orderNumber',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('unchecked'),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kCardBorder, width: 2),
                        color: kCanvas,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(place.name,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kInk)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: kMintLight,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(place.tag,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: kMint)),
                    ),
                  ]),
                  const SizedBox(height: 3),
                  Text(place.area,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: kSubtext)),
                  const SizedBox(height: 6),
                  // Rationale badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isWarning ? kYellowLight : kMintLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        isWarning
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_rounded,
                        size: 11,
                        color: isWarning
                            ? const Color(0xFFD97706)
                            : kMint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.rationale,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isWarning
                              ? const Color(0xFFD97706)
                              : kMint,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}