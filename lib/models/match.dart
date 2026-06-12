String _desc(dynamic arr) {
  if (arr is List && arr.isNotEmpty) {
    final first = arr[0];
    if (first is Map) return (first['Description'] ?? '').toString();
  }
  return '';
}

class WcMatch {
  final String id;
  final String idCompetition;
  final String idSeason;
  final String idStage;
  final DateTime date;
  final String stage;
  final String groupName;
  final String homeName;
  final String awayName;
  final String homeCountryCode;
  final String awayCountryCode;
  final int? homeScore;
  final int? awayScore;
  final int? homePenScore;
  final int? awayPenScore;
  final String venue;
  final String city;
  final String? lastUpdate;

  WcMatch({
    required this.id, required this.date, required this.stage, required this.groupName,
    required this.homeName, required this.awayName,
    required this.homeCountryCode, required this.awayCountryCode,
    this.homeScore, this.awayScore, this.homePenScore, this.awayPenScore,
    required this.venue, required this.city, this.lastUpdate,
    this.idCompetition = '', this.idSeason = '', this.idStage = '',
  });

  bool get isFinished =>
      homeScore != null && awayScore != null &&
      DateTime.now().isAfter(date.add(const Duration(hours: 2)));
  bool get isLive {
    if (homeScore == null || awayScore == null) return false;
    final now = DateTime.now();
    return now.isAfter(date) && now.isBefore(date.add(const Duration(hours: 2)));
  }
  bool get isUpcoming => !isLive && !isFinished;
  bool get isKnockout => groupName.isEmpty || stage.toLowerCase().contains('round') || stage.toLowerCase().contains('final') || stage.toLowerCase().contains('quarter') || stage.toLowerCase().contains('semi');

  String flagUrl(String code) => code.isEmpty
      ? ''
      : 'https://api.fifa.com/api/v3/picture/flags-sq-4/$code';
  String get homeFlag => flagUrl(homeCountryCode);
  String get awayFlag => flagUrl(awayCountryCode);

  factory WcMatch.fromJson(Map<String, dynamic> j) {
    int? n(dynamic v) => v == null ? null : (v is int ? v : int.tryParse(v.toString()));
    Map<String, dynamic> mp(dynamic x) => x is Map ? Map<String, dynamic>.from(x) : <String, dynamic>{};
    final home = mp(j['Home']);
    final away = mp(j['Away']);
    final stadium = mp(j['Stadium']);
    return WcMatch(
      id: (j['IdMatch'] ?? '').toString(),
      idCompetition: (j['IdCompetition'] ?? '').toString(),
      idSeason: (j['IdSeason'] ?? '').toString(),
      idStage: (j['IdStage'] ?? '').toString(),
      date: DateTime.tryParse((j['Date'] ?? '').toString())?.toLocal() ?? DateTime.now(),
      stage: _desc(j['StageName']),
      groupName: _desc(j['GroupName']),
      homeName: _desc(home['TeamName']),
      awayName: _desc(away['TeamName']),
      homeCountryCode: (home['IdCountry'] ?? '').toString(),
      awayCountryCode: (away['IdCountry'] ?? '').toString(),
      homeScore: n(j['HomeTeamScore']),
      awayScore: n(j['AwayTeamScore']),
      homePenScore: n(j['HomeTeamPenaltyScore']),
      awayPenScore: n(j['AwayTeamPenaltyScore']),
      venue: _desc(stadium['Name']),
      city: _desc(stadium['CityName']),
      lastUpdate: j['LastPeriodUpdate']?.toString(),
    );
  }
}

class TeamStanding {
  final String name;
  final String countryCode;
  final int played, w, d, l, gf, ga, gd, pts;
  TeamStanding({required this.name, required this.countryCode, required this.played, required this.w, required this.d, required this.l, required this.gf, required this.ga, required this.gd, required this.pts});
  String get flag => countryCode.isEmpty ? '' : 'https://api.fifa.com/api/v3/picture/flags-sq-4/$countryCode';
}

class GroupStanding {
  final String name;
  final List<TeamStanding> teams;
  GroupStanding({required this.name, required this.teams});
}

// ── Match detail (lineups, stats, key events) ────────────────────
String _name(dynamic arr) {
  if (arr is List && arr.isNotEmpty && arr[0] is Map) {
    return (arr[0]['Description'] ?? '').toString();
  }
  return '';
}

