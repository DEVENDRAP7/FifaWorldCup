import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// Shimmer palette — light grey.
const _shimmerBase = Color(0xFFDDE1E7);     // light grey card fill
const _shimmerHi = Color(0xFFF4F6F9);       // bright sweep
const _shimmerBlock = Color(0xFFC6CCD4);    // slightly darker placeholder block

/// Wraps any skeleton tree in the standard light-grey shimmer sweep.
class ShimmerBox extends StatelessWidget {
  final Widget child;
  const ShimmerBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: _shimmerBase,
        highlightColor: _shimmerHi,
        period: const Duration(milliseconds: 1300),
        child: child,
      );
}

class Skeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const Skeleton({super.key, this.width, this.height = 12, this.radius = 6});
  @override
  Widget build(BuildContext context) => Container(
        width: width, height: height,
        decoration: BoxDecoration(color: _shimmerBlock, borderRadius: BorderRadius.circular(radius)),
      );
}

class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s12, 0, AppTheme.s12, AppTheme.s12),
        child: ShimmerBox(
          child: Container(
            decoration: BoxDecoration(
              color: _shimmerBase,
              borderRadius: BorderRadius.circular(AppTheme.rLg),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
              // header band (stage + status)
              Padding(
                padding: EdgeInsets.fromLTRB(14, 11, 12, 11),
                child: Row(children: [
                  Skeleton(width: 90, height: 10),
                  Spacer(),
                  Skeleton(width: 46, height: 16, radius: 8),
                ]),
              ),
              // teams + score
              Padding(
                padding: EdgeInsets.fromLTRB(14, 4, 14, 16),
                child: Row(children: [
                  Expanded(child: Column(children: [
                    Skeleton(width: 34, height: 34, radius: 999),
                    SizedBox(height: 8),
                    Skeleton(width: 64, height: 11),
                  ])),
                  Skeleton(width: 52, height: 30, radius: 6),
                  Expanded(child: Column(children: [
                    Skeleton(width: 34, height: 34, radius: 999),
                    SizedBox(height: 8),
                    Skeleton(width: 64, height: 11),
                  ])),
                ]),
              ),
              // footer band (venue)
              Padding(
                padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Skeleton(width: double.infinity, height: 10),
              ),
            ]),
          ),
        ),
      );
}

class SkeletonList extends StatelessWidget {
  final int count;
  const SkeletonList({super.key, this.count = 6});
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.only(top: AppTheme.s12),
        itemCount: count,
        itemBuilder: (_, _) => const MatchCardSkeleton(),
      );
}

class GroupCardSkeleton extends StatelessWidget {
  const GroupCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(AppTheme.s12, 0, AppTheme.s12, AppTheme.s12),
        child: ShimmerBox(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.s16),
            decoration: BoxDecoration(color: _shimmerBase, borderRadius: BorderRadius.circular(AppTheme.rLg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
              Skeleton(width: 90, height: 14),
              SizedBox(height: AppTheme.s16),
              Skeleton(width: double.infinity, height: 14),
              SizedBox(height: AppTheme.s12),
              Skeleton(width: double.infinity, height: 14),
              SizedBox(height: AppTheme.s12),
              Skeleton(width: double.infinity, height: 14),
              SizedBox(height: AppTheme.s12),
              Skeleton(width: double.infinity, height: 14),
            ]),
          ),
        ),
      );
}

class GroupsListSkeleton extends StatelessWidget {
  const GroupsListSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.only(top: AppTheme.s12),
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
