import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/skeleton.dart';
import '../widgets/flag.dart';
import 'package:shimmer/shimmer.dart';

// FIFA 2026 R32 bracket schema (48-team format: top 2 per group + 8 best 3rd-place).
// Labels per FIFA official bracket image. "3-" means a 3rd-place qualifier (slot TBD).
const _leftR32 = [
  ('1E', '3-'), ('1I', '3-'), ('2A', '2B'), ('1F', '2C'),
  ('2K', '2L'), ('1H', '2J'), ('1D', '3-'), ('1G', '3-'),
];
const _rightR32 = [
  ('1C', '2F'), ('2E', '2I'), ('1A', '3-'), ('1L', '3-'),
  ('1J', '2H'), ('2D', '2G'), ('1B', '3-'), ('1K', '3-'),
];

class BracketScreen extends ConsumerWidget {
  const BracketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(matchesProvider);
    return s.when(
      loading: () => const _BracketSkeleton(),
      error: (e, _) => Column(children: [
        ReconnectingBanner(onRetry: () => ref.read(matchesProvider.notifier).refresh()),
        const Expanded(child: _BracketSkeleton()),
      ]),
      data: (matches) => _BracketView(matches: matches),
    );
  }
}

class _BracketView extends StatelessWidget {
  final List<WcMatch> matches;
  const _BracketView({required this.matches});

  Map<String, List<(String name, String code)>> _groupTeams() {
    final map = <String, Map<String, String>>{};
    for (final m in matches) {
      if (m.groupName.isEmpty) continue;
      final g = map.putIfAbsent(m.groupName, () => {});
      if (m.homeName.isNotEmpty) g[m.homeName] = m.homeCountryCode;
      if (m.awayName.isNotEmpty) g[m.awayName] = m.awayCountryCode;
    }
    final result = <String, List<(String, String)>>{};
    map.forEach((k, v) => result[k] = v.entries.map((e) => (e.key, e.value)).toList());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupTeams();
    final groupKeys = groups.keys.toList()..sort();

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      boundaryMargin: const EdgeInsets.all(400),
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _GroupsGrid(groupKeys: groupKeys, groups: groups),
          const SizedBox(height: 28),
          const Text('🏆 KNOCKOUT BRACKET', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14)),
          const SizedBox(height: 16),
          _BracketTree(matches: matches),
        ]),
      ),
    );
  }
}

class _GroupsGrid extends StatelessWidget {
  final List<String> groupKeys;
  final Map<String, List<(String, String)>> groups;
  const _GroupsGrid({required this.groupKeys, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (int row = 0; row < (groupKeys.length / 6).ceil(); row++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = row * 6; i < (row * 6 + 6) && i < groupKeys.length; i++)
              Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: _GroupCard(name: groupKeys[i], teams: groups[groupKeys[i]] ?? const [])),
          ]),
        ),
    ]);
  }
}

class _GroupCard extends StatelessWidget {
  final String name;
  final List<(String name, String code)> teams;
  const _GroupCard({required this.name, required this.teams});

  @override
  Widget build(BuildContext context) {
    final padded = [...teams, ...List.filled(4 - teams.length.clamp(0, 4), ('TBD', ''))].take(4).toList();
    return Container(
      width: 150,
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x4DFFFFFF))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
            gradient: AppTheme.triGradient,
            borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
          ),
          child: Text(name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: padded.map((t) {
            final code = t.$2;
            final tname = t.$1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                FlagImage(url: code.isEmpty ? '' : 'https://api.fifa.com/api/v3/picture/flags-sq-4/$code', width: 20, height: 14, radius: 3),
                const SizedBox(width: 6),
                Expanded(child: Text(tname, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: tname == 'TBD' ? AppTheme.muted : AppTheme.text, fontStyle: tname == 'TBD' ? FontStyle.italic : FontStyle.normal))),
              ]),
            );
          }).toList()),
        ),
      ]),
    );
  }
}

class _BracketTree extends StatelessWidget {
  final List<WcMatch> matches;
  const _BracketTree({required this.matches});

