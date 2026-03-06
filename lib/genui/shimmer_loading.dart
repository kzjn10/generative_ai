import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading placeholders that mimic the real product layouts.
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  /// Shimmer skeleton for the **list** display type.
  factory ShimmerLoading.list({Key? key, int itemCount = 3}) {
    return ShimmerLoading(
      key: key,
      child: Column(
        children: List.generate(
          itemCount,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i < itemCount - 1 ? 10 : 0),
            child: const _ListItemSkeleton(),
          ),
        ),
      ),
    );
  }

  /// Shimmer skeleton for the **grid** display type.
  factory ShimmerLoading.grid({Key? key, int itemCount = 4}) {
    return ShimmerLoading(
      key: key,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
        children: List.generate(itemCount, (_) => const _GridItemSkeleton()),
      ),
    );
  }

  /// Shimmer skeleton for the **single** (featured) display type.
  factory ShimmerLoading.single({Key? key}) {
    return ShimmerLoading(key: key, child: const _SingleItemSkeleton());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: child,
    );
  }
}

// ─── Skeleton shapes ─────────────────────────────────────────────

class _ListItemSkeleton extends StatelessWidget {
  const _ListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 70,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItemSkeleton extends StatelessWidget {
  const _GridItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 90,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleItemSkeleton extends StatelessWidget {
  const _SingleItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 240,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
