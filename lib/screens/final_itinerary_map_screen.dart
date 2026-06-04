import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';

class FinalItineraryMapScreen extends StatefulWidget {
  const FinalItineraryMapScreen({super.key});

  @override
  State<FinalItineraryMapScreen> createState() =>
      _FinalItineraryMapScreenState();
}

class _FinalItineraryMapScreenState extends State<FinalItineraryMapScreen> {
  static final _itineraryJson = {
    'title': 'Seoul 2-Day Itinerary',
    'score': 1.0,
    'duration': '2 Days',
    'budget': '\$300',
    'purpose': ['Cafe-hopping', 'K-POP'],
    'sources': ['Visit Seoul', 'Visit Korea', 'Kakao Local', 'Seoul OpenAPI'],
    'days': [
      {
        'day': 1,
        'theme': 'Hongdae Culture & Cafes',
        'places': [
          {
            'name': 'Cafe Bora',
            'area': 'Hongdae',
            'tag': 'Cafe',
            'lat': 37.5546,
            'lng': 126.9240,
          },
          {
            'name': 'Vinyl & Plastic (HYBE)',
            'area': 'Hongdae',
            'tag': 'K-POP',
            'lat': 37.5567,
            'lng': 126.9234,
          },
          {
            'name': 'Sangsang Madang',
            'area': 'Hongdae',
            'tag': 'K-POP',
            'lat': 37.5551,
            'lng': 126.9225,
          },
        ],
      },
      {
        'day': 2,
        'theme': 'Seongsu & Heritage',
        'places': [
          {
            'name': 'Blue Bottle Coffee',
            'area': 'Seongsu',
            'tag': 'Cafe',
            'lat': 37.5443,
            'lng': 127.0557,
          },
          {
            'name': 'Daelim Warehouse',
            'area': 'Seongsu',
            'tag': 'Art',
            'lat': 37.5448,
            'lng': 127.0563,
          },
          {
            'name': 'Changdeokgung Palace',
            'area': 'Jongno',
            'tag': 'Heritage',
            'lat': 37.5794,
            'lng': 126.9910,
          },
          {
            'name': 'Gyeongui Line Forest Park',
            'area': 'Mapo',
            'tag': 'Park',
            'lat': 37.5593,
            'lng': 126.9230,
          },
        ],
      },
    ],
  };

