import 'package:flutter/material.dart';

// ── Base shimmer animation ────────────────────────────────────────────────────

class AppShimmer extends StatefulWidget {
  final Widget child;
  const AppShimmer({super.key, required this.child});

  @override
  State<AppShimmer> createState() => _AppShimmerState();

  // ignore: library_private_types_in_public_api
  static _AppShimmerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppShimmerState>();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> get animation => _anim;

  @override
  Widget build(BuildContext context) => widget.child;
}

// ── Shimmer box (single item) ─────────────────────────────────────────────────

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final shimmer = AppShimmer.of(context);
    if (shimmer == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }
    return AnimatedBuilder(
      animation: shimmer.animation,
      builder: (_, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(shimmer.animation.value - 1, 0),
              end: Alignment(shimmer.animation.value + 1, 0),
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF6F6F6),
                Color(0xFFEEEEEE),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ── Order card skeleton ───────────────────────────────────────────────────────

class ShimmerOrderCard extends StatelessWidget {
  const ShimmerOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const ShimmerBox(width: 100, height: 12, radius: 4),
                const Spacer(),
                const ShimmerBox(width: 60, height: 20, radius: 10),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          // Items
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Column(
              children: const [
                _ShimmerItemRow(),
                SizedBox(height: 6),
                _ShimmerItemRow(),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: const [
                ShimmerBox(width: 50, height: 11, radius: 4),
                Spacer(),
                ShimmerBox(width: 80, height: 14, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerItemRow extends StatelessWidget {
  const _ShimmerItemRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        ShimmerBox(width: 5, height: 5, radius: 10),
        SizedBox(width: 8),
        ShimmerBox(width: 160, height: 12, radius: 4),
        Spacer(),
        ShimmerBox(width: 24, height: 11, radius: 4),
      ],
    );
  }
}

// ── Product image row skeleton (order detail) ─────────────────────────────────

class ShimmerProductRow extends StatelessWidget {
  const ShimmerProductRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 58, height: 58, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(width: double.infinity, height: 13, radius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 100, height: 11, radius: 4),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 30, height: 12, radius: 4),
                    ShimmerBox(width: 70, height: 13, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Product card skeleton (grid) ──────────────────────────────────────────────

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(
            width: double.infinity,
            height: 140,
            radius: 12,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 12, radius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 80, height: 12, radius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: 60, height: 14, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Simple list row skeleton ──────────────────────────────────────────────────

class ShimmerListRow extends StatelessWidget {
  const ShimmerListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          ShimmerBox(width: 44, height: 44, radius: 8),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 13, radius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 140, height: 11, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Convenience wrapper: N order card skeletons ───────────────────────────────

class ShimmerOrderList extends StatelessWidget {
  final int count;
  const ShimmerOrderList({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        child: Column(
          children: List.generate(count, (_) => const ShimmerOrderCard()),
        ),
      ),
    );
  }
}

class ShimmerProductList extends StatelessWidget {
  final int count;
  const ShimmerProductList({super.key, this.count = 2});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(count, (_) => const ShimmerProductRow()),
      ),
    );
  }
}

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                children: [
                  const ShimmerBox(width: 80, height: 80, radius: 40),
                  const SizedBox(height: 12),
                  const ShimmerBox(width: 120, height: 14, radius: 4),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: 180, height: 12, radius: 4),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ShimmerBox(width: 80, height: 36, radius: 8),
                      SizedBox(width: 12),
                      ShimmerBox(width: 80, height: 36, radius: 8),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu card 1
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: List.generate(3, (_) => const ShimmerListRow()),
              ),
            ),
            const SizedBox(height: 8),
            // Menu card 2
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: List.generate(2, (_) => const ShimmerListRow()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerProductGrid extends StatelessWidget {
  final int count;
  const ShimmerProductGrid({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
          children: List.generate(count, (_) => const ShimmerProductCard()),
        ),
      ),
    );
  }
}
