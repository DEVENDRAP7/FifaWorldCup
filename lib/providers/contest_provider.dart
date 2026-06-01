import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum PickSide { home, draw, away }
enum PickStatus { pending, won, lost }

class Pick {
  final String matchId;
  final String homeTeam;
  final String awayTeam;
  final PickSide side;
  final int stake;
  final PickStatus status;
  final int? payout;
  final DateTime createdAt;

  Pick({required this.matchId, required this.homeTeam, required this.awayTeam, required this.side, required this.stake, required this.status, this.payout, required this.createdAt});

  Map<String, dynamic> toMap() => {
        'matchId': matchId, 'homeTeam': homeTeam, 'awayTeam': awayTeam,
        'side': side.name, 'stake': stake, 'status': status.name,
        'payout': payout, 'createdAt': createdAt.toIso8601String(),
      };

  factory Pick.fromMap(Map m) => Pick(
        matchId: m['matchId'].toString(),
        homeTeam: m['homeTeam'].toString(),
        awayTeam: m['awayTeam'].toString(),
        side: PickSide.values.firstWhere((e) => e.name == m['side']),
        stake: m['stake'] as int,
        status: PickStatus.values.firstWhere((e) => e.name == m['status'], orElse: () => PickStatus.pending),
        payout: m['payout'] as int?,
        createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

class ContestState {
  final int caps;
  final List<Pick> picks;
  ContestState({required this.caps, required this.picks});
}

class ContestNotifier extends Notifier<ContestState> {
  static const _box = 'contest';
  static const _startCaps = 1000;
  static const _capsKey = 'caps';
  static const _picksKey = 'picks';

  Box get _b => Hive.box(_box);

  @override
  ContestState build() {
    final caps = _b.get(_capsKey, defaultValue: _startCaps) as int;
    final raw = (_b.get(_picksKey, defaultValue: <dynamic>[]) as List).cast<dynamic>();
    final picks = raw.map((e) => Pick.fromMap(Map.from(e as Map))).toList();
    return ContestState(caps: caps, picks: picks);
  }

  Future<void> _save() async {
    await _b.putAll({
      _capsKey: state.caps,
      _picksKey: state.picks.map((p) => p.toMap()).toList(),
    });
  }

  bool hasPick(String matchId) => state.picks.any((p) => p.matchId == matchId);
  Pick? pickFor(String matchId) {
    for (final p in state.picks) {
      if (p.matchId == matchId) return p;
    }
    return null;
  }

  Future<bool> placePick({required String matchId, required String homeTeam, required String awayTeam, required PickSide side, required int stake}) async {
    if (stake <= 0 || stake > state.caps) return false;
    if (hasPick(matchId)) return false;
    final newPicks = [...state.picks, Pick(matchId: matchId, homeTeam: homeTeam, awayTeam: awayTeam, side: side, stake: stake, status: PickStatus.pending, createdAt: DateTime.now())];
    state = ContestState(caps: state.caps - stake, picks: newPicks);
    await _save();
    return true;
  }

  // Resolve pending picks against finished matches.
  // matches: Map<matchId, (homeScore, awayScore, isFinished)>.
  Future<void> resolve(Map<String, (int?, int?, bool)> results) async {
    var changed = false;
    var capsDelta = 0;
    final updated = state.picks.map((p) {
      if (p.status != PickStatus.pending) return p;
      final r = results[p.matchId];
      if (r == null) return p;
      final (hs, as_, isFinished) = r;
      if (!isFinished || hs == null || as_ == null) return p;
      final actual = hs > as_ ? PickSide.home : (hs < as_ ? PickSide.away : PickSide.draw);
      final won = actual == p.side;
      final payout = won ? p.stake * 2 : 0;
      capsDelta += payout;
      changed = true;
      return Pick(
        matchId: p.matchId, homeTeam: p.homeTeam, awayTeam: p.awayTeam,
        side: p.side, stake: p.stake,
        status: won ? PickStatus.won : PickStatus.lost,
        payout: payout, createdAt: p.createdAt,
      );
    }).toList();
    if (changed) {
      state = ContestState(caps: state.caps + capsDelta, picks: updated);
      await _save();
    }
  }

  Future<void> reset() async {
    state = ContestState(caps: _startCaps, picks: const []);
    await _save();
  }

  Future<void> addCaps(int amount) async {
    state = ContestState(caps: state.caps + amount, picks: state.picks);
    await _save();
  }
}

final contestProvider = NotifierProvider<ContestNotifier, ContestState>(ContestNotifier.new);
