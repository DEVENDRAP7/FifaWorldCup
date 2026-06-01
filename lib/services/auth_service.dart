import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Outcome of an auth attempt.
/// - `user != null`            → signed in, ready to use the app
/// - `needsVerification`       → account exists but email not verified (gated)
/// - `error != null`           → real failure, show the message
/// - all null / false          → user cancelled (no message)
class AuthOutcome {
  final User? user;
  final String? error;
  final bool needsVerification;
  final String? email;
  const AuthOutcome({this.user, this.error, this.needsVerification = false, this.email});
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _googleReady = false;

  // Web (server) OAuth client id from Firebase — required so the returned
  // idToken has an audience Firebase Auth will accept. Pulled from
  // google-services.json (client_type 3 / web).
  static const String _serverClientId =
      '674980117376-h5ipck7dgki842vb6a1e996ldja86adi.apps.googleusercontent.com';

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  // ── Email & password ─────────────────────────────────────────
  static Future<AuthOutcome> signInWithEmail(String email, String password) async {
    try {
      final uc = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      final u = uc.user;
      if (u == null) return const AuthOutcome(error: 'Sign-in failed.');
      await u.reload();
      final fresh = _auth.currentUser;
      if (fresh != null && !fresh.emailVerified) {
        // Gate: unverified accounts cannot enter. Re-send link, sign back out.
        try {
          await fresh.sendEmailVerification();
        } catch (_) {}
        await _auth.signOut();
        return AuthOutcome(needsVerification: true, email: email.trim());
      }
      return AuthOutcome(user: fresh);
    } on FirebaseAuthException catch (e) {
      return AuthOutcome(error: _message(e));
    } catch (_) {
      return const AuthOutcome(error: 'Sign-in failed. Please try again.');
    }
  }

  static Future<AuthOutcome> signUpWithEmail(String name, String email, String password) async {
    try {
      final uc = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      final u = uc.user;
      if (u == null) return const AuthOutcome(error: 'Sign up failed.');
      if (name.trim().isNotEmpty) {
        await u.updateDisplayName(name.trim());
        await u.reload();
      }
      try {
        await u.sendEmailVerification();
      } catch (_) {}
      // Gate: user must verify before they can use the app.
      await _auth.signOut();
      return AuthOutcome(needsVerification: true, email: email.trim());
    } on FirebaseAuthException catch (e) {
      return AuthOutcome(error: _message(e));
    } catch (_) {
      return const AuthOutcome(error: 'Sign up failed. Please try again.');
    }
  }

  /// Re-send the verification email by briefly re-authenticating.
  static Future<String?> resendVerification(String email, String password) async {
    try {
      final uc = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      await uc.user?.sendEmailVerification();
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return _message(e);
    } catch (_) {
      return 'Could not resend verification email.';
    }
  }

  static Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _message(e);
    } catch (_) {
      return 'Could not send reset email.';
    }
  }

  // ── Google (Android → Google only; iOS would add Apple via Platform.isIOS) ──
  static Future<void> _ensureGoogleInit() async {
    if (_googleReady) return;
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _googleReady = true;
  }

  static Future<AuthOutcome> signInWithGoogle() async {
    try {
      await _ensureGoogleInit();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final uc = await _auth.signInWithCredential(credential);
      if (uc.user == null) return const AuthOutcome(error: 'Google sign-in returned no user.');
      return AuthOutcome(user: uc.user); // Google accounts are already verified
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return const AuthOutcome();
      return const AuthOutcome(error: 'Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      return AuthOutcome(error: e.message ?? 'Sign-in failed.');
    } catch (_) {
      return const AuthOutcome(error: 'Google sign-in failed. Please try again.');
    }
  }

  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  // ── Account deletion (Play/App Store requirement) ────────────
  static List<String> get providerIds =>
      _auth.currentUser?.providerData.map((p) => p.providerId).toList() ?? const [];

  static bool get isPasswordUser => providerIds.contains('password');

  /// Deletes the Firebase user after re-authenticating (required by Firebase).
  /// Email users must pass [password]; Google users re-auth natively.
  /// Returns null on success, or a human-readable error.
  static Future<String?> deleteAccount({String? password}) async {
    final user = _auth.currentUser;
    if (user == null) return null; // guest / nothing to delete
    try {
      final ids = providerIds;
      if (ids.contains('password')) {
        final email = user.email;
        if (email == null || email.isEmpty) return 'No email on this account.';
        if (password == null || password.isEmpty) return 'Password required.';
        final cred = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(cred);
      } else if (ids.contains('google.com')) {
        await _ensureGoogleInit();
        final g = await GoogleSignIn.instance.authenticate();
        final cred = GoogleAuthProvider.credential(idToken: g.authentication.idToken);
        await user.reauthenticateWithCredential(cred);
      }
      await user.delete();
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return 'Cancelled.';
      return 'Re-authentication failed. Please try again.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Please sign out and sign in again, then retry.';
      }
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Incorrect password.';
      }
      return _message(e);
    } catch (_) {
      return 'Account deletion failed. Please try again.';
    }
  }

  static String _message(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password too weak (min 6 characters).';
      case 'operation-not-allowed':
        return 'Email sign-in is not enabled.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
