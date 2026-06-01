import 'package:firebase_analytics/firebase_analytics.dart';

/// Thin wrapper over Firebase Analytics. Events are best-effort — failures
/// never block app logic.
class Analytics {
  static final FirebaseAnalytics instance = FirebaseAnalytics.instance;

  /// Attach to MaterialApp.navigatorObservers for automatic screen_view events.
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: instance);

  static Future<void> _safe(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (_) {}
  }

  static Future<void> logLogin(String method) => _safe(() => instance.logLogin(loginMethod: method));
  static Future<void> logSignUp(String method) => _safe(() => instance.logSignUp(signUpMethod: method));

  static Future<void> logVote(String matchId, String side) => _safe(() => instance.logEvent(
        name: 'cast_vote',
        parameters: {'match_id': matchId, 'side': side},
      ));

  static Future<void> logSelectFavoriteTeam(String team) => _safe(() => instance.logEvent(
        name: 'select_favorite_team',
        parameters: {'team': team},
      ));

  static Future<void> logDeleteAccount() => _safe(() => instance.logEvent(name: 'delete_account'));
}
