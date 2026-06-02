import 'package:dio/dio.dart';
import '../models/match.dart';
import 'config_service.dart';

/// DEBUG: load the REAL 2022 World Cup (finished matches with full lineups +
/// stats + events) so match-detail can be tested against real data now.
/// SET BACK TO false before release (uses the live 2026 feed).
const bool kTestSeason2022 = false;
const String _wc2022Url =
    'https://api.fifa.com/api/v3/calendar/matches?idCompetition=17&idSeason=255711&language=en&count=200';

class ApiService {
  final RemoteConfig config;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  ApiService(this.config);

  Future<List<WcMatch>> fetchMatches() async {
    final r = await _dio.get(kTestSeason2022 ? _wc2022Url : config.scoreboardUrl);
    final list = ((r.data['Results'] as List?) ?? const [])
        .map((e) => WcMatch.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  /// Full match detail (lineups, possession, key events) from the FIFA live
  /// endpoint. Returns null if ids are missing or the request fails.
  Future<MatchDetail?> fetchMatchDetail(WcMatch m) async {
    if (m.idCompetition.isEmpty || m.idSeason.isEmpty || m.idStage.isEmpty) {
      return null;
    }
    try {
      final base = 'https://api.fifa.com/api/v3';
      final ids = '${m.idCompetition}/${m.idSeason}/${m.idStage}/${m.id}';
      final r = await _dio.get('$base/live/football/$ids?language=en');
      if (r.data is! Map) return null;
      final detail = MatchDetail.fromJson(Map<String, dynamic>.from(r.data));
      // Timeline → real per-team stats (shots, corners, fouls, offsides, cards).
      try {
        final t = await _dio.get('$base/timelines/$ids?language=en');
        final ev = (t.data is Map ? t.data['Event'] : null);
        if (ev is List) detail.computeStatsFromTimeline(ev);
      } catch (_) {}
      return detail;
    } catch (_) {}
    return null;
  }

  // FIFA standings endpoint requires per-group call. Workaround: derive standings
  // client-side from finished matches in each group.
  Future<List<GroupStanding>> fetchGroups() async {
    final matches = await fetchMatches();
    return _computeStandings(matches);
  }

  List<GroupStanding> _computeStandings(List<WcMatch> matches) {
    final groups = <String, Map<String, _TeamAgg>>{};
    for (final m in matches) {
      if (m.groupName.isEmpty) continue;
      final g = groups.putIfAbsent(m.groupName, () => {});
      g.putIfAbsent(m.homeName, () => _TeamAgg(m.homeName, m.homeCountryCode));
      g.putIfAbsent(m.awayName, () => _TeamAgg(m.awayName, m.awayCountryCode));
      if (m.homeScore == null || m.awayScore == null) continue;
      final h = g[m.homeName]!, a = g[m.awayName]!;
      h.played++; a.played++;
      h.gf += m.homeScore!; h.ga += m.awayScore!;
      a.gf += m.awayScore!; a.ga += m.homeScore!;
      if (m.homeScore! > m.awayScore!) { h.w++; a.l++; h.pts += 3; }
      else if (m.homeScore! < m.awayScore!) { a.w++; h.l++; a.pts += 3; }
      else { h.d++; a.d++; h.pts++; a.pts++; }
    }
    final result = groups.entries
        .where((e) => e.key.toLowerCase().startsWith('group '))
        .map((e) {
      final teams = e.value.values.map((t) => TeamStanding(
        name: t.name.isEmpty ? 'TBD' : t.name,
        countryCode: t.code,
        played: t.played, w: t.w, d: t.d, l: t.l,
        gf: t.gf, ga: t.ga, gd: t.gf - t.ga, pts: t.pts,
      )).toList();
      teams.sort((a, b) {
        final p = b.pts.compareTo(a.pts);
        if (p != 0) return p;
        final gd = b.gd.compareTo(a.gd);
        if (gd != 0) return gd;
        return b.gf.compareTo(a.gf);
      });
      return GroupStanding(name: e.key, teams: teams);
    }).toList();
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }
}

class _TeamAgg {
  final String name;
  final String code;
  int played = 0, w = 0, d = 0, l = 0, gf = 0, ga = 0, pts = 0;
  _TeamAgg(this.name, this.code);
}
