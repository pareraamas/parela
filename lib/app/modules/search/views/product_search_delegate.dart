import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/search/controllers/search_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final ProductSearchController ctrl;

  ProductSearchDelegate(this.ctrl)
      : super(searchFieldLabel: 'Cari produk beauty...');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: kText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: kSubtext, fontSize: 14),
        filled: true,
        fillColor: kBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kPrimary, width: 1.5),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.close, color: kSubtext, size: 20),
        ),
      TextButton(
        onPressed: () {
          if (query.trim().isNotEmpty) showResults(context);
        },
        child: const Text(
          'Cari',
          style: TextStyle(
            color: kPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _RecentSearches(ctrl: ctrl, onTap: (q) {
        query = q;
        showResults(context);
      });
    }

    final suggestions = ctrl.getSuggestions(query);
    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 56, color: kSubtext),
            const SizedBox(height: 12),
            Text(
              'Tidak ada produk untuk "$query"',
              style: const TextStyle(color: kSubtext, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final p = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search_rounded, color: kSubtext, size: 20),
          title: Text(
            p.name,
            style: const TextStyle(fontSize: 13, color: kText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            p.brand,
            style: const TextStyle(fontSize: 11, color: kSubtext),
          ),
          trailing: const Icon(Icons.north_west_rounded, color: kSubtext, size: 16),
          onTap: () {
            query = p.name;
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ctrl.addSearch(query);
      close(context, query);
      Get.toNamed(Routes.SEARCH_RESULT, arguments: query);
    });
    return const SizedBox.shrink();
  }
}

// ── Recent searches ───────────────────────────────────────────────────────────

class _RecentSearches extends StatelessWidget {
  final ProductSearchController ctrl;
  final void Function(String) onTap;

  const _RecentSearches({required this.ctrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recents = ctrl.recentSearches;
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          if (recents.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pencarian Terbaru',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
                GestureDetector(
                  onTap: ctrl.clearAll,
                  child: const Text(
                    'Hapus Semua',
                    style: TextStyle(fontSize: 12, color: kPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...recents.map(
              (q) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history_rounded, color: kSubtext, size: 20),
                title: Text(
                  q,
                  style: const TextStyle(fontSize: 13, color: kText),
                ),
                trailing: GestureDetector(
                  onTap: () => ctrl.removeSearch(q),
                  child: const Icon(Icons.close, color: kSubtext, size: 16),
                ),
                onTap: () => onTap(q),
              ),
            ),
            const Divider(height: 24),
          ],
          const Text(
            'Populer di Parela',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Lipstik',
              'Foundation',
              'Serum',
              'Maskara',
              'Skincare',
              'Sunscreen',
              'Eyeliner',
              'Blush',
            ].map((tag) => GestureDetector(
              onTap: () => onTap(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: kPrimaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      );
    });
  }
}
