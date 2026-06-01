import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/flag.dart';
import '../widgets/auth_panel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String? _selectedName;
  String? _selectedCode;
  final _pageCtrl = PageController();
  int _page = 0;

  static const _slides = [
    ('assets/onboarding.png', 'Welcome to World Cup 2026', 'Every match of the 2026 tournament — live in your pocket.'),
    ('assets/onboarding2.png', 'Live Scores & Standings', 'Real-time scores and group tables, updated as games happen.'),
    ('assets/onboarding3.png', 'Vote & Back Your Team', 'Predict who wins, see how the world leans, and follow your nation.'),
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 0) {
      return Scaffold(body: _carousel());
    }
    // Auth step scrolls (keyboard); team picker fills available space.
    final body = _step == 1
        ? SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: _authStep(),
          )
        : const Padding(padding: EdgeInsets.all(20), child: SizedBox.shrink());
    return Scaffold(
      body: SafeArea(
        child: _step == 1 ? body : Padding(padding: const EdgeInsets.all(20), child: _teamPicker()),
      ),
    );
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    } else {
      setState(() => _step = 1);
    }
  }

  Widget _carousel() {
    final isLast = _page == _slides.length - 1;
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageCtrl,
          itemCount: _slides.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) {
            final (img, title, sub) = _slides[i];
            return Stack(fit: StackFit.expand, children: [
              Image.asset(img, fit: BoxFit.cover, alignment: Alignment.center),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0.0, 0.5, 0.78, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 170),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.display.copyWith(color: Colors.white, fontSize: 26)),
                      const SizedBox(height: 10),
                      Text(sub, style: AppTheme.body.copyWith(color: Colors.white70, fontSize: 15, height: 1.4)),
                    ],
                  ),
                ),
              ),
            ]);
          },
        ),
        // Skip
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 4),
              child: TextButton(
                onPressed: () => setState(() => _step = 1),
                child: const Text('Skip', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
        // Dots + button
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_slides.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppTheme.gold : Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                })),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: const Color(0xFF1F1F22),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _next,
                    child: Text(isLast ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _authStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => setState(() => _step = 0),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(height: 4),
          AuthPanel(
            onAuthenticated: () => setState(() => _step = 2),
            onGuest: () async {
              await ref.read(authProvider.notifier).signInAsGuest();
              if (mounted) setState(() => _step = 2);
            },
          ),
        ],
      );

  Widget _teamPicker() {
    final matches = ref.watch(matchesProvider);
    final teams = <(String, String)>{};
    matches.whenData((list) {
      for (final m in list) {
        if (m.homeName.isNotEmpty) teams.add((m.homeName, m.homeCountryCode));
        if (m.awayName.isNotEmpty) teams.add((m.awayName, m.awayCountryCode));
      }
    });
    final sorted = teams.toList()..sort((a, b) => a.$1.compareTo(b.$1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          onPressed: () => setState(() => _step = 1),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pick your team',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the nation you support. You can stake caps on their matches in Contest.',
          style: TextStyle(color: AppTheme.muted),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: sorted.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: sorted.map((t) {
                    final isSel = _selectedCode == t.$2;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedName = t.$1;
                        _selectedCode = t.$2;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppTheme.gold.withValues(alpha: .35)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSel ? AppTheme.gold : AppTheme.border,
                            width: isSel ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlagImage(
                              url: t.$2.isEmpty
                                  ? ''
                                  : 'https://api.fifa.com/api/v3/picture/flags-sq-4/${t.$2}',
                              width: 44,
                              height: 30,
                              radius: 4,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.$1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _selectedCode == null
              ? null
              : () async {
                  await ref
                      .read(authProvider.notifier)
                      .setFavoriteTeam(_selectedName!, _selectedCode!);
                },
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
