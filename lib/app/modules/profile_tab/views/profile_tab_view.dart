import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/profile_tab/controllers/profile_tab_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class ProfileTab extends GetView<ProfileTabController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.main.isLoggedIn.value
          ? _LoggedInProfile(main: controller.main)
          : const _GuestProfile(),
    );
  }
}

// ── Logged In ────────────────────────────────────────────────────────────────

class _LoggedInProfile extends StatelessWidget {
  final MainController main;
  const _LoggedInProfile({required this.main});

  @override
  Widget build(BuildContext context) {
    final user = main.currentUser.value;
    if (user == null) {
      return const Center(child: CircularProgressIndicator(color: kPrimary));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _ProfileHeader(user: user),

          const SizedBox(height: 8),

          // ── Order shortcuts ─────────────────────────────────────────────
          // _OrderShortcuts(),

          // const SizedBox(height: 8),

          // ── Akun ────────────────────────────────────────────────────────
          _MenuCard(
            title: 'Akun',
            items: [
              _MenuRow(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi',
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
              ),
              _MenuRow(
                icon: Icons.location_on_outlined,
                label: 'Alamat Pengiriman',
                onTap: () {},
              ),
              _MenuRow(
                icon: Icons.credit_card_outlined,
                label: 'Metode Pembayaran',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Lainnya ─────────────────────────────────────────────────────
          _MenuCard(
            title: 'Lainnya',
            items: [
              _MenuRow(
                icon: Icons.help_outline_rounded,
                label: 'Pusat Bantuan',
                onTap: () {},
              ),
              _MenuRow(
                icon: Icons.star_outline_rounded,
                label: 'Beri Nilai Aplikasi',
                onTap: () {},
              ),
              _MenuRow(
                icon: Icons.info_outline_rounded,
                label: 'Tentang Parela',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Logout ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: _MenuRow(
              icon: Icons.logout_rounded,
              label: 'Keluar',
              color: Colors.red,
              onTap: main.logout,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimary, Color(0xFFE8A0C0)],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          // Avatar + Edit
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(40),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.verified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(100)),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderShortcuts extends StatelessWidget {
  final _items = const [
    (Icons.access_time_rounded, 'Menunggu'),
    (Icons.inventory_2_outlined, 'Dikemas'),
    (Icons.local_shipping_outlined, 'Dikirim'),
    (Icons.check_circle_outline, 'Selesai'),
    (Icons.rate_review_outlined, 'Ulasan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.MY_ORDERS),
                  child: const Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: TextStyle(fontSize: 12, color: kSubtext),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: kSubtext),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: _items.map((e) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.MY_ORDERS),
                  child: Column(
                    children: [
                      Icon(e.$1, size: 26, color: kPrimary),
                      const SizedBox(height: 6),
                      Text(
                        e.$2,
                        style: const TextStyle(fontSize: 11, color: kText),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Menu Card ─────────────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final String title;
  final List<_MenuRow> items;
  const _MenuCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kSubtext,
                letterSpacing: 0.3,
              ),
            ),
          ),
          ...items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                e.value,
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFF5F5F5),
                  ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? kText;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: c),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: c,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (color == null)
              const Icon(Icons.chevron_right, size: 18, color: kSubtext),
          ],
        ),
      ),
    );
  }
}

// ── Guest ─────────────────────────────────────────────────────────────────────

class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Guest header
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kPrimary, Color(0xFFE8A0C0)],
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 28,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(40),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Halo, Tamu!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masuk untuk pengalaman belanja terbaik',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Login / Register card
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimary,
                    side: const BorderSide(color: kPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        _MenuCard(
          title: 'Lainnya',
          items: [
            _MenuRow(
              icon: Icons.help_outline_rounded,
              label: 'Pusat Bantuan',
              onTap: () {},
            ),
            _MenuRow(
              icon: Icons.star_outline_rounded,
              label: 'Beri Nilai Aplikasi',
              onTap: () {},
            ),
            _MenuRow(
              icon: Icons.info_outline_rounded,
              label: 'Tentang Parela',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
