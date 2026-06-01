import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/contest_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final contest = ref.watch(contestProvider);
    return ListView(padding: const EdgeInsets.all(AppTheme.s16), children: [
      _profile(user),
      const SizedBox(height: AppTheme.s24),
      _sectionLabel('PROFILE'),
      _group([
        _tile(
          icon: Icons.favorite_outline,
          title: 'Favorite Team',
          subtitle: user.favoriteTeam ?? 'Not set',
          trailing: user.favoriteCountryCode != null && user.favoriteCountryCode!.isNotEmpty
              ? ClipRRect(borderRadius: BorderRadius.circular(2), child: SizedBox(width: 28, height: 20, child: CachedNetworkImage(imageUrl: 'https://api.fifa.com/api/v3/picture/flags-sq-4/${user.favoriteCountryCode}', fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox.shrink())))
              : null,
          showChevron: true,
        ),
        _tile(icon: Icons.monetization_on_outlined, title: 'Caps Balance', subtitle: '${contest.caps} caps · ${contest.picks.length} picks', showChevron: true),
      ]),
      const SizedBox(height: AppTheme.s24),
      _sectionLabel('ACTIONS'),
      _group([
        _tile(
          icon: Icons.refresh,
          title: 'Reset Caps to 1000',
          subtitle: 'Resets balance and picks history',
          onTap: () => ref.read(contestProvider.notifier).reset(),
        ),
        _tile(
          icon: Icons.logout,
          title: 'Sign Out',
          titleColor: AppTheme.live,
          iconColor: AppTheme.live,
          onTap: () => ref.read(authProvider.notifier).signOut(),
        ),
      ]),
      const SizedBox(height: AppTheme.s32),
      Center(child: Text('FIFA WC 2026 · v1.0', style: AppTheme.caption)),
      const SizedBox(height: AppTheme.s8),
      Center(child: Text('Data via api.fifa.com', style: AppTheme.caption.copyWith(fontSize: 10))),
    ]);
  }

  Widget _profile(UserState user) => Container(
        padding: const EdgeInsets.all(AppTheme.s20),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.usaBlue, AppTheme.mexicoGreen]),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text((user.name?.isNotEmpty == true ? user.name![0] : 'G').toUpperCase(), style: AppTheme.headline.copyWith(color: Colors.white))),
          ),
          const SizedBox(width: AppTheme.s16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.mode == AuthMode.signedIn ? (user.name ?? 'User') : 'Guest', style: AppTheme.title),
            const SizedBox(height: 2),
            Text(user.mode == AuthMode.signedIn ? 'Signed in' : 'Guest session', style: AppTheme.caption),
          ])),
        ]),
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
