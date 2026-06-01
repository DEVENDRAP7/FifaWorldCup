import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../providers/providers.dart';
import '../providers/auth_provider.dart';
import '../providers/vote_provider.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';

class ContestScreen extends ConsumerWidget {
  const ContestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    ref.watch(myVotesProvider); // rebuild on my pick change
    ref.watch(votesStreamProvider); // rebuild on live crowd change
    final matches = ref.watch(matchesProvider).value ?? const <WcMatch>[];

    final fav = user.favoriteTeam;
    final favMatches = fav == null
        ? <WcMatch>[]
        : matches.where((m) => (m.homeName == fav || m.awayName == fav) && !m.isFinished).toList();
    final otherUpcoming =
        matches.where((m) => !m.isFinished && !favMatches.contains(m)).take(30).toList();

    return ListView(padding: const EdgeInsets.all(12), children: [
      const _Hero(),
      const SizedBox(height: 16),
      if (favMatches.isNotEmpty) ...[
        _SectionTitle('Your Team: ${fav ?? "—"}', icon: '⭐'),
        ...favMatches.map((m) => _VoteCard(m: m)),
        const SizedBox(height: 16),
      ],
      _SectionTitle('Upcoming Matches', icon: '⚽'),
      if (otherUpcoming.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: Text('No upcoming matches yet', style: TextStyle(color: Colors.white70))),
        )
      else
        ...otherUpcoming.map((m) => _VoteCard(m: m)),
    ]);
  }
}

class _Hero extends StatelessWidget {
  const _Hero();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.gold, AppTheme.goldSoft]),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(children: const [
          Text('🗳️', style: TextStyle(fontSize: 34)),
          SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Who will win?',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20)),
              SizedBox(height: 2),
              Text('Vote your pick — see how the world leans',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12)),
            ]),
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
          Text(text, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .3, color: Colors.white)),
        ]),
      );
}

// Round three percentages so they always sum to exactly 100 (0,0,0 when no votes).
List<int> _round100(double a, double b, double c) {
  if (a + b + c <= 0) return const [0, 0, 0];
  final xs = [a, b, c];
  final floors = xs.map((e) => e.floor()).toList();
  var rem = 100 - floors.reduce((x, y) => x + y);
  final order = [0, 1, 2]..sort((i, j) => (xs[j] - floors[j]).compareTo(xs[i] - floors[i]));
  for (var i = 0; i < rem && i < 3; i++) {
    floors[order[i]]++;
  }
  return floors;
}

class _VoteCard extends ConsumerWidget {
  final WcMatch m;
  const _VoteCard({required this.m});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(myVotesProvider.notifier);
    final picked = ref.watch(myVotesProvider)[m.id];
    final voted = picked != null;
    final real = ref.watch(votesStreamProvider).value ?? const <String, MatchVotes>{};
    final votes = displayVotes(m.id, real);
    final hasVotes = votes.total > 0; // show live % once any vote exists
    final p = _round100(votes.pct(VoteSide.home), votes.pct(VoteSide.draw), votes.pct(VoteSide.away));

    void cast(VoteSide side) {
      notifier.vote(m.id, side); // same pick undoes inside notifier
      AdService.instance.maybeShowInterstitial();
    }

    const homeTint = Color(0xFF3B82F6); // blue
    const drawTint = Color(0xFF9CA3AF); // grey
    const awayTint = Color(0xFFEF4444); // red

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DFFFFFF)),
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: _teamHead(m.homeName.isEmpty ? 'TBD' : m.homeName, m.homeFlag)),
          Text(DateFormat('MMM d · HH:mm').format(m.date),
              style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600)),
          Expanded(child: _teamHead(m.awayName.isEmpty ? 'TBD' : m.awayName, m.awayFlag, right: true)),
        ]),
        const SizedBox(height: 10),
        _option(
          label: m.homeName.isEmpty ? 'Home' : m.homeName,
          flag: m.homeFlag,
          tint: homeTint,
          pct: p[0],
          picked: picked == VoteSide.home,
          voted: hasVotes,
          onTap: () => cast(VoteSide.home),
        ),
        _option(
          label: 'Draw',
          tint: drawTint,
          pct: p[1],
          picked: picked == VoteSide.draw,
          voted: hasVotes,
          onTap: () => cast(VoteSide.draw),
        ),
        _option(
          label: m.awayName.isEmpty ? 'Away' : m.awayName,
          flag: m.awayFlag,
          tint: awayTint,
          pct: p[2],
          picked: picked == VoteSide.away,
          voted: hasVotes,
          onTap: () => cast(VoteSide.away),
        ),
        const SizedBox(height: 2),
        Text(
          !hasVotes
              ? 'Be the first to vote'
              : voted
                  ? '${votes.total} votes · tap your pick to undo'
                  : '${votes.total} votes · tap a team to vote',
          style: const TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }

  Widget _teamHead(String name, String flag, {bool right = false}) => Row(
        mainAxisAlignment: right ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!right && flag.isNotEmpty) ...[_flag(flag), const SizedBox(width: 6)],
          Flexible(
            child: Text(name,
                textAlign: right ? TextAlign.right : TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          if (right && flag.isNotEmpty) ...[const SizedBox(width: 6), _flag(flag)],
        ],
      );

  Widget _flag(String url) => Container(
        width: 24,
        height: 17,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => const SizedBox.shrink(),
        ),
      );

  Widget _option({
    required String label,
    String? flag,
    required Color tint,
    required int pct,
    required bool picked,
    required bool voted,
    required VoidCallback onTap,
  }) {
    final accent = picked ? AppTheme.gold : tint;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0x14FFFFFF),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: picked ? AppTheme.gold : const Color(0x33FFFFFF),
            width: picked ? 1.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
            if (voted)
              FractionallySizedBox(
                widthFactor: (pct / 100.0).clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      accent.withValues(alpha: picked ? .60 : .48),
                      accent.withValues(alpha: picked ? .34 : .22),
                    ]),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                if (flag != null && flag.isNotEmpty) ...[_flag(flag), const SizedBox(width: 8)],
                Expanded(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                if (picked) ...[
                  const Icon(Icons.check_circle, size: 15, color: AppTheme.gold),
                  const SizedBox(width: 6),
                ],
                if (voted)
                  Text('$pct%',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white))
                else
                  const Icon(Icons.radio_button_unchecked, size: 16, color: Colors.white38),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
