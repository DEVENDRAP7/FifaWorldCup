import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const Skeleton({super.key, this.width, this.height = 12, this.radius = 6});
  @override
  Widget build(BuildContext context) => Container(
        width: width, height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      );
}

class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        period: const Duration(milliseconds: 1400),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppTheme.s12),
          padding: const EdgeInsets.all(AppTheme.s16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(AppTheme.rLg)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
            Row(children: [
              Skeleton(width: 80, height: 10),
              Spacer(),
              Skeleton(width: 48, height: 18, radius: 6),
            ]),
            SizedBox(height: AppTheme.s16),
            Row(children: [
              Expanded(child: Column(children: [Skeleton(width: 40, height: 28, radius: 4), SizedBox(height: 6), Skeleton(width: 70, height: 12)])),
              Skeleton(width: 48, height: 24),
              Expanded(child: Column(children: [Skeleton(width: 40, height: 28, radius: 4), SizedBox(height: 6), Skeleton(width: 70, height: 12)])),
            ]),
            SizedBox(height: AppTheme.s12),
            Skeleton(width: double.infinity, height: 10),
          ]),
        ),
      );
}

class SkeletonList extends StatelessWidget {
  final int count;
  const SkeletonList({super.key, this.count = 6});
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(AppTheme.s12),
        itemCount: count,
        itemBuilder: (_, _) => const MatchCardSkeleton(),
      );
}

class GroupCardSkeleton extends StatelessWidget {
  const GroupCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        period: const Duration(milliseconds: 1400),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppTheme.s12),
          padding: const EdgeInsets.all(AppTheme.s16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(AppTheme.rLg)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
            Skeleton(width: 80, height: 14),
            SizedBox(height: AppTheme.s12),
            Skeleton(width: double.infinity, height: 16),
            SizedBox(height: AppTheme.s8),
            Skeleton(width: double.infinity, height: 16),
            SizedBox(height: AppTheme.s8),
            Skeleton(width: double.infinity, height: 16),
            SizedBox(height: AppTheme.s8),
            Skeleton(width: double.infinity, height: 16),
          ]),
        ),
      );
}

class GroupsListSkeleton extends StatelessWidget {
  const GroupsListSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(AppTheme.s12),
        itemCount: 6,
        itemBuilder: (_, _) => const GroupCardSkeleton(),
      );
}

/// Thin banner shown when data fetch fails but skeleton is rendering retry attempts.
class ReconnectingBanner extends StatelessWidget {
  final VoidCallback? onRetry;
  const ReconnectingBanner({super.key, this.onRetry});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: 8),
        color: const Color(0xFFFEF3C7),
        child: Row(children: [
          const SizedBox(
            width: 14, height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB45309)),
          ),
          const SizedBox(width: AppTheme.s12),
          const Expanded(child: Text('Reconnecting…', style: TextStyle(color: Color(0xFFB45309), fontSize: 12, fontWeight: FontWeight.w600))),
          if (onRetry != null)
            InkWell(
              onTap: onRetry,
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2), child: Text('Retry', style: TextStyle(color: Color(0xFFB45309), fontSize: 12, fontWeight: FontWeight.w800))),
            ),
        ]),
      );
}
