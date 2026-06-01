import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LiveBadge extends StatefulWidget {
  final bool compact;
  const LiveBadge({super.key, this.compact = false});
  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.compact ? 6 : 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE11D48), Color(0xFFF43F5E)]),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        FadeTransition(
          opacity: Tween<double>(begin: .4, end: 1).animate(_c),
          child: const SizedBox(width: 6, height: 6, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
        ),
        const SizedBox(width: 5),
        Text('LIVE', style: AppTheme.overline.copyWith(color: Colors.white, fontSize: widget.compact ? 9 : 10)),
      ]),
    );
  }
}
