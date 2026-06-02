import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../theme/app_theme.dart';
import 'live_badge.dart';
import 'flag.dart';

class MatchCard extends StatelessWidget {
  final WcMatch m;
  final VoidCallback? onTap;
  const MatchCard({super.key, required this.m, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLive = m.isLive;
    final isFT = m.isFinished;
    final isNS = m.isUpcoming;
    final hW = isFT && (m.homeScore ?? 0) > (m.awayScore ?? 0);
    final aW = isFT && (m.awayScore ?? 0) > (m.homeScore ?? 0);
    final stage = m.groupName.isNotEmpty ? m.groupName : (m.stage.isEmpty ? 'World Cup' : m.stage);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.rLg),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            border: Border.all(color: isLive ? AppTheme.red : AppTheme.border, width: isLive ? 1.6 : 1),
            boxShadow: isLive
                ? [BoxShadow(color: AppTheme.red.withValues(alpha: .3), blurRadius: 14)]
                : AppTheme.shadowSm,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Scoreboard header
            Container(
              padding: const EdgeInsets.fromLTRB(14, 7, 10, 7),
              decoration: BoxDecoration(
                color: isLive ? AppTheme.red.withValues(alpha: .18) : AppTheme.deep,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.rLg - 1)),
              ),
              child: Row(children: [
                const Icon(Icons.stadium_outlined, size: 13, color: AppTheme.accent),
                const SizedBox(width: 7),
                Flexible(child: Text(stage.toUpperCase(), style: AppTheme.overline.copyWith(fontSize: 10.5, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                const Spacer(),
                if (isLive) const LiveBadge(compact: true) else _statusChip(isFT, isNS),
              ]),
            ),
            // Teams + score
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: _team(m.homeName.isEmpty ? 'TBD' : m.homeName, m.homeFlag, hW, isFT)),
                _scoreBlock(isNS, isLive),
                Expanded(child: _team(m.awayName.isEmpty ? 'TBD' : m.awayName, m.awayFlag, aW, isFT)),
              ]),
            ),
            // Footer
            if (m.venue.isNotEmpty || m.city.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: const BoxDecoration(
                  color: AppTheme.deep,
                  border: Border(top: BorderSide(color: AppTheme.border)),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppTheme.rLg - 1)),
                ),
                child: Row(children: [
                  const Icon(Icons.place_outlined, size: 13, color: AppTheme.muted),
                  const SizedBox(width: 6),
                  Expanded(child: Text([m.venue, m.city].where((s) => s.isNotEmpty).join(' · '), style: AppTheme.caption.copyWith(fontSize: 11.5), overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.chevron_right, color: AppTheme.accent, size: 16),
                ]),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _team(String name, String flag, bool winner, bool isFT) {
    final faded = isFT && !winner && name != 'TBD';
    return Opacity(
      opacity: faded ? 0.55 : 1.0,
      child: Column(children: [
        FlagImage(url: flag, width: 52, height: 36, radius: 3),
        const SizedBox(height: 10),
        Text(name.toUpperCase(),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: AppTheme.teamName.copyWith(
              fontSize: 14,
              color: winner ? AppTheme.accent : (name == 'TBD' ? AppTheme.muted : AppTheme.text),
            )),
        if (winner) ...[
          const SizedBox(height: 5),
          Container(width: 18, height: 3, decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(2))),
        ],
      ]),
    );
  }

  Widget _scoreBlock(bool isNS, bool isLive) {
    if (isNS) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.deep,
            borderRadius: BorderRadius.circular(AppTheme.rSm),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: [
            Text(DateFormat.Hm().format(m.date), style: AppTheme.numeric.copyWith(fontSize: 24, color: AppTheme.accent)),
            Text(DateFormat('MMM d').format(m.date).toUpperCase(), style: AppTheme.overline.copyWith(fontSize: 8.5, color: AppTheme.muted)),
          ]),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.deep,
          borderRadius: BorderRadius.circular(AppTheme.rSm),
          border: Border.all(color: isLive ? AppTheme.red : AppTheme.border),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text('${m.homeScore ?? 0} ${m.awayScore ?? 0}',
              key: ValueKey('${m.homeScore}-${m.awayScore}'),
              style: AppTheme.numeric.copyWith(color: isLive ? AppTheme.red : AppTheme.text, fontSize: 40, letterSpacing: 6)),
        ),
      ),
    );
  }

  Widget _statusChip(bool isFT, bool isNS) {
    if (isFT) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(4)),
        child: Text('FULL TIME', style: AppTheme.overline.copyWith(color: AppTheme.muted, fontSize: 9)),
      );
    }
    if (isNS) {
      return Text('UPCOMING', style: AppTheme.overline.copyWith(color: AppTheme.muted, fontSize: 9));
    }
    return const SizedBox.shrink();
  }
}
