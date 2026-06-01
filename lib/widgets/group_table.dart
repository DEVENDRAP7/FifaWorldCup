import 'package:flutter/material.dart';
import '../models/match.dart';
import '../theme/app_theme.dart';
import 'flag.dart';

class GroupTable extends StatelessWidget {
  final GroupStanding group;
  const GroupTable({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: .55))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(group.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 13)),
        const SizedBox(height: 8),
        _header(),
        const Divider(height: 12, color: AppTheme.border),
        ...List.generate(group.teams.length, (i) => _row(group.teams[i], i < 2)),
      ]),
    );
  }

  Widget _header() => const Row(children: [
        Expanded(flex: 4, child: Text('Team', style: TextStyle(color: AppTheme.muted, fontSize: 10, fontWeight: FontWeight.w700))),
        _Cell('P'), _Cell('W'), _Cell('D'), _Cell('L'), _Cell('GD'), _Cell('Pts'),
      ]);

  Widget _row(TeamStanding t, bool advances) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(
            flex: 4,
            child: Row(children: [
              Container(
                width: 3, height: 14,
                decoration: BoxDecoration(
                  color: advances ? AppTheme.win : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              FlagImage(url: t.flag, width: 22, height: 15, radius: 3),
              const SizedBox(width: 6),
              Expanded(child: Text(t.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            ]),
          ),
          _Cell('${t.played}'), _Cell('${t.w}'), _Cell('${t.d}'), _Cell('${t.l}'),
          _Cell('${t.gd > 0 ? '+' : ''}${t.gd}'),
          _Cell('${t.pts}', bold: true, color: const Color(0xFFFFD700)),
        ]),
      );
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;
  const _Cell(this.text, {this.bold = false, this.color});
  @override
  Widget build(BuildContext context) => Expanded(
        flex: 1,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: color ?? AppTheme.text)),
      );
}
