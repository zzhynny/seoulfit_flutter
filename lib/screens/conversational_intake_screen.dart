import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/mascot_widget.dart';
import '../utils/app_state.dart';

class ConversationalIntakeScreen extends StatefulWidget {
  const ConversationalIntakeScreen({super.key});

  @override
  State<ConversationalIntakeScreen> createState() =>
      _ConversationalIntakeScreenState();
}

class _ConversationalIntakeScreenState
    extends State<ConversationalIntakeScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final bool _showNextButton = true;

  @override
  void initState() {
    super.initState();
    AppState.hasChatData = true;
  }

  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      text: "Hi! I'm SeoulFit Buddy 🐣\nWhere would you like to explore in Seoul?",
      isUser: false,
    ),
    _ChatMessage(
      text:
          "I want a 2-day trip to Hongdae & Seongsu, budget \$300, focusing on cafe-hopping and K-POP culture.",
      isUser: true,
    ),
    _ChatMessage(
      text:
          "Perfect! I found your preferences:\n• 2 days · Hongdae & Seongsu\n• Budget: \$300\n• Cafe hopping + K-POP 🎵\n\nLet me build your itinerary now!",
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
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
            // Header
            Container(
              color: kCard,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const MascotWidget(size: 38, variant: MascotVariant.chip),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, jihyun! (Age: 23) 👋',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: kInk,
                          ),
                        ),
                        Text(
                          'Ready to explore Seoul?',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: kSubtext),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kMintLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'AI Chat',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kMint),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Messages
            Expanded(
              child: ListView.separated(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ChatBubble(message: _messages[i]),
              ),
            ),
            // Proceed button
            if (_showNextButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/slot-parsing'),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('Confirm & Parse My Request'),
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
              ),
            // Input field
            Container(
              color: kCard,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: kCanvas,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kCardBorder),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, color: kInk),
                        decoration: InputDecoration(
                          hintText: 'Type your travel preference...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 14, color: kSubtext),
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                          color: kMint, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const AppBottomNav(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  const _ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
                color: kYellow, shape: BoxShape.circle),
            child: const Center(
              child: Text('🐣', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isUser ? kMint : kCard,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft:
                    Radius.circular(isUser ? 18 : 4),
                bottomRight:
                    Radius.circular(isUser ? 4 : 18),
              ),
              border: isUser
                  ? null
                  : Border.all(color: kCardBorder),
              boxShadow: [
                BoxShadow(
                  color: kMint.withValues(alpha: isUser ? 0.18 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: isUser ? Colors.white : kInk,
                height: 1.5,
              ),
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: kMintLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'J',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kMint),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
