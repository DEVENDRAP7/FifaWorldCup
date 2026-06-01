import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_links.dart';
import '../models/match.dart';
import '../providers/auth_provider.dart';
import '../providers/providers.dart';
import '../providers/vote_provider.dart';
import '../providers/locale_provider.dart';
import '../services/auth_service.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import '../widgets/flag.dart';
import '../l10n/gen/app_localizations.dart';
import 'about_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context);
    final user = ref.watch(authProvider);
    final votes = ref.watch(myVotesProvider);
    return ListView(padding: const EdgeInsets.all(AppTheme.s16), children: [
      _profile(t, user),
      const SizedBox(height: AppTheme.s24),
      _sectionLabel(t.settingsProfile),
      _group([
        _tile(
          icon: Icons.favorite_outline,
          title: t.settingsFavoriteTeam,
          subtitle: user.favoriteTeam ?? t.settingsNotSet,
          trailing: user.favoriteCountryCode != null && user.favoriteCountryCode!.isNotEmpty
              ? ClipRRect(borderRadius: BorderRadius.circular(2), child: SizedBox(width: 28, height: 20, child: CachedNetworkImage(imageUrl: 'https://api.fifa.com/api/v3/picture/flags-sq-4/${user.favoriteCountryCode}', fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())))
              : null,
          showChevron: true,
          onTap: () {
            AdService.instance.maybeShowInterstitial();
            _showFavTeamSheet(context);
          },
        ),
        _tile(
          icon: Icons.how_to_vote_outlined,
          title: t.profileYourVotes,
          subtitle: t.profileVotesCount(votes.length),
          showChevron: true,
          onTap: () {
            AdService.instance.maybeShowInterstitial();
            _showVotesSheet(context);
          },
        ),
        _tile(
          icon: Icons.language_outlined,
          title: t.profileLanguage,
          subtitle: ref.watch(localeProvider) == null ? t.languageSystem : languageNameFor(ref.watch(localeProvider)!.languageCode),
          showChevron: true,
          onTap: () => _showLanguageSheet(context),
        ),
      ]),
      const SizedBox(height: AppTheme.s24),
      _sectionLabel(t.profileAboutSection),
      _group([
        _tile(icon: Icons.info_outline, title: t.profileAbout, subtitle: t.profileAppInfo, showChevron: true, onTap: () {
          AdService.instance.maybeShowInterstitial();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
        }),
        _tile(icon: Icons.privacy_tip_outlined, title: t.profilePrivacy, showChevron: true, onTap: openPrivacyPolicy),
        _tile(icon: Icons.star_outline, title: t.profileRate, showChevron: true, onTap: () => _soon(context)),
        _tile(icon: Icons.share_outlined, title: t.profileShare, showChevron: true, onTap: () => _soon(context)),
      ]),
      const SizedBox(height: AppTheme.s24),
      _sectionLabel(t.settingsActions),
      _group([
        _tile(
          icon: Icons.refresh,
          title: t.profileClearVotes,
          subtitle: t.profileClearVotesSub,
          onTap: () {
            AdService.instance.maybeShowInterstitial();
            ref.read(myVotesProvider.notifier).clearAll();
          },
        ),
        _tile(
          icon: Icons.delete_forever_outlined,
          title: t.profileDeleteAccount,
          subtitle: t.profileDeleteAccountSub,
          titleColor: AppTheme.live,
          iconColor: AppTheme.live,
          onTap: () => _confirmDelete(context, ref),
        ),
        _tile(
          icon: Icons.logout,
          title: t.settingsSignOut,
          onTap: () => ref.read(authProvider.notifier).signOut(),
        ),
      ]),
      const SizedBox(height: AppTheme.s32),
      Center(child: Text('World Cup 2026 · v1.0', style: AppTheme.caption)),
      const SizedBox(height: AppTheme.s8),
      Center(child: Text('Data via api.fifa.com', style: AppTheme.caption.copyWith(fontSize: 10))),
    ]);
  }

  void _soon(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppL10n.of(context).profileComingSoon)),
      );

  void _showFavTeamSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1633),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => const _FavTeamSheet(),
    );
  }

  void _showVotesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1633),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => const _MyVotesSheet(),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1633),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => const _LanguageSheet(),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context);
    final user = ref.read(authProvider);
    final isGuest = user.mode != AuthMode.signedIn;
    final needsPassword = !isGuest && AuthService.isPasswordUser;
    final pwCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        bool deleting = false;
        String? error;
        return StatefulBuilder(builder: (ctx, setLocal) {
          Future<void> run() async {
            if (deleting) return;
            if (needsPassword && pwCtrl.text.isEmpty) {
              setLocal(() => error = t.deleteEnterPassword);
              return;
            }
            setLocal(() {
              deleting = true;
              error = null;
            });
            final err = await ref.read(authProvider.notifier).deleteAccount(password: needsPassword ? pwCtrl.text : null);
            if (!ctx.mounted) return;
            if (err == null) {
              Navigator.pop(ctx); // state reset → HomeScreen shows onboarding
            } else {
              setLocal(() {
                deleting = false;
                error = err;
              });
            }
          }

          return AlertDialog(
            backgroundColor: const Color(0xFF2A1F3A),
            title: Text(t.deleteTitle, style: const TextStyle(color: Colors.white)),
            content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(t.deleteBody, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              if (needsPassword) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: pwCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: t.deleteConfirmPassword),
                ),
              ],
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(error!, style: const TextStyle(color: AppTheme.live, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ]),
            actions: [
              TextButton(onPressed: deleting ? null : () => Navigator.pop(ctx), child: Text(t.commonCancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppTheme.live),
                onPressed: deleting ? null : run,
                child: deleting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(t.commonDelete),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _profile(AppL10n t, UserState user) => Container(
        padding: const EdgeInsets.all(AppTheme.s20),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.usaBlue, AppTheme.mexicoGreen]),
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? CachedNetworkImage(imageUrl: user.photoUrl!, fit: BoxFit.cover, errorWidget: (_, _, _) => _avatarInitial(user))
                : _avatarInitial(user),
          ),
          const SizedBox(width: AppTheme.s16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.mode == AuthMode.signedIn ? (user.name?.isNotEmpty == true ? user.name! : t.settingsGuest) : t.settingsGuest, style: AppTheme.title),
            const SizedBox(height: 2),
            Text(user.mode == AuthMode.signedIn ? (user.email ?? t.settingsSignedIn) : t.settingsGuestSession, style: AppTheme.caption),
          ])),
        ]),
      );

  Widget _avatarInitial(UserState user) => Center(
        child: Text(
          (user.name?.isNotEmpty == true ? user.name![0] : 'G').toUpperCase(),
          style: AppTheme.headline.copyWith(color: Colors.white),
        ),
      );

  Widget _sectionLabel(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s4, 0, 0, AppTheme.s8),
        child: Text(t, style: AppTheme.overline),
      );

  Widget _group(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(AppTheme.rMd),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(height: 1, indent: 56, color: AppTheme.border),
          ],
        ]),
      );

  Widget _tile({required IconData icon, required String title, String? subtitle, Widget? trailing, bool showChevron = false, VoidCallback? onTap, Color? titleColor, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.rMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: AppTheme.s12),
        child: Row(children: [
          Icon(icon, color: iconColor ?? AppTheme.muted, size: 20),
          const SizedBox(width: AppTheme.s16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTheme.bodyBold.copyWith(color: titleColor ?? AppTheme.text)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle, style: AppTheme.caption),
            ],
          ])),
          if (trailing != null) trailing,
          if (showChevron) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.chevron_right, color: AppTheme.mutedSoft, size: 18)),
        ]),
      ),
    );
  }
}

