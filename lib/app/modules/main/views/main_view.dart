import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/modules/explore_tab/views/explore_tab_view.dart';
import 'package:parela/app/modules/home/views/home_view.dart';
import 'package:parela/app/modules/profile_tab/views/profile_tab_view.dart';
import 'package:parela/app/modules/transaction_tab/views/transaction_tab_view.dart';
import 'package:parela/app/modules/video_tab/views/video_tab_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isVideoTab = controller.tabIndex.value == 2;
      final statusBarStyle = isVideoTab
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            );
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarStyle,
        child: Scaffold(
          backgroundColor: isVideoTab ? Colors.black : Colors.white,
          extendBody: false,
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: controller.tabIndex.value,
              children: const [
                HomeTab(),
                ExploreTab(),
                VideoTab(),
                TransactionTab(),
                ProfileTab(),
              ],
            ),
          ),
          bottomNavigationBar: _BottomNav(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTab,
            cartCount: controller.cartCount.value,
            isVideoTab: isVideoTab,
          ),
        ),
      );
    });
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;
  final bool isVideoTab;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.cartCount,
    required this.isVideoTab,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isVideoTab ? Colors.black.withValues(alpha: 0.6) : Colors.white;
    final iconColor = isVideoTab ? Colors.white70 : kSubtext;
    final activeColor = isVideoTab ? Colors.white : kPrimary;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: isVideoTab
            ? null
            : const Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                iconColor: iconColor,
                activeColor: activeColor,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: 'Explore',
                isActive: currentIndex == 1,
                iconColor: iconColor,
                activeColor: activeColor,
                onTap: () => onTap(1),
              ),
              _VideoNavItem(isActive: currentIndex == 2, onTap: () => onTap(2)),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: 'Orders',
                isActive: currentIndex == 3,
                iconColor: iconColor,
                activeColor: activeColor,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentIndex == 4,
                iconColor: iconColor,
                activeColor: activeColor,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color iconColor;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.iconColor,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey<bool>(isActive),
                color: isActive ? activeColor : iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 10,
                color: isActive ? activeColor : iconColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoNavItem extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _VideoNavItem({required this.isActive, required this.onTap});

  @override
  State<_VideoNavItem> createState() => _VideoNavItemState();
}

class _VideoNavItemState extends State<_VideoNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant _VideoNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -4,
                child: Container(
                  width: 30,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF69C9D0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                right: -4,
                child: Container(
                  width: 30,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEE1D52),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.isActive ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _controller,
                    color: widget.isActive ? Colors.white : Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
