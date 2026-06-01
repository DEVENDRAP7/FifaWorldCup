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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            border: Border.all(
              color: isLive ? const Color(0xFFFFD700) : const Color(0x4DFFFFFF),
              width: isLive ? 1.5 : 1,
            ),
            boxShadow: isLive
                ? [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: .35), blurRadius: 16, spreadRadius: 0)]
                : AppTheme.shadowSm,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Top strip
              Container(
                padding: const EdgeInsets.fromLTRB(AppTheme.s16, 10, AppTheme.s12, 10),
                decoration: BoxDecoration(
                  color: isLive
                      ? AppTheme.live.withValues(alpha: .10)
                      : (isFT ? AppTheme.mutedSoft.withValues(alpha: .25) : AppTheme.primary.withValues(alpha: .12)),
                  border: const Border(bottom: BorderSide(color: AppTheme.border)),
                ),
                child: Row(children: [
                  Flexible(child: Text(stage.toUpperCase(), style: AppTheme.overline.copyWith(color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                  const Spacer(),
                  if (isLive) const LiveBadge(compact: true) else _statusChip(isFT, isNS, m),
                ]),
              ),
              // Teams + score
              Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.s16, AppTheme.s20, AppTheme.s16, AppTheme.s16),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: _team(m.homeName.isEmpty ? 'TBD' : m.homeName, m.homeFlag, hW, isFT)),
                  _scoreBlock(isNS, m, isLive),
                  Expanded(child: _team(m.awayName.isEmpty ? 'TBD' : m.awayName, m.awayFlag, aW, isFT)),
                ]),
              ),
              // Footer
              if (m.venue.isNotEmpty || m.city.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.bg.withValues(alpha: .4),
                    border: const Border(top: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.stadium_outlined, size: 13, color: Colors.white),
                    const SizedBox(width: 6),
                    Expanded(child: Text([m.venue, m.city].where((s) => s.isNotEmpty).join(' · '), style: AppTheme.caption.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis)),
                    const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                  ]),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _team(String name, String flag, bool winner, bool isFT) {
    final faded = isFT && !winner && name != 'TBD';
    return Opacity(
      opacity: faded ? 0.5 : 1.0,
      child: Column(children: [
        FlagImage(url: flag, width: 50, height: 34, radius: 4),
        const SizedBox(height: AppTheme.s12),
        Text(name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodyBold.copyWith(
              fontSize: 13,
              color: winner ? AppTheme.win : (name == 'TBD' ? AppTheme.muted : AppTheme.text),
              fontStyle: name == 'TBD' ? FontStyle.italic : FontStyle.normal,
            )),
        if (winner) ...[
          const SizedBox(height: 4),
          Container(width: 16, height: 2, decoration: BoxDecoration(color: AppTheme.win, borderRadius: BorderRadius.circular(1))),
        ],
      ]),
    );
  }

  Widget _scoreBlock(bool isNS, WcMatch m, bool isLive) {
    if (isNS) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.s12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: [
            Text(DateFormat.Hm().format(m.date), style: AppTheme.bodyBold.copyWith(fontSize: 13, color: AppTheme.text)),
            const SizedBox(height: 1),
            Text(DateFormat('MMM d').format(m.date), style: AppTheme.overline.copyWith(fontSize: 9)),
          ]),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.s12),
      child: Column(children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text('${m.homeScore ?? 0}  ${m.awayScore ?? 0}',
              key: ValueKey('${m.homeScore}-${m.awayScore}'),
              style: AppTheme.numeric.copyWith(color: isLive ? AppTheme.live : AppTheme.text, fontSize: 30, letterSpacing: 4)),
        ),
      ]),
    );
  }

  Widget _statusChip(bool isFT, bool isNS, WcMatch m) {
    if (isFT) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: AppTheme.muted.withValues(alpha: .12), borderRadius: BorderRadius.circular(6)),
        child: Text('FULL TIME', style: AppTheme.overline.copyWith(color: AppTheme.muted, fontSize: 9)),
      );
    }
    return const SizedBox.shrink();
  }
}
