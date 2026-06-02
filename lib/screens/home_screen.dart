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
    return Scaffold(
      backgroundColor: AppTheme.bg,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: AppTheme.deep,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppTheme.deep,
        centerTitle: true,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.sports_soccer, color: AppTheme.accent, size: 18),
          const SizedBox(width: 8),
          Text(titles[_idx], style: AppTheme.title.copyWith(letterSpacing: 2.2)),
        ]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppTheme.accent),
        ),
      ),
      // Render only the active tab so it remounts (scrolls to top) on return.
      body: PitchStripes(child: pages[_idx]),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          _StadiumNav(
            items: _items(t),
            index: _idx,
            onChange: (i) => setState(() => _idx = i),
          ),
        ],
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

class _StadiumNav extends StatelessWidget {
  final List<_NavItem> items;
  final int index;
  final ValueChanged<int> onChange;
  const _StadiumNav({required this.items, required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.deep,
        border: Border(top: BorderSide(color: AppTheme.accent, width: 2)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset, top: 6),
      child: SizedBox(
        height: 60,
        child: Row(children: List.generate(items.length, (i) {
          final isSel = i == index;
          final it = items[i];
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChange(i),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                tween: Tween(begin: 0, end: isSel ? 1 : 0),
                builder: (_, tv, _) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.transparent, AppTheme.accent, tv),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(isSel ? it.selected : it.icon, size: 20,
                        color: Color.lerp(AppTheme.muted, AppTheme.deep, tv)),
                  ),
                  const SizedBox(height: 4),
                  Text(it.label.toUpperCase(),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: AppTheme.overline.copyWith(
                        color: Color.lerp(AppTheme.muted, AppTheme.accent, tv),
                        fontSize: 9, letterSpacing: 0.8,
                      )),
                ]),
              ),
            ),
          );
        })),
      ),
    );
  }
}
