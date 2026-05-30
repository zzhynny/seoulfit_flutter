import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class SlotParsingScreen extends StatelessWidget {
  const SlotParsingScreen({super.key});

  static const _slots = [
    _Slot(icon: Icons.person_rounded, label: 'User', value: 'jihyun / Age 23', isMint: true),
    _Slot(icon: Icons.calendar_today_rounded, label: 'Duration', value: '2 Days', isMint: true),
    _Slot(icon: Icons.location_on_rounded, label: 'Region', value: 'Hongdae, Seongsu', isMint: true),
    _Slot(icon: Icons.attach_money_rounded, label: 'Budget', value: '\$300', isMint: false),
    _Slot(icon: Icons.star_rounded, label: 'Purpose', value: 'Cafe · K-POP', isMint: false),
  ];

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
                    const SizedBox(height: 8),
                    // Top badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: kMintLight,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                                size: 13, color: kMint),
                            const SizedBox(width: 5),
                            Text(
                              'AI Slot Parsing Complete',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: kMint),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Collected\nInformation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Parsed from your natural language input',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: kSubtext),
                    ),
                    const SizedBox(height: 24),
                    // Slot chips grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: _slots.length,
                      itemBuilder: (_, i) => _SlotCard(slot: _slots[i]),
                    ),
                    const SizedBox(height: 20),
                    // Raw input quote
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kCardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.format_quote_rounded,
                                size: 16, color: kSubtext),
                            const SizedBox(width: 6),
                            Text('Original Input',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: kSubtext)),
                          ]),
                          const SizedBox(height: 8),
                          Text(
                            '"I want a 2-day trip to Hongdae & Seongsu, budget \$300, focusing on cafe-hopping and K-POP culture."',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: kInk,
                                fontStyle: FontStyle.italic,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/generating'),
                        icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                        label: const Text('Confirm & Generate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMint,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                          textStyle: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Edit preferences',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: kSubtext,
                                decoration: TextDecoration.underline)),
                      ),
                    ),
                    const SizedBox(height: 16),
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
}

class _Slot {
  final IconData icon;
  final String label;
  final String value;
  final bool isMint;
  const _Slot({
    required this.icon,
    required this.label,
    required this.value,
    required this.isMint,
  });
}

class _SlotCard extends StatelessWidget {
  final _Slot slot;
  const _SlotCard({required this.slot});

  @override
  Widget build(BuildContext context) {
    final bg = slot.isMint ? kMintLight : kYellowLight;
    final border = slot.isMint ? kMint : kYellow;
    final iconColor = slot.isMint ? kMint : const Color(0xFFD97706);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border.withOpacity(0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Icon(slot.icon, size: 14, color: iconColor),
            const SizedBox(width: 5),
            Text(
              slot.label,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  letterSpacing: 0.3),
            ),
          ]),
          const SizedBox(height: 6),
          Text(
            slot.value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInk,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}