import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../theme/app_theme.dart';
import '../widgets/live_badge.dart';

class MatchDetailScreen extends StatelessWidget {
  final WcMatch m;
  const MatchDetailScreen({super.key, required this.m});

  String get _title => m.groupName.isNotEmpty ? m.groupName : (m.stage.isEmpty ? 'Match' : m.stage);

  @override
  Widget build(BuildContext context) {
    final isFT = m.isFinished;
    final hW = isFT && (m.homeScore ?? 0) > (m.awayScore ?? 0);
    final aW = isFT && (m.awayScore ?? 0) > (m.homeScore ?? 0);
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (m.isLive) const Center(child: LiveBadge()),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _team(m.homeName.isEmpty ? 'TBD' : m.homeName, m.homeFlag, hW)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: m.isUpcoming
                  ? const Text('VS', style: TextStyle(color: AppTheme.muted, fontSize: 22, fontWeight: FontWeight.w800))
                  : Text('${m.homeScore ?? 0}  -  ${m.awayScore ?? 0}',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
            ),
            Expanded(child: _team(m.awayName.isEmpty ? 'TBD' : m.awayName, m.awayFlag, aW)),
          ]),
          const SizedBox(height: 10),
          Center(
            child: Text(
              m.isLive ? '🔴 LIVE'
                  : m.isFinished ? 'Full Time'
                  : '${DateFormat('EEE, MMM d').format(m.date)} · ${DateFormat.Hm().format(m.date)}',
              style: TextStyle(color: m.isLive ? AppTheme.live : AppTheme.muted, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(height: 32, color: AppTheme.border),
          if (m.stage.isNotEmpty) _row('Stage', m.stage),
          if (m.groupName.isNotEmpty) _row('Group', m.groupName),
          _row('Date', DateFormat('EEEE, MMM d, y · HH:mm').format(m.date)),
          if (m.venue.isNotEmpty) _row('Venue', m.venue),
          if (m.city.isNotEmpty) _row('City', m.city),
          if (m.homePenScore != null && m.awayPenScore != null)
            _row('Penalties', '${m.homePenScore} - ${m.awayPenScore}'),
        ]),
      ),
    );
  }

  Widget _team(String name, String flag, bool winner) => Column(children: [
        if (flag.isNotEmpty) SizedBox(height: 48, width: 72, child: CachedNetworkImage(imageUrl: flag, fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())),
        const SizedBox(height: 10),
        Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: winner ? AppTheme.win : AppTheme.text)),
      ]);

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );
}
