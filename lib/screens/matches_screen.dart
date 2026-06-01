import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/match_card.dart';
import '../widgets/skeleton.dart';
import '../widgets/hero_header.dart';
import '../services/ad_service.dart';
import 'match_detail_screen.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(matchesProvider);
    return s.when(
      loading: () => Column(children: const [HeroHeader(totalMatches: 0, liveCount: 0), Expanded(child: SkeletonList())]),
      error: (e, _) => Column(children: [
        ReconnectingBanner(onRetry: () => ref.read(matchesProvider.notifier).refresh()),
        const HeroHeader(totalMatches: 0, liveCount: 0),
        const Expanded(child: SkeletonList()),
      ]),
      data: (all) => _Content(all: all),
    );
  }
}

class _Content extends ConsumerWidget {
  final List<WcMatch> all;
  const _Content({required this.all});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = all.where((m) => m.isLive).toList()..sort((a, b) => a.date.compareTo(b.date));
    final upcoming = all.where((m) => m.isUpcoming).toList()..sort((a, b) => a.date.compareTo(b.date));
    final finished = all.where((m) => m.isFinished).toList()..sort((a, b) => b.date.compareTo(a.date));

    // Flatten everything into one item list for ListView.builder (lazy recycling).
    final items = <_Item>[
      _HeroItem(total: all.length, live: live.length),
      if (live.isNotEmpty) ..._buildSection('LIVE NOW', live, AppTheme.live, accentDot: true),
      if (upcoming.isNotEmpty) ..._buildSection('UPCOMING', upcoming, AppTheme.textSecondary),
      if (finished.isNotEmpty) ..._buildSection('RESULTS', finished, AppTheme.muted),
      if (all.isEmpty) const _EmptyItem(),
    ];

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () => ref.read(matchesProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, AppTheme.s24),
        itemCount: items.length,
        itemBuilder: (ctx, i) => items[i].build(ctx),
      ),
    );
  }

  List<_Item> _buildSection(String title, List<WcMatch> list, Color color, {bool accentDot = false}) {
    final groups = <String, List<WcMatch>>{};
    for (final m in list) {
      final key = DateFormat('EEE, MMM d').format(m.date);
      (groups[key] ??= []).add(m);
    }
    final out = <_Item>[_SectionHeader(title: title, color: color, accentDot: accentDot, count: list.length)];
    groups.forEach((day, matches) {
      out.add(_DayLabel(day));
      for (final m in matches) {
        out.add(_MatchItem(m));
      }
    });
    return out;
  }
}

abstract class _Item {
  const _Item();
  Widget build(BuildContext context);
}

class _HeroItem extends _Item {
  final int total, live;
  const _HeroItem({required this.total, required this.live});
  @override
  Widget build(BuildContext context) => HeroHeader(totalMatches: total, liveCount: live);
}

class _SectionHeader extends _Item {
  final String title;
  final Color color;
  final bool accentDot;
  final int count;
  const _SectionHeader({required this.title, required this.color, required this.accentDot, required this.count});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s16, AppTheme.s20, AppTheme.s16, AppTheme.s12),
        child: Row(children: [
          if (accentDot) ...[
            Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.live, shape: BoxShape.circle)),
            const SizedBox(width: 8),
          ],
          Text(title, style: AppTheme.overline.copyWith(color: color, fontSize: 11)),
          const SizedBox(width: AppTheme.s12),
          Expanded(child: Container(height: 1, color: AppTheme.border)),
          const SizedBox(width: 8),
          Text('$count', style: AppTheme.overline),
        ]),
      );
}

class _DayLabel extends _Item {
  final String day;
  const _DayLabel(this.day);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s16, AppTheme.s8, AppTheme.s16, AppTheme.s8),
        child: Text(day.toUpperCase(), style: AppTheme.overline.copyWith(color: Colors.white)),
      );
}

class _MatchItem extends _Item {
  final WcMatch m;
  const _MatchItem(this.m);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s12, 0, AppTheme.s12, AppTheme.s12),
        child: MatchCard(m: m, onTap: () {
          AdService.instance.maybeShowInterstitial();
          Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(m: m)));
        }),
      );
}

class _EmptyItem extends _Item {
  const _EmptyItem();
  @override
  Widget build(BuildContext context) => const _Empty();
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.s48 * 2),
        child: Column(children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: AppTheme.surface, shape: BoxShape.circle, border: Border.all(color: AppTheme.border)), child: const Icon(Icons.sports_soccer, color: AppTheme.muted)),
          const SizedBox(height: AppTheme.s12),
          Text('No matches yet', style: AppTheme.title),
          const SizedBox(height: AppTheme.s4),
          Text('Check back closer to kickoff', style: AppTheme.caption),
        ]),
      );
}
