import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/live_badge.dart';
import '../widgets/banner_ad_widget.dart';

class MatchDetailScreen extends ConsumerWidget {
  final WcMatch m;
  const MatchDetailScreen({super.key, required this.m});

  String get _title => m.groupName.isNotEmpty ? m.groupName : (m.stage.isEmpty ? 'Match' : m.stage);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFT = m.isFinished;
    final hW = isFT && (m.homeScore ?? 0) > (m.awayScore ?? 0);
    final aW = isFT && (m.awayScore ?? 0) > (m.homeScore ?? 0);
    final detail = ref.watch(matchDetailProvider(m));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF1B1330), Color(0xFF2A1A36), Color(0xFF3A1F35), Color(0xFF5A2530)],
          stops: [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(_title),
      ),
      // Banner pinned at the bottom, clear of the system nav bar on every device.
      bottomNavigationBar: const SafeArea(top: false, child: BannerAdWidget()),
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

          detail.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 28),
              child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.gold))),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (d) {
              if (d == null) return const SizedBox.shrink();
              // Players who scored / assisted → badges on their pitch token.
              final scorers = {
                for (final e in d.events)
                  if (e.kind == EventKind.goal || e.kind == EventKind.penaltyGoal || e.kind == EventKind.ownGoal) e.player,
              }..removeWhere((s) => s.isEmpty);
              final assisters = {
                for (final e in d.events)
                  if ((e.kind == EventKind.goal || e.kind == EventKind.penaltyGoal) && e.detail.isNotEmpty) e.detail,
              };
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (d.referee.isNotEmpty) _row('Referee', d.referee),
                if (d.attendance != null && d.attendance! > 0) _row('Attendance', NumberFormat.decimalPattern().format(d.attendance)),

                if (d.hasStats) ...[
                  _SectionTitle('Match Statistics', homeName: m.homeName, awayName: m.awayName, homeFlag: m.homeFlag, awayFlag: m.awayFlag),
                  _StatBars(stats: d.stats),
                ] else if (d.hasPossession) ...[
                  _SectionTitle('Match Statistics', homeName: m.homeName, awayName: m.awayName, homeFlag: m.homeFlag, awayFlag: m.awayFlag),
                  _StatBars(stats: [StatRow('Possession', d.possHome.round(), d.possAway.round(), percent: true)]),
                ],

                if (d.hasEvents) ...[
                  _sectionLabel('Key Events'),
                  ...d.events.map((e) => _EventRow(e: e)),
                ],

                if (d.hasLineups) ...[
                  _sectionLabel('Lineups'),
                  if (d.home.starters.isNotEmpty) _PitchTeam(name: m.homeName, flag: m.homeFlag, team: d.home, scorers: scorers, assisters: assisters),
                  if (d.away.starters.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _PitchTeam(name: m.awayName, flag: m.awayFlag, team: d.away, scorers: scorers, assisters: assisters),
                  ],
                ],
              ]);
            },
          ),
          const SizedBox(height: 24),
        ]),
      ),
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
          SizedBox(width: 96, child: Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _sectionLabel(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 26, 0, 12),
        child: Row(children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(t.toUpperCase(), style: AppTheme.overline.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 1.5)),
        ]),
      );
}

// ── Stats: home value | split bar | away value (Sportmonks style) ──
class _SectionTitle extends StatelessWidget {
  final String title;
  final String homeName, awayName, homeFlag, awayFlag;
  const _SectionTitle(this.title, {required this.homeName, required this.awayName, required this.homeFlag, required this.awayFlag});
  String _abbr(String n) => n.isEmpty ? '—' : (n.length <= 3 ? n.toUpperCase() : n.substring(0, 3).toUpperCase());

  Widget _flag(String url) => url.isEmpty
      ? const SizedBox(width: 24, height: 16)
      : ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(width: 24, height: 16, child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())),
        );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 26, 0, 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _flag(homeFlag),
          const SizedBox(width: 6),
          Text(_abbr(homeName), style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(width: 12),
          Text(title.toUpperCase(), style: AppTheme.overline.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(width: 12),
          Text(_abbr(awayName), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(width: 6),
          _flag(awayFlag),
        ]),
      );
}

class _StatBars extends StatelessWidget {
  final List<StatRow> stats;
  const _StatBars({required this.stats});
  @override
  Widget build(BuildContext context) => Column(children: stats.map(_bar).toList());

