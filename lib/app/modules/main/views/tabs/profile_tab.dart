import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserRepository>().getUser();
    return Column(
      children: [
        const AppHeader(title: 'Profile'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: kPrimaryLight,
                        child: Icon(Icons.person, size: 40, color: kPrimary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kText,
                            ),
                          ),
                          if (user.verified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: kPrimary, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(color: kSubtext, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimary,
                          side: const BorderSide(color: kPrimary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _MenuSection(
                  items: [
                    _MenuItem(
                      icon: Icons.shopping_bag_outlined,
                      label: 'My Orders',
                      onTap: () => Get.toNamed(Routes.MY_ORDERS),
                    ),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'My Addresses',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.payment_outlined,
                      label: 'Payment Methods',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MenuSection(
                  items: [
                    _MenuItem(
                      icon: Icons.help_outline,
                      label: 'Help Center',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.star_outline,
                      label: 'Rate App',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.info_outline,
                      label: 'About',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MenuSection(
                  items: [
                    _MenuItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      color: Colors.red,
                      onTap: () => Get.offAllNamed(Routes.LOGIN),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: item.color ?? kText, size: 22),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: item.color ?? kText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: item.color == null
                    ? const Icon(Icons.chevron_right, color: kSubtext)
                    : null,
                onTap: item.onTap,
              ),
              if (items.last != item)
                const Divider(height: 1, indent: 56, color: kBackground),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