  List<WcMatch> _stage(List<String> keys) =>
      matches.where((m) => keys.any((k) => m.stage.toLowerCase().contains(k))).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  @override
  Widget build(BuildContext context) {
    final r32 = _stage(['round of 32']);
    final r16 = _stage(['round of 16']);
    final qf = _stage(['quarter']);
    final sf = _stage(['semi']);
    final third = _stage(['third', '3rd']);
    final fin = _stage(['final']).where((m) => !RegExp(r'third|3rd|semi|quarter', caseSensitive: false).hasMatch(m.stage)).toList();

    WcMatch? mAt(List<WcMatch> list, int i) => i < list.length ? list[i] : null;

    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
      // LEFT half: R32 → R16 → QF → SF
      _StageCol(label: 'Round of 32', cards: List.generate(8, (i) => _SlotCard(slot: _leftR32[i], real: mAt(r32, i))), spacing: 6),
      const SizedBox(width: 8),
      _StageCol(label: 'Round of 16', cards: List.generate(4, (i) => _RealOrTbdCard(m: mAt(r16, i))), spacing: 76),
      const SizedBox(width: 8),
      _StageCol(label: 'Quarter-finals', cards: List.generate(2, (i) => _RealOrTbdCard(m: mAt(qf, i))), spacing: 220),
      const SizedBox(width: 8),
      _StageCol(label: 'Semi-finals', cards: [_RealOrTbdCard(m: mAt(sf, 0))], spacing: 0),
      const SizedBox(width: 12),
      // CENTER: FINAL + 3rd Place
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFFDE047)]), borderRadius: BorderRadius.circular(8)),
          child: const Text('FINAL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2)),
        ),
        const SizedBox(height: 12),
        _RealOrTbdCard(m: mAt(fin, 0), big: true),
        const SizedBox(height: 18),
        const Text('🏆 CHAMPION', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0x4DFFFFFF))),
          child: const Text('3rd PLACE', style: TextStyle(color: AppTheme.muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
        const SizedBox(height: 8),
        _RealOrTbdCard(m: mAt(third, 0)),
      ]),
      const SizedBox(width: 12),
      // RIGHT half: SF → QF → R16 → R32
      _StageCol(label: 'Semi-finals', cards: [_RealOrTbdCard(m: mAt(sf, 1))], spacing: 0),
      const SizedBox(width: 8),
      _StageCol(label: 'Quarter-finals', cards: List.generate(2, (i) => _RealOrTbdCard(m: mAt(qf, i + 2))), spacing: 220),
      const SizedBox(width: 8),
      _StageCol(label: 'Round of 16', cards: List.generate(4, (i) => _RealOrTbdCard(m: mAt(r16, i + 4))), spacing: 76),
      const SizedBox(width: 8),
      _StageCol(label: 'Round of 32', cards: List.generate(8, (i) => _SlotCard(slot: _rightR32[i], real: mAt(r32, i + 8))), spacing: 6),
    ]);
  }
}

class _StageCol extends StatelessWidget {
  final String label;
  final List<Widget> cards;
  final double spacing;
  const _StageCol({required this.label, required this.cards, required this.spacing});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 150,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              gradient: AppTheme.stageGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 1)),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < cards.length; i++) Padding(padding: EdgeInsets.only(bottom: i == cards.length - 1 ? 0 : spacing), child: cards[i]),
        ]),
      );
}

class _SlotCard extends StatelessWidget {
  final (String, String) slot;
  final WcMatch? real;
  const _SlotCard({required this.slot, this.real});

  @override
  Widget build(BuildContext context) {
    if (real != null) return _RealOrTbdCard(m: real);
    return SizedBox(
      width: 140,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x4DFFFFFF))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(slot.$1, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: .5)),
          const Text('vs', style: TextStyle(color: AppTheme.muted, fontSize: 9, fontStyle: FontStyle.italic)),
          Text(slot.$2, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: .5)),
        ]),
      ),
    );
  }
}

class _RealOrTbdCard extends StatelessWidget {
  final WcMatch? m;
  final bool big;
  const _RealOrTbdCard({this.m, this.big = false});

  @override
  Widget build(BuildContext context) {
    final w = big ? 180.0 : 140.0;
    if (m == null) {
      return SizedBox(
        width: w,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x66FFFFFF), width: big ? 2 : 1)),
          child: const Column(children: [
            Text('TBD', style: TextStyle(color: AppTheme.muted, fontStyle: FontStyle.italic, fontSize: 11)),
            SizedBox(height: 4),
            Text('TBD', style: TextStyle(color: AppTheme.muted, fontStyle: FontStyle.italic, fontSize: 11)),
          ]),
        ),
      );
    }
    final mm = m!;
    final isFT = mm.isFinished;
    final hW = isFT && (mm.homeScore ?? 0) > (mm.awayScore ?? 0);
    final aW = isFT && (mm.awayScore ?? 0) > (mm.homeScore ?? 0);
    return SizedBox(
      width: w,
      child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: mm.isLive ? const Color(0x66EF4444) : AppTheme.border, width: big ? 2 : 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _row(mm.homeName.isEmpty ? 'TBD' : mm.homeName, mm.homeFlag, mm.homeScore, hW, isFT),
        const SizedBox(height: 4),
        _row(mm.awayName.isEmpty ? 'TBD' : mm.awayName, mm.awayFlag, mm.awayScore, aW, isFT),
        const SizedBox(height: 5),
        Container(height: 1, color: AppTheme.border),
        const SizedBox(height: 4),
        Text(mm.isLive ? '🔴 LIVE' : '${DateFormat('MMM d').format(mm.date)} · ${DateFormat.Hm().format(mm.date)}',
            textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted, fontSize: 9)),
      ]),
      ),
    );
  }

  Widget _row(String name, String flag, int? score, bool winner, bool isFT) {
    final color = winner ? AppTheme.win : (isFT ? AppTheme.muted : AppTheme.text);
    return Row(children: [
      FlagImage(url: flag, width: 20, height: 14, radius: 3),
      const SizedBox(width: 5),
      Expanded(child: Text(name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, fontWeight: winner ? FontWeight.w800 : FontWeight.w600, color: color, fontStyle: name == 'TBD' ? FontStyle.italic : FontStyle.normal))),
      Text(score?.toString() ?? '-', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
    ]);
  }
}

class _BracketSkeleton extends StatelessWidget {
  const _BracketSkeleton();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      period: const Duration(milliseconds: 1400),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.s16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // 12 group cards (2 rows x 6)
          for (int r = 0; r < 2; r++) Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (int i = 0; i < 6; i++) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(width: 150, height: 130, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.s24),
          const Skeleton(width: 200, height: 16),
          const SizedBox(height: AppTheme.s16),
          // bracket cards row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < 5; i++) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(width: 140, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            ),
          ]),
        ]),
      ),
    );
  }
}
