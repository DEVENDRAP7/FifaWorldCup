import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/analytics_service.dart';

enum VoteSide { home, draw, away }

extension on VoteSide {
  String get field => name; // 'home' | 'draw' | 'away'
}

class MatchVotes {
  final int home, draw, away;
  const MatchVotes(this.home, this.draw, this.away);

  factory MatchVotes.fromDoc(Map<String, dynamic> d) => MatchVotes(
        (d['home'] as num?)?.toInt() ?? 0,
        (d['draw'] as num?)?.toInt() ?? 0,
        (d['away'] as num?)?.toInt() ?? 0,
      );

  int get total => home + draw + away;
  int raw(VoteSide s) => s == VoteSide.home ? home : (s == VoteSide.draw ? draw : away);
  double pct(VoteSide s) => total == 0 ? 0 : raw(s) / total * 100;

  MatchVotes operator +(MatchVotes o) => MatchVotes(home + o.home, draw + o.draw, away + o.away);
}

final _col = FirebaseFirestore.instance.collection('votes');

/// Real-time stream of every match's real vote counts from Firestore.
final votesStreamProvider = StreamProvider<Map<String, MatchVotes>>((ref) {
  return _col.snapshots().map((snap) {
    final m = <String, MatchVotes>{};
    for (final doc in snap.docs) {
      m[doc.id] = MatchVotes.fromDoc(doc.data());
    }
    return m;
  });
});

/// Live vote counts from Firestore (this device's own vote is already included).
/// Clamped at 0 so a stray decrement can never push a count negative.
MatchVotes displayVotes(String id, Map<String, MatchVotes> real) {
  final r = real[id] ?? const MatchVotes(0, 0, 0);
  return MatchVotes(
    r.home.clamp(0, 1 << 30),
    r.draw.clamp(0, 1 << 30),
    r.away.clamp(0, 1 << 30),
  );
}

/// This device's own picks, persisted locally (one vote per match).
class MyVotesNotifier extends Notifier<Map<String, VoteSide>> {
  static const _box = 'contest';
  static const _key = 'votes';

  Box get _b => Hive.box(_box);

  @override
  Map<String, VoteSide> build() {
    final raw = (_b.get(_key, defaultValue: <dynamic, dynamic>{}) as Map);
    final m = <String, VoteSide>{};
    raw.forEach((k, v) {
      m[k.toString()] = VoteSide.values.firstWhere(
        (e) => e.name == v.toString(),
        orElse: () => VoteSide.home,
      );
    });
    return m;
  }

  VoteSide? sideFor(String id) => state[id];

  Future<void> vote(String id, VoteSide side) async {
    final prev = state[id];
    if (prev == side) return clear(id); // tapping the same pick undoes it

    // Optimistic: update local state immediately so the UI responds instantly.
    final m = Map<String, VoteSide>.from(state)..[id] = side;
    state = m;
    await _persist();

    // Fire the Firestore write in the background (offline cache queues it).
    final update = <String, Object>{side.field: FieldValue.increment(1)};
    if (prev != null) update[prev.field] = FieldValue.increment(-1);
    _col.doc(id).set(update, SetOptions(merge: true)).catchError((_) {});
    Analytics.logVote(id, side.name);
  }

  Future<void> clear(String id) async {
    final prev = state[id];
    if (prev == null) return;
    final m = Map<String, VoteSide>.from(state)..remove(id);
    state = m;
    await _persist();
    _col.doc(id).set({prev.field: FieldValue.increment(-1)}, SetOptions(merge: true)).catchError((_) {});
  }

  Future<void> clearAll() async {
    final prev = Map<String, VoteSide>.from(state);
    state = {};
    await _b.delete(_key);
    for (final e in prev.entries) {
      _col.doc(e.key).set({e.value.field: FieldValue.increment(-1)}, SetOptions(merge: true)).catchError((_) {});
    }
  }

  Future<void> _persist() async =>
      _b.put(_key, state.map((k, v) => MapEntry(k, v.name)));
}

final myVotesProvider = NotifierProvider<MyVotesNotifier, Map<String, VoteSide>>(MyVotesNotifier.new);