int _min(dynamic v) {
  if (v is int) return v;
  return int.tryParse('${v ?? ''}'.replaceAll("'", '').trim()) ?? 0;
}

class LineupPlayer {
  final String id;
  final String name;
  final int shirt;
  final int position; // 0=GK 1=DEF 2=MID 3=FWD (4=unset/bench)
  final bool captain;
  final bool starter; // Status==1
  final double x; // pitch col 1..20 (10 = center)
  final double y; // pitch depth 1(GK) .. higher = forward
  LineupPlayer({required this.id, required this.name, required this.shirt, required this.position, required this.captain, required this.starter, this.x = 0, this.y = 0});

  static double _d(dynamic v) => v is num ? v.toDouble() : double.tryParse('${v ?? ''}') ?? 0;

  factory LineupPlayer.fromJson(Map<String, dynamic> j) => LineupPlayer(
        id: (j['IdPlayer'] ?? '').toString(),
        name: _name(j['PlayerName']),
        shirt: (j['ShirtNumber'] is int) ? j['ShirtNumber'] : int.tryParse('${j['ShirtNumber']}') ?? 0,
        position: (j['Position'] is int) ? j['Position'] : int.tryParse('${j['Position']}') ?? 4,
        captain: j['Captain'] == true,
        starter: j['Status'] == 1,
        x: _d(j['LineupX']),
        y: _d(j['LineupY']),
      );

  /// Last name only, for compact pitch labels.
  String get shortName {
    final parts = name.trim().split(' ');
    return parts.isEmpty ? '' : parts.last;
  }
}

class StatRow {
  final String label;
  final num home;
  final num away;
  final bool percent;
  const StatRow(this.label, this.home, this.away, {this.percent = false});
}

class TeamLineup {
  final String tactics; // "4-4-2"
  final String coach;
  final List<LineupPlayer> players;
  TeamLineup({required this.tactics, required this.coach, required this.players});
  List<LineupPlayer> get starters => players.where((p) => p.starter).toList()..sort((a, b) => a.position.compareTo(b.position));
  List<LineupPlayer> get subs => players.where((p) => !p.starter).toList()..sort((a, b) => a.shirt.compareTo(b.shirt));
}

enum EventKind { goal, ownGoal, penaltyGoal, yellow, red, sub }

class MatchEvent {
  final int minute;
  final EventKind kind;
  final bool home;
  final String player;
  final String detail; // assist / player off
  MatchEvent({required this.minute, required this.kind, required this.home, required this.player, this.detail = ''});
}

class MatchDetail {
  final double possHome;
  final double possAway;
  final String referee;
  final int? attendance;
  final String homeTeamId;
  final String awayTeamId;
  final TeamLineup home;
  final TeamLineup away;
  final List<MatchEvent> events;
  final List<StatRow> stats; // filled from the timeline after fetch
  MatchDetail({required this.possHome, required this.possAway, required this.referee, required this.attendance, required this.homeTeamId, required this.awayTeamId, required this.home, required this.away, required this.events, List<StatRow>? stats}) : stats = stats ?? [];

  bool get hasLineups => home.starters.isNotEmpty || away.starters.isNotEmpty;
  bool get hasPossession => possHome > 0 || possAway > 0;
  bool get hasEvents => events.isNotEmpty;
  bool get hasStats => stats.isNotEmpty;

