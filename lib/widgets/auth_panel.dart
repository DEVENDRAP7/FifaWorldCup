import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../app_links.dart';

// ── Validators (mirrors our other apps' auth forms) ──────────────
String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  final pattern = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
  if (!pattern.hasMatch(v.trim())) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 6) return 'At least 6 characters';
  return null;
}

String? validateName(String? v) {
  if (v == null || v.trim().isEmpty) return 'Name is required';
  if (v.trim().length < 2) return 'Name is too short';
  return null;
}

class AuthPanel extends ConsumerStatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onGuest;
  const AuthPanel({super.key, required this.onAuthenticated, required this.onGuest});

  @override
  ConsumerState<AuthPanel> createState() => _AuthPanelState();
}

class _AuthPanelState extends ConsumerState<AuthPanel> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _isSignUp = false;
  bool _obscure = true;
  bool _emailLoading = false;
  bool _googleLoading = false;
  bool _resending = false;
  String? _error;

  // Verification gate
  bool _needsVerify = false;
  String? _pendingEmail;

  bool get _busy => _emailLoading || _googleLoading;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toggleMode() => setState(() {
        _isSignUp = !_isSignUp;
        _error = null;
        _formKey.currentState?.reset();
      });

  Future<void> _submitEmail() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _emailLoading = true;
      _error = null;
    });
    final notifier = ref.read(authProvider.notifier);
    final r = _isSignUp
        ? await notifier.signUpWithEmail(_name.text, _email.text, _password.text)
        : await notifier.signInWithEmail(_email.text, _password.text);
    if (!mounted) return;
    setState(() => _emailLoading = false);
    if (r.user != null) {
      widget.onAuthenticated();
    } else if (r.needsVerification) {
      setState(() {
        _needsVerify = true;
        _pendingEmail = r.email ?? _email.text.trim();
      });
    } else if (r.error != null) {
      setState(() => _error = r.error);
    }
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    final err = await ref.read(authProvider.notifier).resendVerification(_pendingEmail ?? _email.text, _password.text);
    if (!mounted) return;
    setState(() => _resending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? 'Verification email re-sent to $_pendingEmail.')),
    );
  }

  // After the user taps the link in their inbox, this re-checks and enters.
  Future<void> _verifyAndContinue() async {
    if (_emailLoading) return;
    setState(() {
      _emailLoading = true;
      _error = null;
    });
    final r = await ref.read(authProvider.notifier).signInWithEmail(_pendingEmail ?? _email.text, _password.text);
    if (!mounted) return;
    setState(() => _emailLoading = false);
    if (r.user != null) {
      widget.onAuthenticated();
    } else if (r.needsVerification) {
      setState(() => _error = 'Not verified yet. Tap the link in your email, then try again.');
    } else if (r.error != null) {
      setState(() => _error = r.error);
    }
  }

  Future<void> _google() async {
    if (_busy) return;
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    final err = await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleLoading = false);
    if (err == null && ref.read(authProvider).mode == AuthMode.signedIn) {
      widget.onAuthenticated();
    } else if (err != null) {
      setState(() => _error = err);
    }
  }

  Future<void> _forgotPassword() async {
    final ctrl = TextEditingController(text: _email.text.trim());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A1F3A),
        title: const Text('Reset password', style: TextStyle(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Enter your email — we will send a reset link.', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send')),
        ],
      ),
    );
    if (ok != true) return;
    final err = await ref.read(authProvider.notifier).sendPasswordReset(ctrl.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? 'Reset link sent. Check your inbox.')),
    );
  }

  Widget _verifyView() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mark_email_unread_outlined, size: 56, color: AppTheme.goldSoft),
          const SizedBox(height: 16),
          const Text('Verify your email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 10),
          Text(
            'We sent a verification link to\n$_pendingEmail\n\nOpen it, then tap "I\'ve verified" to continue.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.muted, height: 1.4),
          ),
          const SizedBox(height: 22),
          if (_error != null) ...[
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.live, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
          ],
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _emailLoading ? null : _verifyAndContinue,
            child: _emailLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text("I've verified — Continue", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _resending ? null : _resend,
            child: Text(_resending ? 'Sending…' : 'Resend email', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _needsVerify = false;
              _error = null;
              _isSignUp = false;
            }),
            child: const Text('Back to Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (_needsVerify) return _verifyView();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand ball glyph — only on the (shorter) login form so sign-up
          // stays non-scrollable.
          if (!_isSignUp) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accent, width: 2),
                  boxShadow: [
                    BoxShadow(color: AppTheme.accent.withValues(alpha: 0.40), blurRadius: 22, spreadRadius: 1),
                  ],
                ),
                child: ClipOval(
                  child: SizedBox(width: 72, height: 72, child: Image.asset('assets/icon.png', fit: BoxFit.cover)),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
          Text(
            (_isSignUp ? 'Create Account' : 'Welcome Back').toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTheme.headline.copyWith(fontSize: 28, letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Center(
            child: Container(width: 40, height: 3, decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 10),
          Text(
            _isSignUp ? 'Sign up to vote and sync across devices.' : 'Sign in to vote on matches.',
            textAlign: TextAlign.center,
            style: AppTheme.caption.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 22),
          if (_isSignUp) ...[
            TextFormField(
              controller: _name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: validateName,
              decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: _email,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: validateEmail,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            obscureText: _obscure,
            textInputAction: _isSignUp ? TextInputAction.next : TextInputAction.done,
            validator: validatePassword,
            onFieldSubmitted: (_) => _isSignUp ? null : _submitEmail(),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          if (_isSignUp) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirm,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              validator: (v) => v != _password.text ? 'Passwords do not match' : null,
              onFieldSubmitted: (_) => _submitEmail(),
              decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_outline)),
            ),
          ],
          if (!_isSignUp) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _busy ? null : _forgotPassword,
                child: const Text('Forgot password?', style: TextStyle(color: AppTheme.goldSoft, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ] else
            const SizedBox(height: 12),
          if (_error != null) ...[
            const SizedBox(height: 4),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.live, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
          ],
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: AppTheme.deep, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _busy ? null : _submitEmail,
            child: _emailLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.deep))
                : Text((_isSignUp ? 'Create Account' : 'Sign In').toUpperCase(), style: AppTheme.title.copyWith(fontSize: 15, color: AppTheme.deep, letterSpacing: 1)),
          ),
          // Google + Guest are sign-in shortcuts only; hidden in sign-up so the
          // form stays non-scrollable and Google isn't asked for name/confirm.
          if (!_isSignUp) ...[
            const SizedBox(height: 14),
            Row(children: const [
              Expanded(child: Divider(color: Color(0x33FFFFFF))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or', style: TextStyle(color: AppTheme.muted, fontSize: 12))),
              Expanded(child: Divider(color: Color(0x33FFFFFF))),
            ]),
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _busy ? null : _google,
              icon: _googleLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.g_mobiledata, size: 26),
              label: Text(_googleLoading ? 'Signing in…' : 'Continue with Google', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _busy ? null : widget.onGuest,
              child: const Text('Continue as Guest', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ],
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_isSignUp ? 'Already have an account?' : "Don't have an account?", style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
            TextButton(
              onPressed: _busy ? null : _toggleMode,
              child: Text((_isSignUp ? 'Sign In' : 'Sign Up').toUpperCase(), style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
            ),
          ]),
          TextButton(
            onPressed: openPrivacyPolicy,
            child: const Text('Privacy Policy', style: TextStyle(color: AppTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
