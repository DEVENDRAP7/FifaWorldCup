import 'package:dio/dio.dart';

class RemoteConfig {
  final String scoreboardUrl;
  final String standingsUrl;
  final int refreshSeconds;
  final int groupsRefreshSeconds;
  final String? message;

  RemoteConfig({
    required this.scoreboardUrl,
    required this.standingsUrl,
    required this.refreshSeconds,
    required this.groupsRefreshSeconds,
    this.message,
  });

  static RemoteConfig fallback() => RemoteConfig(
        scoreboardUrl:
            'https://api.fifa.com/api/v3/calendar/matches?idCompetition=17&language=en&count=200&from=2026-06-01',
        standingsUrl: '',
        refreshSeconds: 30,
        groupsRefreshSeconds: 120,
      );

  factory RemoteConfig.fromJson(Map<String, dynamic> j) => RemoteConfig(
        scoreboardUrl: (j['scoreboardUrl'] ?? fallback().scoreboardUrl).toString(),
        standingsUrl: (j['standingsUrl'] ?? '').toString(),
        refreshSeconds: (j['refreshIntervalSeconds'] as num?)?.toInt() ?? 30,
        groupsRefreshSeconds: (j['groupsRefreshIntervalSeconds'] as num?)?.toInt() ?? 120,
        message: j['message']?.toString(),
      );
}

class ConfigService {
  static const String configUrl =
      'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/config.json';

  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 6), receiveTimeout: const Duration(seconds: 6)));

  Future<RemoteConfig> load() async {
    try {
      final r = await _dio.get(configUrl);
      if (r.data is Map) return RemoteConfig.fromJson(Map<String, dynamic>.from(r.data));
    } catch (_) {}
    return RemoteConfig.fallback();
  }
}