  /// Aggregate per-team counts from the FIFA timeline event feed.
  /// Event Type ids: 0/41 goal · 2 yellow · 12 shot · 15 offside · 16 corner · 18 foul · 5 sub.
  void computeStatsFromTimeline(List<dynamic> timeline) {
    int sh = 0, sa = 0; // shots
    int ch = 0, ca = 0; // corners
    int oh = 0, oa = 0; // offsides
    int fh = 0, fa = 0; // fouls
    int yh = 0, ya = 0; // yellow cards
    for (final e in timeline) {
      if (e is! Map) continue;
      final t = e['Type'];
      final team = (e['IdTeam'] ?? '').toString();
      final isH = team == homeTeamId;
      final isA = team == awayTeamId;
      if (!isH && !isA) continue;
      switch (t) {
        case 12: isH ? sh++ : sa++; break;
        case 16: isH ? ch++ : ca++; break;
        case 15: isH ? oh++ : oa++; break;
        case 18: isH ? fh++ : fa++; break;
        case 2: isH ? yh++ : ya++; break;
      }
    }
    stats.clear();
    // Possession only when the feed actually supplies it. The 2026 live feed
    // returns BallPossession=null (→ 0/0), which must NOT render a 0%–0% bar.
    if (possHome > 0 || possAway > 0) {
      stats.add(StatRow('Possession', possHome.round(), possAway.round(), percent: true));
    }
    stats
      ..add(StatRow('Shots', sh, sa))
      ..add(StatRow('Corners', ch, ca))
      ..add(StatRow('Fouls', fh, fa))
      ..add(StatRow('Offsides', oh, oa))
      ..add(StatRow('Yellow cards', yh, ya));
    // Drop all-zero counted rows (the percent possession row is never dropped here).
    stats.removeWhere((s) => !s.percent && s.home == 0 && s.away == 0);
  }

  factory MatchDetail.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic> mp(dynamic x) => x is Map ? Map<String, dynamic>.from(x) : <String, dynamic>{};
    List<dynamic> ls(dynamic x) => x is List ? x : const [];

    TeamLineup team(Map<String, dynamic> t) {
      final coaches = ls(t['Coaches']);
      return TeamLineup(
        tactics: (t['Tactics'] ?? '').toString(),
        coach: coaches.isNotEmpty ? _name(mp(coaches[0])['Name']) : '',
        players: ls(t['Players']).map((p) => LineupPlayer.fromJson(mp(p))).toList(),
      );
    }

    final home = mp(j['HomeTeam']);
    final away = mp(j['AwayTeam']);
    final poss = mp(j['BallPossession']);

    final events = <MatchEvent>[];
    void addSide(Map<String, dynamic> t, bool isHome) {
      final names = {for (final p in ls(t['Players'])) (mp(p)['IdPlayer'] ?? '').toString(): _name(mp(p)['PlayerName'])};
      String nm(String? id) => names[id ?? ''] ?? '';
      for (final g in ls(t['Goals'])) {
        final gm = mp(g);
        final type = gm['Type'];
        final kind = type == 3 ? EventKind.ownGoal : (type == 2 ? EventKind.penaltyGoal : EventKind.goal);
        events.add(MatchEvent(minute: _min(gm['Minute']), kind: kind, home: isHome, player: nm((gm['IdPlayer'] ?? '').toString()), detail: nm((gm['IdAssistPlayer'] ?? '').toString())));
      }
      for (final b in ls(t['Bookings'])) {
        final bm = mp(b);
        final card = bm['Card'];
        events.add(MatchEvent(minute: _min(bm['Minute']), kind: (card == 2 || card == 3) ? EventKind.red : EventKind.yellow, home: isHome, player: nm((bm['IdPlayer'] ?? '').toString())));
      }
      for (final s in ls(t['Substitutions'])) {
        final sm = mp(s);
        events.add(MatchEvent(minute: _min(sm['Minute']), kind: EventKind.sub, home: isHome, player: _name(sm['PlayerOnName']), detail: _name(sm['PlayerOffName'])));
      }
    }
    addSide(home, true);
    addSide(away, false);
    events.sort((a, b) => a.minute.compareTo(b.minute));

    final att = j['Attendance'];
    return MatchDetail(
      possHome: (poss['OverallHome'] as num?)?.toDouble() ?? 0,
      possAway: (poss['OverallAway'] as num?)?.toDouble() ?? 0,
      referee: _refOf(j),
      attendance: att is int ? att : int.tryParse('${att ?? ''}'),
      homeTeamId: (home['IdTeam'] ?? '').toString(),
      awayTeamId: (away['IdTeam'] ?? '').toString(),
      home: team(home),
      away: team(away),
      events: events,
    );
  }

  static String _refOf(Map<String, dynamic> j) {
    final offs = j['Officials'];
    if (offs is List) {
      for (final o in offs) {
        if (o is Map && (o['OfficialType'] == 1 || o['Role'] == 1)) {
          return _name(o['Name'] ?? o['NameShort']);
        }
      }
      if (offs.isNotEmpty && offs[0] is Map) return _name((offs[0] as Map)['Name']);
    }
    return '';
  }
}
