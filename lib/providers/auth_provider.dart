import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import 'vote_provider.dart';

enum AuthMode { unknown, guest, signedIn }

class UserState {
  final AuthMode mode;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? uid;
  final String? favoriteTeam;
  final String? favoriteCountryCode;
  final bool onboarded;

  UserState({required this.mode, this.name, this.email, this.photoUrl, this.uid, this.favoriteTeam, this.favoriteCountryCode, required this.onboarded});

  UserState copyWith({AuthMode? mode, String? name, String? email, String? photoUrl, String? uid, String? favoriteTeam, String? favoriteCountryCode, bool? onboarded}) =>
      UserState(
        mode: mode ?? this.mode,
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        uid: uid ?? this.uid,
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
      email: b.get('email') as String?,
      photoUrl: b.get('photoUrl') as String?,
      uid: b.get('uid') as String?,
      favoriteTeam: b.get('favoriteTeam') as String?,
      favoriteCountryCode: b.get('favoriteCountryCode') as String?,
      onboarded: b.get('onboarded', defaultValue: false) as bool,
    );
  }

  Future<void> signInAsGuest() async {
    await _b.putAll({'mode': AuthMode.guest.name});
    state = state.copyWith(mode: AuthMode.guest);
  }

  Future<void> _applyUser(User u) async {
    await _b.putAll({
      'mode': AuthMode.signedIn.name,
      'name': u.displayName ?? '',
      'email': u.email ?? '',
      'photoUrl': u.photoURL ?? '',
      'uid': u.uid,
    });
    state = state.copyWith(
      mode: AuthMode.signedIn,
      name: u.displayName ?? '',
      email: u.email ?? '',
      photoUrl: u.photoURL ?? '',
      uid: u.uid,
    );
  }

  /// Each returns an error string to show, or null on success (cancel = null).
  Future<String?> signInWithGoogle() async {
    final r = await AuthService.signInWithGoogle();
    if (r.user == null) return r.error; // null = cancelled, string = real error
    await _applyUser(r.user!);
    Analytics.logLogin('google');
    return null;
  }

  Future<AuthOutcome> signInWithEmail(String email, String password) async {
    final r = await AuthService.signInWithEmail(email, password);
    if (r.user != null) {
      await _applyUser(r.user!);
      Analytics.logLogin('password');
    }
    return r;
  }

  Future<AuthOutcome> signUpWithEmail(String name, String email, String password) async {
    final r = await AuthService.signUpWithEmail(name, email, password);
    if (r.user != null) {
      await _applyUser(r.user!);
      Analytics.logSignUp('password');
    }
    return r;
  }

  Future<String?> resendVerification(String email, String password) =>
      AuthService.resendVerification(email, password);

  Future<String?> sendPasswordReset(String email) => AuthService.sendPasswordReset(email);

  Future<void> signOut() async {
    await AuthService.signOut();
    await _b.clear();
    state = UserState(mode: AuthMode.unknown, onboarded: false);
  }

  /// Returns null on success, or an error message to show.
  Future<String?> deleteAccount({String? password}) async {
    final err = await AuthService.deleteAccount(password: password);
    if (err != null) return err;
    try {
      await ref.read(myVotesProvider.notifier).clearAll(); // remove their votes from Firestore
    } catch (_) {}
    Analytics.logDeleteAccount();
    await _b.clear();
    state = UserState(mode: AuthMode.unknown, onboarded: false);
    return null;
  }

  Future<void> setFavoriteTeam(String name, String countryCode) async {
    Analytics.logSelectFavoriteTeam(name);
    await _b.putAll({'favoriteTeam': name, 'favoriteCountryCode': countryCode, 'onboarded': true});
    state = state.copyWith(favoriteTeam: name, favoriteCountryCode: countryCode, onboarded: true);
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserState>(AuthNotifier.new);
