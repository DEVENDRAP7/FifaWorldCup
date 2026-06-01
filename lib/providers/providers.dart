import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/match.dart';
import '../services/api_service.dart';
import '../services/config_service.dart';

final configServiceProvider = Provider<ConfigService>((ref) => ConfigService());

final configProvider = FutureProvider<RemoteConfig>((ref) async {
  return ref.read(configServiceProvider).load();
});

final apiProvider = Provider<ApiService>((ref) {
  final cfg = ref.watch(configProvider).value ?? RemoteConfig.fallback();
  return ApiService(cfg);
});

class MatchesNotifier extends AsyncNotifier<List<WcMatch>> {
  Timer? _timer;

  @override
  Future<List<WcMatch>> build() async {
    final cfg = await ref.watch(configProvider.future);
    final api = ref.read(apiProvider);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: cfg.refreshSeconds), (_) => refresh());
    ref.onDispose(() => _timer?.cancel());
    return api.fetchMatches();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => ref.read(apiProvider).fetchMatches());
  }
}

final matchesProvider =
    AsyncNotifierProvider<MatchesNotifier, List<WcMatch>>(MatchesNotifier.new);

class GroupsNotifier extends AsyncNotifier<List<GroupStanding>> {
  Timer? _timer;

  @override
  Future<List<GroupStanding>> build() async {
    final cfg = await ref.watch(configProvider.future);
    final api = ref.read(apiProvider);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: cfg.groupsRefreshSeconds), (_) => refresh());
    ref.onDispose(() => _timer?.cancel());
    return api.fetchGroups();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => ref.read(apiProvider).fetchGroups());
  }
}

final groupsProvider =
    AsyncNotifierProvider<GroupsNotifier, List<GroupStanding>>(GroupsNotifier.new);
