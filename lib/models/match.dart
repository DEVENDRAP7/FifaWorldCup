String _desc(dynamic arr) {
  if (arr is List && arr.isNotEmpty) {
    final first = arr[0];
    if (first is Map) return (first['Description'] ?? '').toString();
  }
  return '';
}

class WcMatch {
  final String id;
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
  });

  bool get isFinished => homeScore != null && awayScore != null && lastUpdate == null
      ? false
      : (homeScore != null && awayScore != null && DateTime.now().isAfter(date.add(const Duration(hours: 2))));
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