  Future<void> _exportJson(BuildContext context) async {
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(_itineraryJson);

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'seoulfit_itinerary_$timestamp.json';

      late File file;
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) await dir.create(recursive: true);
        file = File('${dir.path}/$fileName');
      } else {
        final dir = Directory.systemTemp;
        file = File('${dir.path}/$fileName');
      }

      await file.writeAsString(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '일정이 저장되었습니다: Download/$fileName',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            backgroundColor: kSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '저장 실패: $e',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  static const _places = [
    _Place('Cafe Bora', 'Hongdae', 'Cafe', true),
    _Place('Vinyl & Plastic (HYBE)', 'Hongdae', 'K-POP', false),
    _Place('Sangsang Madang', 'Hongdae', 'K-POP', false),
    _Place('Blue Bottle Coffee', 'Seongsu', 'Cafe', true),
    _Place('Daelim Warehouse', 'Seongsu', 'Art', true),
    _Place('Changdeokgung Palace', 'Jongno', 'Heritage', true),
    _Place('Gyeongui Line Forest Park', 'Mapo', 'Park', false),
  ];

  Set<Marker> get _googleMarkers => {
        const Marker(
          markerId: MarkerId('cafe_bora'),
          position: LatLng(37.5546, 126.9240),
          infoWindow: InfoWindow(title: 'Cafe Bora', snippet: 'Hongdae'),
        ),
        const Marker(
          markerId: MarkerId('blue_bottle'),
          position: LatLng(37.5443, 127.0557),
          infoWindow: InfoWindow(title: 'Blue Bottle Coffee', snippet: 'Seongsu'),
        ),
        const Marker(
          markerId: MarkerId('changdeokgung'),
          position: LatLng(37.5794, 126.9910),
          infoWindow: InfoWindow(title: 'Changdeokgung Palace', snippet: 'Jongno'),
        ),
      };

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
                child: Column(
                  children: [
                    // Google Maps — Android/iOS: 실제 지도, Web: 플레이스홀더
                    SizedBox(
                      height: 240,
                      child: kIsWeb
                          ? _WebMapPlaceholder()
                          : GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(37.5665, 126.9780),
                                zoom: 12,
                              ),
                              markers: _googleMarkers,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Score + header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Final Itinerary',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: kInk),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kSuccess.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: kSuccess.withValues(alpha: 0.4)),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.verified_rounded,
                                      size: 14, color: kSuccess),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Score: 1.0',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: kSuccess),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('9 verified locations · 2 days',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, color: kSubtext)),
                          const SizedBox(height: 16),
                          // Place list
                          ..._places.map((p) => _PlaceRow(place: p)),
                          const SizedBox(height: 20),
                          // Trust section
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
                                  const Icon(Icons.shield_rounded,
                                      size: 14, color: kMint),
                                  const SizedBox(width: 6),
                                  Text('Verified Sources',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: kInk)),
                                ]),
                                const SizedBox(height: 10),
                                const Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    _SourceBadge('Visit Seoul'),
                                    _SourceBadge('Visit Korea'),
                                    _SourceBadge('Kakao Local'),
                                    _SourceBadge('Seoul OpenAPI'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Export button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _exportJson(context),
                              icon: const Icon(Icons.download_rounded,
                                  size: 18, color: kMint),
                              label: Text('Export Itinerary JSON',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: kMint)),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                side: const BorderSide(color: kMint, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/user-selection'),
                              icon: const Icon(Icons.checklist_rounded,
                                  size: 18),
                              label: const Text('Select My Stops'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kMint,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                  ],
                ),
              ),
            ),
            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}

class _Place {
  final String name;
  final String area;
  final String tag;
  final bool isMint;
  const _Place(this.name, this.area, this.tag, this.isMint);
}

class _PlaceRow extends StatelessWidget {
  final _Place place;
  const _PlaceRow({required this.place});

  @override
  Widget build(BuildContext context) {
    final tagColor = place.isMint ? kMint : const Color(0xFFD97706);
    final tagBg = place.isMint ? kMintLight : kYellowLight;

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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: tagBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.place_rounded, size: 16, color: tagColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place.name,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kInk)),
            Text(place.area,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: kSubtext)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: tagBg, borderRadius: BorderRadius.circular(20)),
          child: Text(place.tag,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: tagColor)),
        ),
      ]),
    );
  }
}

// Web에서는 webview_flutter 미지원 — 그리드 플레이스홀더 표시
class _WebMapPlaceholder extends StatelessWidget {
  static const _pois = [
    (name: 'Cafe Bora', x: 0.22, y: 0.42),
    (name: 'Blue Bottle', x: 0.68, y: 0.55),
    (name: 'Changdeokgung', x: 0.50, y: 0.28),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFD1F4E8), Color(0xFFBBF0E3), Color(0xFFE8F4E8)],
            ),
          ),
        ),
        // 격자선
        CustomPaint(
          size: Size(w, 240),
          painter: _GridPainter(),
        ),
        // POI 마커
        ..._pois.map((p) => Positioned(
              left: w * p.x - 14,
              top: 240 * p.y - 14,
              child: Column(children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: kMint,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: kMint.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: const Icon(Icons.place_rounded, size: 16, color: Colors.white),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(p.name,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 8, fontWeight: FontWeight.w700, color: kInk)),
                ),
              ]),
            )),
        // KakaoMap 뱃지
        Positioned(
          bottom: 10,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE000),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('KakaoMap (Android only)',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black)),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.4)..strokeWidth = 0.8;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SourceBadge extends StatelessWidget {
  final String label;
  const _SourceBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kCanvas,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kMint.withValues(alpha: 0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle_rounded, size: 11, color: kMint),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: kInk)),
      ]),
    );
  }
}