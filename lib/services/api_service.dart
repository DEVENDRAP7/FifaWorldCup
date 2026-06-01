import 'package:dio/dio.dart';
import '../models/match.dart';
import 'config_service.dart';

class ApiService {
  final RemoteConfig config;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  ApiService(this.config);

  Future<List<WcMatch>> fetchMatches() async {
    final r = await _dio.get(config.scoreboardUrl);
    final list = ((r.data['Results'] as List?) ?? const [])
        .map((e) => WcMatch.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
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
