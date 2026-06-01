import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'matches_screen.dart';
import 'groups_screen.dart';
import 'bracket_screen.dart';
import 'contest_screen.dart';
import 'settings_screen.dart';
import 'onboarding_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _idx = 0;

  static const _items = [
    _NavItem(label: 'Matches', icon: Icons.sports_soccer_outlined, selected: Icons.sports_soccer),
    _NavItem(label: 'Groups', icon: Icons.groups_2_outlined, selected: Icons.groups_2),
    _NavItem(label: 'Bracket', icon: Icons.emoji_events_outlined, selected: Icons.emoji_events),
    _NavItem(label: 'Contest', icon: Icons.monetization_on_outlined, selected: Icons.monetization_on),
    _NavItem(label: 'Profile', icon: Icons.person_outline, selected: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if (!user.onboarded) return const OnboardingScreen();

    const pages = [
      MatchesScreen(),
      GroupsScreen(),
      BracketScreen(),
      ContestScreen(),
      SettingsScreen(),
    ];

    const titles = ['World Cup 2026', 'Groups', 'Bracket', 'Contest', 'Profile'];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF34D399),  // mint
            Color(0xFF60A5FA),  // sky blue
            Color(0xFFFCA5A5),  // soft red
          ],
          stops: [0.0, 0.5, 1.0],
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
      body: IndexedStack(index: _idx, children: pages),
      bottomNavigationBar: _FancyNav(
        items: _items,
        index: _idx,
        onChange: (i) => setState(() => _idx = i),
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
      padding: EdgeInsets.fromLTRB(6, 6, 6, 6 + bottomInset),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            Color(0xFF064E3B),  // emerald
            Color(0xFF0A2F75),  // stadium blue
            Color(0xFF8B0A1F),  // deep red
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: const Border(top: BorderSide(color: Color(0xFFD4AF37), width: 1.5)),
        boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 20, offset: Offset(0, -6))],
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
                            colors: [
                              Color(0xFF052E1F),
                              Color(0xFF065F46),
                              Color(0xFF0B4B86),
                              Color(0xFF0A2F75),
                              Color(0xFF15244D),
                              Color(0xFF4A1530),
                              Color(0xFF8B0A1F),
                              Color(0xFFC8102E),
                            ],
                            stops: [0.0, 0.14, 0.28, 0.45, 0.6, 0.78, 0.9, 1.0],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(22),
                    border: isSel ? Border.all(color: const Color(0xFFFFD700), width: 1.2) : null,
                    boxShadow: isSel
                        ? [
                            BoxShadow(color: const Color(0xFF0A2F75).withValues(alpha: .55), blurRadius: 18, spreadRadius: 0, offset: const Offset(0, 4)),
                            BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: .25), blurRadius: 8, spreadRadius: 0),
                          ]
                        : null,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(isSel ? it.selected : it.icon, size: 20, color: isSel ? const Color(0xFFFFD700) : Colors.white70),
                    if (isSel) Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(it.label, style: AppTheme.overline.copyWith(color: const Color(0xFFFFD700), fontSize: 9, letterSpacing: 0.5)),
                    ),
                  ]),
                ),
              ),
            );
          })),
    );
  }
}
