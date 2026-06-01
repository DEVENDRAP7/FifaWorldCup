import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AuthMode { unknown, guest, signedIn }

class UserState {
  final AuthMode mode;
  final String? name;
  final String? favoriteTeam;
  final String? favoriteCountryCode;
  final bool onboarded;

  UserState({required this.mode, this.name, this.favoriteTeam, this.favoriteCountryCode, required this.onboarded});

  UserState copyWith({AuthMode? mode, String? name, String? favoriteTeam, String? favoriteCountryCode, bool? onboarded}) =>
      UserState(
        mode: mode ?? this.mode,
        name: name ?? this.name,
        favoriteTeam: favoriteTeam ?? this.favoriteTeam,
        favoriteCountryCode: favoriteCountryCode ?? this.favoriteCountryCode,
        onboarded: onboarded ?? this.onboarded,
      );
}

class AuthNotifier extends Notifier<UserState> {
  static const _box = 'user';

  Box get _b => Hive.box(_box);

  @override
  UserState build() {
    final b = _b;
    final modeStr = b.get('mode', defaultValue: 'unknown') as String;
    return UserState(
      mode: AuthMode.values.firstWhere((e) => e.name == modeStr, orElse: () => AuthMode.unknown),
      name: b.get('name') as String?,
      favoriteTeam: b.get('favoriteTeam') as String?,
      favoriteCountryCode: b.get('favoriteCountryCode') as String?,
      onboarded: b.get('onboarded', defaultValue: false) as bool,
    );
  }

  Future<void> signInAsGuest() async {
    await _b.putAll({'mode': AuthMode.guest.name});
    state = state.copyWith(mode: AuthMode.guest);
  }

  Future<void> signIn(String name) async {
    await _b.putAll({'mode': AuthMode.signedIn.name, 'name': name});
    state = state.copyWith(mode: AuthMode.signedIn, name: name);
  }

  Future<void> signOut() async {
    await _b.clear();
    state = UserState(mode: AuthMode.unknown, onboarded: false);
  }

  Future<void> setFavoriteTeam(String name, String countryCode) async {
    await _b.putAll({'favoriteTeam': name, 'favoriteCountryCode': countryCode, 'onboarded': true});
    state = state.copyWith(favoriteTeam: name, favoriteCountryCode: countryCode, onboarded: true);
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserState>(AuthNotifier.new);