class _FavTeamSheet extends ConsumerWidget {
  const _FavTeamSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context);
    final user = ref.watch(authProvider);
    final matches = ref.watch(matchesProvider).value ?? const <WcMatch>[];
    final teams = <(String, String)>{};
    for (final m in matches) {
      if (m.homeName.isNotEmpty) teams.add((m.homeName, m.homeCountryCode));
      if (m.awayName.isNotEmpty) teams.add((m.awayName, m.awayCountryCode));
    }
    final sorted = teams.toList()..sort((a, b) => a.$1.compareTo(b.$1));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.profileChooseTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 12),
          Flexible(
            child: sorted.isEmpty
                ? const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
                : GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    shrinkWrap: true,
                    children: sorted.map((team) {
                      final isSel = user.favoriteCountryCode == team.$2 && user.favoriteTeam == team.$1;
                      return GestureDetector(
                        onTap: () async {
                          await ref.read(authProvider.notifier).setFavoriteTeam(team.$1, team.$2);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.gold.withValues(alpha: .35) : AppTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSel ? AppTheme.gold : AppTheme.border, width: isSel ? 2 : 1),
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            FlagImage(url: team.$2.isEmpty ? '' : 'https://api.fifa.com/api/v3/picture/flags-sq-4/${team.$2}', width: 44, height: 30, radius: 4),
                            const SizedBox(height: 4),
                            Text(team.$1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ]),
      ),
    );
  }
}

class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context);
    final current = ref.watch(localeProvider)?.languageCode;

    Widget row({required String label, required bool selected, required VoidCallback onTap}) => InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
            child: Row(children: [
              Expanded(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: selected ? FontWeight.w800 : FontWeight.w600))),
              if (selected) const Icon(Icons.check_circle, color: AppTheme.gold, size: 20),
            ]),
          ),
        );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.profileLanguage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 6),
          Flexible(
            child: ListView(shrinkWrap: true, children: [
              row(
                label: t.languageSystem,
                selected: current == null,
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale(null);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              const Divider(height: 1, color: AppTheme.border),
              ...supportedLanguages.map((l) => row(
                    label: l.$2,
                    selected: current == l.$1,
                    onTap: () async {
                      await ref.read(localeProvider.notifier).setLocale(Locale(l.$1));
                      if (context.mounted) Navigator.pop(context);
                    },
                  )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _MyVotesSheet extends ConsumerWidget {
  const _MyVotesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppL10n.of(context);
    final myVotes = ref.watch(myVotesProvider);
    final matches = ref.watch(matchesProvider).value ?? const <WcMatch>[];
    final byId = {for (final m in matches) m.id: m};

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.profileYourVotes, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 12),
          if (myVotes.isEmpty)
            Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: Center(child: Text(t.profileNoVotes, style: const TextStyle(color: Colors.white70))))
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: myVotes.entries.map((e) {
                  final m = byId[e.key];
                  final home = m?.homeName ?? 'Home';
                  final away = m?.awayName ?? 'Away';
                  final pick = e.value == VoteSide.home ? home : (e.value == VoteSide.away ? away : t.profileDraw);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m != null ? '$home vs $away' : 'Match ${e.key}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(t.profileYouPicked(pick), style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.w700)),
                      ])),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.white54),
                        onPressed: () => ref.read(myVotesProvider.notifier).clear(e.key),
                      ),
                    ]),
                  );
                }).toList(),
              ),
            ),
        ]),
      ),
    );
  }
}
