import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 24, offset: Offset(0, 8)),
          BoxShadow(color: Color(0x33D4AF37), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          // Translucent white glass over sunrise bg
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.22),
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),
          // White hairline border via inset
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4DFFFFFF), width: 0.8),
                ),
              ),
            ),
          ),
          // Warm gold glow top-right
          Positioned(
            right: -50, top: -50,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFFFDE68A).withValues(alpha: .35), Colors.transparent]),
              ),
            ),
          ),
          // Soft peach glow bottom-left
          Positioned(
            left: -40, bottom: -40,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFFFCA5A5).withValues(alpha: .22), Colors.transparent]),
              ),
            ),
          ),
          // Top gold accent line
          Positioned(top: 0, left: 0, right: 0, child: Container(height: 1.5, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Color(0xFFD4AF37), Colors.transparent])))),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF5D76E)]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withValues(alpha: .5), blurRadius: 8)],
                  ),
                  child: const Text('WORLD CUP 2026', style: TextStyle(color: Color(0xFF1F1F22), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
                ),
                const Spacer(),
                _hostChip(),
              ]),
              const SizedBox(height: 18),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('2026', style: AppTheme.displayLg.copyWith(color: Colors.white, fontSize: 54, height: .9, letterSpacing: -2, fontWeight: FontWeight.w900)),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('WORLD CUP', style: AppTheme.overline.copyWith(color: const Color(0xFFFDE68A), fontSize: 11, letterSpacing: 2)),
                    const SizedBox(height: 2),
                    Text(started ? 'IN PROGRESS' : 'KICKOFF IN', style: AppTheme.caption.copyWith(color: Colors.white.withValues(alpha: 0.85), fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
              const SizedBox(height: 18),
              if (!started)
                Row(children: [
                  _timeBox(d.toString().padLeft(2, '0'), 'DAYS', const Color(0xFFFCD34D)),
                  const SizedBox(width: 8),
                  _timeBox(h.toString().padLeft(2, '0'), 'HRS', const Color(0xFFFB923C)),
                  const SizedBox(width: 8),
                  _timeBox(m.toString().padLeft(2, '0'), 'MIN', const Color(0xFFF87171)),
                  const SizedBox(width: 8),
                  _timeBox(s.toString().padLeft(2, '0'), 'SEC', const Color(0xFFEC4899)),
                ])
              else
                Row(children: [
                  _statBox('${widget.liveCount}', 'LIVE', accent: widget.liveCount > 0 ? const Color(0xFFEF4444) : Colors.white24, pulse: widget.liveCount > 0),
                  const SizedBox(width: 10),
                  _statBox('${widget.totalMatches}', 'MATCHES', accent: const Color(0xFFFCD34D)),
                ]),
              const SizedBox(height: 14),
              // Sunrise sweep underline
              SizedBox(
                height: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFFCD34D), Color(0xFFFB923C), Color(0xFFEC4899)]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _hostChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: .25)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _dot(const Color(0xFF22C55E)),
          const SizedBox(width: 4),
          _dot(Colors.white),
          const SizedBox(width: 4),
          _dot(const Color(0xFFEF4444)),
          const SizedBox(width: 8),
          Text('MEX·USA·CAN', style: AppTheme.overline.copyWith(color: Colors.white, fontSize: 9, letterSpacing: 1)),
        ]),
      );

  Widget _dot(Color c) => Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle, boxShadow: [BoxShadow(color: c.withValues(alpha: .6), blurRadius: 4)]));

  Widget _timeBox(String val, String label, Color accent) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.white.withValues(alpha: .18), Colors.white.withValues(alpha: .06)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: .55), width: 1.2),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: .22), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(children: [
            Text(val, style: AppTheme.numeric.copyWith(color: Colors.white, fontSize: 26, height: 1, letterSpacing: -1)),
            const SizedBox(height: 4),
            Container(width: 16, height: 2, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(1))),
            const SizedBox(height: 4),
            Text(label, style: AppTheme.overline.copyWith(color: Colors.white.withValues(alpha: .85), fontSize: 9, letterSpacing: 1.2)),
          ]),
        ),
      );

  Widget _statBox(String val, String label, {Color? accent, bool pulse = false}) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent ?? Colors.white24, width: 1.2),
          ),
          child: Row(children: [
            if (pulse) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: accent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: (accent ?? Colors.white).withValues(alpha: .8), blurRadius: 6)])),
            Text(val, style: AppTheme.numeric.copyWith(color: accent ?? Colors.white, fontSize: 22)),
            const SizedBox(width: 8),
            Text(label, style: AppTheme.overline.copyWith(color: Colors.white.withValues(alpha: 0.7), fontSize: 9, letterSpacing: 1)),
          ]),
        ),
      );
}