  Widget _bar(StatRow s) {
    final h = s.home.toDouble();
    final a = s.away.toDouble();
    final total = (h + a) == 0 ? 1.0 : (h + a);
    final hf = ((h / total) * 1000).round().clamp(1, 1000);
    final af = ((a / total) * 1000).round().clamp(1, 1000);
    final homeMore = h >= a;
    String fmt(num v) => s.percent ? '${v.round()}%' : '${v.round()}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(children: [
        Text(s.label, style: AppTheme.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.5)),
        const SizedBox(height: 6),
        Row(children: [
          SizedBox(width: 42, child: Text(fmt(s.home), textAlign: TextAlign.left, style: TextStyle(color: homeMore ? AppTheme.gold : AppTheme.muted, fontWeight: FontWeight.w900, fontSize: 14))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(children: [
                Expanded(flex: hf, child: Container(height: 7, color: homeMore ? AppTheme.gold : const Color(0x55D4AF37))),
                const SizedBox(width: 2),
                Expanded(flex: af, child: Container(height: 7, color: !homeMore ? Colors.white : const Color(0x44FFFFFF))),
              ]),
            ),
          ),
          SizedBox(width: 42, child: Text(fmt(s.away), textAlign: TextAlign.right, style: TextStyle(color: !homeMore ? Colors.white : AppTheme.muted, fontWeight: FontWeight.w900, fontSize: 14))),
        ]),
      ]),
    );
  }
}

class _EventRow extends StatelessWidget {
  final MatchEvent e;
  const _EventRow({required this.e});

  ({IconData icon, Color color, String label}) get _meta => switch (e.kind) {
        EventKind.goal => (icon: Icons.sports_soccer, color: AppTheme.win, label: 'Goal'),
        EventKind.penaltyGoal => (icon: Icons.sports_soccer, color: AppTheme.win, label: 'Penalty'),
        EventKind.ownGoal => (icon: Icons.sports_soccer, color: AppTheme.live, label: 'Own goal'),
        EventKind.yellow => (icon: Icons.square, color: const Color(0xFFFBBF24), label: 'Yellow'),
        EventKind.red => (icon: Icons.square, color: AppTheme.live, label: 'Red'),
        EventKind.sub => (icon: Icons.swap_horiz, color: AppTheme.muted, label: 'Sub'),
      };

  @override
  Widget build(BuildContext context) {
    final meta = _meta;
    final sub = e.kind == EventKind.sub
        ? (e.detail.isEmpty ? '' : 'Off: ${e.detail}')
        : (e.detail.isEmpty ? '' : 'Assist: ${e.detail}');
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: e.home ? AppTheme.gold : const Color(0x66FFFFFF), width: 3)),
      ),
      child: Row(children: [
        SizedBox(width: 34, child: Text("${e.minute}'", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
        Icon(meta.icon, size: 15, color: meta.color),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.player.isEmpty ? meta.label : e.player, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
          if (sub.isNotEmpty) Text(sub, style: AppTheme.caption.copyWith(fontSize: 11)),
        ])),
      ]),
    );
  }
}

// ── Pitch view: players positioned by LineupX/Y ──────────────────
// Position → accent colour for the token ring.
Color _posColor(int pos) => switch (pos) {
      0 => const Color(0xFFFBBF24), // GK amber
      1 => const Color(0xFF38BDF8), // DEF blue
      2 => const Color(0xFF34D399), // MID green
      3 => const Color(0xFFFB7185), // FWD red
      _ => Colors.white,
    };

class _PitchTeam extends StatelessWidget {
  final String name;
  final String flag;
  final TeamLineup team;
  final Set<String> scorers;
  final Set<String> assisters;
  const _PitchTeam({required this.name, required this.flag, required this.team, this.scorers = const {}, this.assisters = const {}});

