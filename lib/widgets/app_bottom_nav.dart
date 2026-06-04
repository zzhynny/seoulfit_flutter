import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../screens/empty_chat_screen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.chat_bubble_rounded, label: 'Chat'),
    _NavItem(icon: Icons.explore_rounded, label: 'Explore'),
    _NavItem(icon: Icons.camera_alt_rounded, label: 'Lens'),
    _NavItem(icon: Icons.directions_transit_rounded, label: 'Transit'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  static const _routes = [
    '/chat',
    '/itinerary-map',
    '/seoul-lens',
    '/transit-explore',
    '/profile',
  ];

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (index == currentIndex) return;
    // Explore(1) / Transit(3): 채팅 데이터 없으면 빈 상태 화면
    if ((index == 1 || index == 3) && !AppState.hasChatData) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmptyChatScreen(navIndex: index),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: kCard,
        border: const Border(top: BorderSide(color: kCardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: kMint.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => _handleTap(context, i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 30,
                    decoration: selected
                        ? BoxDecoration(
                            color: kMint.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          )
                        : null,
                    child: Icon(
                      _items[i].icon,
                      size: 22,
                      color: selected ? kMint : kSubtext,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _items[i].label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? kMint : kSubtext,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
