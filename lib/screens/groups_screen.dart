import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/group_table.dart';
import '../widgets/skeleton.dart';
import '../theme/app_theme.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(groupsProvider);
    return s.when(
      loading: () => const GroupsListSkeleton(),
      error: (e, _) => Column(children: [
        ReconnectingBanner(onRetry: () => ref.read(groupsProvider.notifier).refresh()),
        const Expanded(child: GroupsListSkeleton()),
      ]),
      data: (groups) {
        if (groups.isEmpty) return const GroupsListSkeleton();
        return RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () => ref.read(groupsProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppTheme.s12),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppTheme.s12),
            itemBuilder: (_, i) => GroupTable(group: groups[i]),
          ),
        );
      },
    );
  }
}
