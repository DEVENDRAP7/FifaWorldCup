import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Stadium scoreboard masthead — dark board panel, yellow trim, LED-style
/// countdown numerals.
class HeroHeader extends StatefulWidget {
  final int totalMatches;
  final int liveCount;
  const HeroHeader({super.key, required this.totalMatches, required this.liveCount});
  @override
  State<HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<HeroHeader> {
  static final _kickoff = DateTime(2026, 6, 11, 19, 0).toLocal();
  Timer? _tick;
  Duration _left = const Duration();

  @override
  void initState() {
    super.initState();
    _left = _kickoff.difference(DateTime.now());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _left = _kickoff.difference(DateTime.now()));
    });
  }

  @override
  void dispose() { _tick?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final started = _left.isNegative;
    final d = _left.inDays.abs();
    final h = _left.inHours.remainder(24).abs();
    final m = _left.inMinutes.remainder(60).abs();
    final s = _left.inSeconds.remainder(60).abs();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: BoxDecoration(
        color: AppTheme.deep,
        borderRadius: BorderRadius.circular(AppTheme.rLg),
        border: Border.all(color: AppTheme.accent, width: 2),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Board header bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.rLg - 2)),
          ),
          child: Row(children: [
            const Icon(Icons.sports_soccer, size: 16, color: AppTheme.deep),
            const SizedBox(width: 8),
            Text('FIFA WORLD CUP 2026', style: AppTheme.overline.copyWith(color: AppTheme.deep, fontSize: 11, letterSpacing: 1.4)),
            const Spacer(),
            Text('USA · CAN · MEX', style: AppTheme.overline.copyWith(color: AppTheme.deep, fontSize: 9, letterSpacing: 1)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('2026', style: AppTheme.displayLg.copyWith(color: AppTheme.accent, fontSize: 58, height: 0.8)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('THE WORLD', style: AppTheme.headline.copyWith(fontSize: 18, height: 1.0)),
                Text('CUP', style: AppTheme.headline.copyWith(fontSize: 18, height: 1.0, color: AppTheme.accent)),
              ]),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Container(width: 16, height: 2, color: AppTheme.accent),
              const SizedBox(width: 8),
              Text(started ? 'TOURNAMENT IN PROGRESS' : 'KICK-OFF COUNTDOWN',
                  style: AppTheme.overline.copyWith(fontSize: 10, letterSpacing: 1.8, color: AppTheme.muted)),
            ]),
            const SizedBox(height: 10),
            if (!started)
              Row(children: [
                _box(d.toString().padLeft(2, '0'), 'DAYS'),
                const SizedBox(width: 8),
                _box(h.toString().padLeft(2, '0'), 'HRS'),
                const SizedBox(width: 8),
                _box(m.toString().padLeft(2, '0'), 'MIN'),
                const SizedBox(width: 8),
                _box(s.toString().padLeft(2, '0'), 'SEC'),
              ])
            else
              Row(children: [
                _stat('${widget.liveCount}', 'LIVE', live: widget.liveCount > 0),
                const SizedBox(width: 8),
                _stat('${widget.totalMatches}', 'MATCHES'),
              ]),
          ]),
        ),
      ]),
    );
  }

  Widget _box(String val, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.bg,
            borderRadius: BorderRadius.circular(AppTheme.rSm),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: [
            Text(val, style: AppTheme.numeric.copyWith(fontSize: 34, color: AppTheme.accent)),
            Text(label, style: AppTheme.overline.copyWith(fontSize: 8.5, letterSpacing: 1.4, color: AppTheme.muted)),
          ]),
        ),
      );

  Widget _stat(String val, String label, {bool live = false}) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: live ? AppTheme.red : AppTheme.bg,
            borderRadius: BorderRadius.circular(AppTheme.rSm),
            border: Border.all(color: live ? AppTheme.red : AppTheme.border),
          ),
          child: Row(children: [
            Text(val, style: AppTheme.numeric.copyWith(fontSize: 30, color: live ? Colors.white : AppTheme.accent)),
            const SizedBox(width: 10),
            Text(label, style: AppTheme.overline.copyWith(fontSize: 9, letterSpacing: 1.2, color: live ? Colors.white : AppTheme.muted)),
          ]),
        ),
      );
}
