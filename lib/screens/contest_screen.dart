import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../providers/providers.dart';
import '../providers/auth_provider.dart';
import '../providers/contest_provider.dart';
import '../theme/app_theme.dart';

class ContestScreen extends ConsumerWidget {
  const ContestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final contest = ref.watch(contestProvider);
    final matches = ref.watch(matchesProvider).value ?? const <WcMatch>[];

    // Auto-resolve picks against finished matches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final results = <String, (int?, int?, bool)>{};
      for (final m in matches) {
        results[m.id] = (m.homeScore, m.awayScore, m.isFinished);
      }
      ref.read(contestProvider.notifier).resolve(results);
    });

    // Favorite team's upcoming/live matches first
    final fav = user.favoriteTeam;
    final favMatches = fav == null
        ? <WcMatch>[]
        : matches.where((m) => (m.homeName == fav || m.awayName == fav) && !m.isFinished).toList();
    final otherUpcoming = matches.where((m) => !m.isFinished && !favMatches.contains(m)).take(20).toList();
    final pending = contest.picks.where((p) => p.status == PickStatus.pending).toList();
    final settled = contest.picks.where((p) => p.status != PickStatus.pending).toList();

    return ListView(padding: const EdgeInsets.all(12), children: [
      _Balance(caps: contest.caps, user: user),
      const SizedBox(height: 16),
      if (favMatches.isNotEmpty) ...[
        _SectionTitle('Your Team: ${fav ?? "—"}', icon: '⭐'),
        ...favMatches.map((m) => _MatchPickCard(m: m)),
        const SizedBox(height: 16),
      ],
      if (pending.isNotEmpty) ...[
        _SectionTitle('Active Picks (${pending.length})', icon: '⏳'),
        ...pending.map((p) => _PickTile(pick: p)),
        const SizedBox(height: 16),
      ],
      _SectionTitle('Other Matches', icon: '⚽'),
      ...otherUpcoming.map((m) => _MatchPickCard(m: m)),
      const SizedBox(height: 16),
      if (settled.isNotEmpty) ...[
        _SectionTitle('History', icon: '📜'),
        ...settled.reversed.take(20).map((p) => _PickTile(pick: p)),
      ],
    ]);
  }
}

class _Balance extends ConsumerWidget {
  final int caps;
  final UserState user;
  const _Balance({required this.caps, required this.user});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.goldSoft]),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(children: [
          const Text('🪙', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.mode == AuthMode.signedIn ? 'Hi ${user.name ?? ''}' : 'Guest', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 2),
            Text('$caps CAPS', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 26)),
          ])),
          if (caps < 100)
            TextButton(
              onPressed: () => ref.read(contestProvider.notifier).addCaps(500),
              style: TextButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('+500 (Test)'),
            ),
        ]),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String icon;
  const _SectionTitle(this.text, {required this.icon});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .3)),
        ]),
      );
}

class _MatchPickCard extends ConsumerWidget {
  final WcMatch m;
  const _MatchPickCard({required this.m});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contest = ref.watch(contestProvider);
    final existing = contest.picks.firstWhere(
      (p) => p.matchId == m.id,
      orElse: () => Pick(matchId: '', homeTeam: '', awayTeam: '', side: PickSide.home, stake: 0, status: PickStatus.pending, createdAt: DateTime.now()),
    );
    final hasPick = existing.matchId.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: .55))),
      child: Column(children: [
        Row(children: [
          Expanded(child: _team(m.homeName.isEmpty ? 'TBD' : m.homeName, m.homeFlag)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(DateFormat('MMM d · HH:mm').format(m.date), style: const TextStyle(fontSize: 10, color: AppTheme.muted, fontWeight: FontWeight.w600))),
          Expanded(child: _team(m.awayName.isEmpty ? 'TBD' : m.awayName, m.awayFlag)),
        ]),
        const SizedBox(height: 10),
        if (hasPick)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: AppTheme.usaBlue.withValues(alpha: .1), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.check_circle, color: AppTheme.usaBlue, size: 16),
              const SizedBox(width: 6),
              Text('You staked ${existing.stake} on ${existing.side.name.toUpperCase()}', style: const TextStyle(color: AppTheme.usaBlue, fontWeight: FontWeight.w700, fontSize: 12)),
            ]),
          )
        else
          Row(children: [
            Expanded(child: _btn('HOME', PickSide.home, m, ref)),
            const SizedBox(width: 6),
            Expanded(child: _btn('DRAW', PickSide.draw, m, ref)),
            const SizedBox(width: 6),
            Expanded(child: _btn('AWAY', PickSide.away, m, ref)),
          ]),
      ]),
    );
  }

  Widget _team(String name, String flag) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (flag.isNotEmpty) SizedBox(width: 22, height: 16, child: CachedNetworkImage(imageUrl: flag, fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())),
        const SizedBox(width: 5),
        Flexible(child: Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
      ]);

  Widget _btn(String label, PickSide side, WcMatch m, WidgetRef ref) => OutlinedButton(
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), foregroundColor: AppTheme.primary),
        onPressed: () => _showStakeSheet(ref, m, side, label),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );

  void _showStakeSheet(WidgetRef ref, WcMatch m, PickSide side, String label) {
    final ctx = ref.context;
    final ctrl = TextEditingController(text: '50');
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Stake on $label', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('${m.homeName} vs ${m.awayName}', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 16),
          TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Caps to stake', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () async {
              final amt = int.tryParse(ctrl.text.trim()) ?? 0;
              final ok = await ref.read(contestProvider.notifier).placePick(
                matchId: m.id, homeTeam: m.homeName, awayTeam: m.awayName, side: side, stake: amt,
              );
              if (ctx.mounted) Navigator.pop(ctx);
              if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(ok ? 'Pick placed: $amt caps on $label' : 'Failed (insufficient caps or already picked)')));
            },
            child: const Text('Place Pick', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  final Pick pick;
  const _PickTile({required this.pick});
  @override
  Widget build(BuildContext context) {
    final color = pick.status == PickStatus.won ? AppTheme.win : pick.status == PickStatus.lost ? AppTheme.live : AppTheme.muted;
    final label = pick.status == PickStatus.won ? 'WON +${pick.payout}' : pick.status == PickStatus.lost ? 'LOST -${pick.stake}' : 'PENDING';
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: .55))),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${pick.homeTeam} vs ${pick.awayTeam}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 2),
          Text('${pick.side.name.toUpperCase()} · ${pick.stake} caps', style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(6)),
          child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10)),
        ),
      ]),
    );
  }
}
