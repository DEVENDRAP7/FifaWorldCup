import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/flag.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String? _selectedName;
  String? _selectedCode;
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _step == 0
        ? _welcome()
        : _step == 1
        ? _authStep()
        : _teamPicker();
    if (_step == 0) {
      return Scaffold(body: _welcome());
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(20), child: body),
      ),
    );
  }

  Widget _welcome() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          'assets/onboarding.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        // Bottom dark gradient overlay for text + button readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.55, 0.8, 1.0],
              ),
            ),
          ),
        ),
        // Foreground content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _step = 1),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2ECC71), Color(0xFF1E9E5A)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2ECC71,
                            ).withValues(alpha: 0.5),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _authStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      IconButton(
        alignment: Alignment.centerLeft,
        onPressed: () => setState(() => _step = 0),
        icon: const Icon(Icons.arrow_back),
      ),
      const SizedBox(height: 8),
      const Text(
        'Sign in to play Contest',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      const Text(
        'Earn caps, support your team, win more. Guest mode also available for testing.',
        style: TextStyle(color: AppTheme.muted),
      ),
      const SizedBox(height: 24),
      TextField(
        controller: _nameCtrl,
        decoration: const InputDecoration(
          labelText: 'Your name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person_outline),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () async {
          final n = _nameCtrl.text.trim();
          if (n.isEmpty) return;
          await ref.read(authProvider.notifier).signIn(n);
          setState(() => _step = 2);
        },
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
      const SizedBox(height: 10),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () async {
          await ref.read(authProvider.notifier).signInAsGuest();
          setState(() => _step = 2);
        },
        child: const Text(
          'Continue as Guest (Test)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
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
