import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_ad_widget.dart';
import '../l10n/gen/app_localizations.dart';
import 'matches_screen.dart';
import 'groups_screen.dart';
import 'bracket_screen.dart';
import 'contest_screen.dart';
import 'profile_screen.dart';
import 'onboarding_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _idx = 0;

  List<_NavItem> _items(AppL10n t) => [
        _NavItem(label: t.navMatches, icon: Icons.sports_soccer_outlined, selected: Icons.sports_soccer),
        _NavItem(label: t.navGroups, icon: Icons.groups_2_outlined, selected: Icons.groups_2),
        _NavItem(label: t.navBracket, icon: Icons.emoji_events_outlined, selected: Icons.emoji_events),
        _NavItem(label: t.navContest, icon: Icons.how_to_vote_outlined, selected: Icons.how_to_vote),
        _NavItem(label: t.navProfile, icon: Icons.person_outline, selected: Icons.person),
      ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    // Signed-out / fresh user → onboarding. A returning (already-onboarded)
    // user lands straight on the login step, skipping the intro carousel.
    if (user.mode == AuthMode.unknown) {
      return OnboardingScreen(startAtLogin: user.onboarded);
    }

    const pages = [
      MatchesScreen(),
      GroupsScreen(),
      BracketScreen(),
      ContestScreen(),
      ProfileScreen(),
    ];

    final t = AppL10n.of(context);
    final titles = [t.appTitle, t.navGroups, t.navBracket, t.navContest, t.navProfile];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B1330),   // pre-dawn deep plum sky
            Color(0xFF3A1F35),   // dusky violet
            Color(0xFF7A2E2A),   // burning red horizon
            Color(0xFFC8542B),   // coral orange
            Color(0xFFE89647),   // warm peach
            Color(0xFFEBB46D),   // golden amber haze
          ],
          stops: [0.0, 0.22, 0.45, 0.68, 0.85, 1.0],
        ),
      ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(titles[_idx], style: AppTheme.title),
        flexibleSpace: const SafeArea(child: Align(alignment: Alignment.bottomCenter, child: SizedBox(height: 2, child: DecoratedBox(decoration: BoxDecoration(gradient: AppTheme.triGradient))))),
      ),
      // Render only the active tab so it remounts (scrolls to top) on return.
      body: pages[_idx],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          const SizedBox(height: 2),
          _FancyNav(
            items: _items(t),
            index: _idx,
            onChange: (i) => setState(() => _idx = i),
          ),
        ],
      ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selected;
  const _NavItem({required this.label, required this.icon, required this.selected});
}

class _FancyNav extends StatelessWidget {
  final List<_NavItem> items;
  final int index;
  final ValueChanged<int> onChange;
  const _FancyNav({required this.items, required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 6 + bottomInset),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            Color(0xE62A2723),   // taupe
            Color(0xE61F1F22),   // charcoal
            Color(0xE63A2A20),   // warm orange tint
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(top: BorderSide(color: Color(0x1AD4AF37), width: 0.6)),
        boxShadow: [BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Row(children: List.generate(items.length, (i) {
            final isSel = i == index;
            final it = items[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => onChange(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSel
                        ? const LinearGradient(
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                            colors: [Color(0xFFD4AF37), Color(0xFFF5D76E)],   // gold gradient
                          )
                        : null,
                    borderRadius: BorderRadius.circular(22),
                    border: isSel ? Border.all(color: const Color(0x66FFFFFF), width: 0.6) : null,
                    boxShadow: isSel
                        ? [BoxShadow(color: const Color(0xFFD4AF37).withValues(alpha: .35), blurRadius: 14, offset: const Offset(0, 4))]
                        : null,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(isSel ? it.selected : it.icon, size: 20, color: isSel ? const Color(0xFF1F1F22) : Colors.white60),
                    if (isSel) Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(it.label, style: AppTheme.overline.copyWith(color: const Color(0xFF1F1F22), fontSize: 9, letterSpacing: 0.5)),
                    ),
                  ]),
                ),
              ),
            );
          })),
    );
  }
}
