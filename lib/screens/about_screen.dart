import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app_links.dart';

const String _kAppName = 'World Cup 2026 - Live Scores';
const String _kVersion = '1.0.0';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _sunrise = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B1330),
      Color(0xFF3A1F35),
      Color(0xFF7A2E2A),
      Color(0xFFC8542B),
      Color(0xFFE89647),
      Color(0xFFEBB46D),
    ],
    stops: [0.0, 0.22, 0.45, 0.68, 0.85, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: _sunrise),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text('About', style: AppTheme.title),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _hero(),
            const SizedBox(height: 20),
            _card(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('ABOUT THIS APP'),
                const SizedBox(height: 10),
                const Text(
                  'Your companion for the 2026 World Cup across the USA, Canada and Mexico. '
                  'Follow every match in real time, track how the groups are shaping up, watch the '
                  'knockout bracket unfold, and cast your vote on who will win — then see how the '
                  'rest of the world is leaning.',
                  style: TextStyle(color: AppTheme.muted, height: 1.5, fontSize: 13.5),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            _label('  FEATURES'),
            const SizedBox(height: 8),
            _card(
              padded: false,
              child: Column(children: const [
                _Feature(Icons.sports_soccer, 'Live Scores', 'Real-time match updates and results'),
                _div,
                _Feature(Icons.groups_2, 'Group Standings', 'Tables computed live as games finish'),
                _div,
                _Feature(Icons.emoji_events, 'Knockout Bracket', 'Full road to the final'),
                _div,
                _Feature(Icons.how_to_vote, 'Fan Voting', 'Predict winners, see global % live'),
                _div,
                _Feature(Icons.favorite, 'Your Team', 'Pin a nation and follow its journey'),
                _div,
                _Feature(Icons.translate, '9 Languages', 'Auto-adapts to your device language'),
              ]),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('DATA SOURCE'),
                const SizedBox(height: 8),
                const Text(
                  'Match fixtures, scores and standings are provided by the public FIFA data API '
                  '(api.fifa.com). Vote totals are aggregated anonymously across all users.',
                  style: TextStyle(color: AppTheme.muted, height: 1.5, fontSize: 13),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            _card(
              child: Row(children: const [
                Icon(Icons.info_outline, color: AppTheme.goldSoft, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This is an independent fan app. It is not affiliated with, endorsed by, '
                    'sponsored by, or otherwise associated with FIFA.',
                    style: TextStyle(color: AppTheme.muted, height: 1.45, fontSize: 12),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: openPrivacyPolicy,
              borderRadius: BorderRadius.circular(AppTheme.rLg),
              child: _card(
                child: Row(children: const [
                  Icon(Icons.privacy_tip_outlined, color: AppTheme.goldSoft, size: 18),
                  SizedBox(width: 12),
                  Expanded(child: Text('Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                  Icon(Icons.open_in_new, color: AppTheme.mutedSoft, size: 16),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            Center(child: Text('$_kAppName · v$_kVersion', style: AppTheme.caption)),
            const SizedBox(height: 4),
            Center(child: Text('Made for the fans ⚽', style: AppTheme.caption.copyWith(fontSize: 11))),
          ],
        ),
      ),
    );
  }

  Widget _hero() => Column(children: [
        Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0x33FFFFFF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x66FFFFFF), width: 1),
            boxShadow: [BoxShadow(color: AppTheme.gold.withValues(alpha: .40), blurRadius: 28, spreadRadius: 2)],
          ),
          child: Image.asset(
            'assets/trophy.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Center(child: Text('🏆', style: TextStyle(fontSize: 48))),
          ),
        ),
        const SizedBox(height: 14),
        Text(_kAppName, textAlign: TextAlign.center, style: AppTheme.display.copyWith(fontSize: 24)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.goldSoft]),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text('Version $_kVersion', style: const TextStyle(color: Color(0xFF1F1F22), fontWeight: FontWeight.w800, fontSize: 11)),
        ),
      ]);

  Widget _card({required Widget child, bool padded = true}) => Container(
        width: double.infinity,
        padding: padded ? const EdgeInsets.all(16) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          border: Border.all(color: const Color(0x33FFFFFF)),
          boxShadow: AppTheme.shadowSm,
        ),
        child: child,
      );

  Widget _label(String t) => Text(t.trim(), style: AppTheme.overline);

  static const _div = Divider(height: 1, indent: 60, color: AppTheme.border);
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Feature(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.goldSoft]),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF1F1F22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTheme.bodyBold),
              const SizedBox(height: 1),
              Text(subtitle, style: AppTheme.caption),
            ]),
          ),
        ]),
      );
}