  @override
  Widget build(BuildContext context) {
    final starters = team.starters;
    final ys = starters.map((p) => p.y).toList();
    final minY = ys.isEmpty ? 1.0 : ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.isEmpty ? 12.0 : ys.reduce((a, b) => a > b ? a : b);
    final spanY = (maxY - minY).abs() < 0.001 ? 1.0 : (maxY - minY);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        color: AppTheme.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          color: const Color(0x22000000),
          child: Row(children: [
            if (flag.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(width: 26, height: 18, child: CachedNetworkImage(imageUrl: flag, fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(name.isEmpty ? 'Team' : name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (team.tactics.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.gold, Color(0xFFF5D76E)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(team.tactics, style: const TextStyle(color: Color(0xFF1F1F22), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5)),
              ),
          ]),
        ),
        AspectRatio(
          aspectRatio: 0.72,
          child: CustomPaint(
            painter: _PitchPainter(),
            child: LayoutBuilder(builder: (ctx, c) {
              final w = c.maxWidth, h = c.maxHeight;
              const tok = 40.0;
              return Stack(children: starters.map((p) {
                final xN = (p.x / 20.0).clamp(0.0, 1.0);
                final yN = ((p.y - minY) / spanY).clamp(0.0, 1.0);
                final left = (0.09 + xN * 0.82) * w - 32;
                final top = (0.90 - yN * 0.80) * h - tok / 2; // GK bottom, FWD top
                return Positioned(left: left, top: top, child: _token(p, tok));
              }).toList());
            }),
          ),
        ),
        if (team.subs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.event_seat, size: 12, color: AppTheme.muted),
                const SizedBox(width: 6),
                Text('SUBSTITUTES', style: AppTheme.overline.copyWith(fontSize: 9)),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: team.subs.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('${p.shirt}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, fontSize: 11)),
                  const SizedBox(width: 5),
                  Text(p.shortName, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                ]),
              )).toList()),
            ]),
          ),
      ]),
    );
  }

  Widget _token(LineupPlayer p, double size) {
    final ring = _posColor(p.position);
    final scored = scorers.contains(p.name);
    final assisted = assisters.contains(p.name);
    return SizedBox(
      width: 64,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            width: size, height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A1F40), Color(0xFF130D22)]),
              shape: BoxShape.circle,
              border: Border.all(color: ring, width: 2),
              boxShadow: [
                const BoxShadow(color: Color(0x73000000), blurRadius: 6, offset: Offset(0, 3)),
                BoxShadow(color: ring.withValues(alpha: 0.35), blurRadius: 8),
              ],
            ),
            alignment: Alignment.center,
            child: Text('${p.shirt}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
          ),
          if (p.captain)
            Positioned(
              right: -3, top: -3,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF130D22), width: 1.5)),
                alignment: Alignment.center,
                child: const Text('C', style: TextStyle(color: Color(0xFF1F1F22), fontSize: 9, fontWeight: FontWeight.w900)),
              ),
            ),
          // Goal (ball) badge — top-left
          if (scored)
            Positioned(
              left: -4, top: -4,
              child: Container(
                width: 17, height: 17,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF130D22), width: 1.5)),
                alignment: Alignment.center,
                child: const Icon(Icons.sports_soccer, size: 11, color: Color(0xFF130D22)),
              ),
            ),
          // Assist (leg) badge — bottom-left
          if (assisted)
            Positioned(
              left: -4, bottom: -4,
              child: Container(
                width: 17, height: 17,
                decoration: BoxDecoration(color: AppTheme.win, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF130D22), width: 1.5)),
                alignment: Alignment.center,
                child: const Icon(Icons.directions_run, size: 11, color: Colors.white),
              ),
            ),
        ]),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(color: const Color(0xCC0B0814), borderRadius: BorderRadius.circular(4)),
          child: Text(p.shortName,
              maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // grass: vertical stripes + top→bottom shade
    for (int i = 0; i < 7; i++) {
      final p = Paint()..color = i.isEven ? const Color(0xFF1F7E3E) : const Color(0xFF1A6E35);
      canvas.drawRect(Rect.fromLTWH(w / 7 * i, 0, w / 7, h), p);
    }
    canvas.drawRect(Offset.zero & size, Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x22000000), Color(0x00000000), Color(0x33000000)]).createShader(Offset.zero & size));

    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final inset = w * 0.045;
    final l = inset, r = w - inset, t = inset, b = h - inset;
    canvas.drawRect(Rect.fromLTRB(l, t, r, b), line);
    canvas.drawLine(Offset(l, h / 2), Offset(r, h / 2), line);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.14, line);
    canvas.drawCircle(Offset(w / 2, h / 2), 2.5, Paint()..color = Colors.white.withValues(alpha: 0.7));

    // penalty + 6-yard boxes + spots + D arcs (both ends)
    final boxW = w * 0.46, boxH = h * 0.15;
    final sixW = w * 0.22, sixH = h * 0.06;
    for (final top in [true, false]) {
      final by = top ? t : b - boxH;
      final sy = top ? t : b - sixH;
      canvas.drawRect(Rect.fromLTWH((w - boxW) / 2, by, boxW, boxH), line);
      canvas.drawRect(Rect.fromLTWH((w - sixW) / 2, sy, sixW, sixH), line);
      final spotY = top ? t + boxH * 0.66 : b - boxH * 0.66;
      canvas.drawCircle(Offset(w / 2, spotY), 2, Paint()..color = Colors.white.withValues(alpha: 0.7));
      final arcRect = Rect.fromCircle(center: Offset(w / 2, top ? t + boxH : b - boxH), radius: w * 0.11);
      canvas.drawArc(arcRect, top ? 0.5 : 3.64, 2.1, false, line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
