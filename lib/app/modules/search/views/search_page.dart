import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/search/controllers/search_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.heroTag = 'search-bar'});

  final String heroTag;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _textCtrl;
  late final FocusNode _focusNode;
  final ProductSearchController _ctrl = Get.find();
  String _query = '';

  @override
  void initState() {
    super.initState();
    final initial = (Get.arguments as String?) ?? '';
    _textCtrl = TextEditingController(text: initial);
    _query = initial;
    _focusNode = FocusNode();
    _textCtrl.addListener(() => setState(() => _query = _textCtrl.text));
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final q = _textCtrl.text.trim();
    if (q.isEmpty) return;
    _ctrl.addSearch(q);
    _focusNode.unfocus();
    Get.offNamed(Routes.SEARCH_RESULT, arguments: q);
  }

  void _tapSuggestion(String q) {
    _textCtrl.text = q;
    _textCtrl.selection = TextSelection.collapsed(offset: q.length);
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 16, 10),
              child: SizedBox(
                height: 38,
                child: Stack(
                  children: [
                    // Hero hanya untuk visual transition — tidak membungkus TextField
                    Positioned.fill(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kPrimary.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Konten interaktif di luar Hero agar bisa dapat focus
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.keyboard_arrow_left_rounded,
                                color: kSubtext,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                controller: _textCtrl,
                                focusNode: _focusNode,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => _submit(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: kText,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Cari produk beauty...',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: kSubtext,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (_query.isNotEmpty)
                              GestureDetector(
                                onTap: () => _textCtrl.clear(),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: kSubtext,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: kBackground),

            // ── Suggestions / Recent ──────────────────────────────────
            Expanded(
              child: _query.isEmpty
                  ? _RecentAndPopular(ctrl: _ctrl, onTap: _tapSuggestion)
                  : _LiveSuggestions(
                      query: _query,
                      ctrl: _ctrl,
                      onTap: _tapSuggestion,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent searches + popular tags ───────────────────────────────────────────

class _RecentAndPopular extends StatelessWidget {
  final ProductSearchController ctrl;
  final void Function(String) onTap;

  const _RecentAndPopular({required this.ctrl, required this.onTap});

  static const List<String> _tags = [
    'Lipstik',
    'Foundation',
    'Serum',
    'Maskara',
    'Skincare',
    'Sunscreen',
    'Eyeliner',
    'Blush',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recents = ctrl.recentSearches;
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          if (recents.isNotEmpty) ...[
            _SectionHeader(
              title: 'Pencarian Terbaru',
              action: 'Hapus Semua',
              onAction: ctrl.clearAll,
            ),
            const SizedBox(height: 10),
            ...recents.take(5).map(
              (q) => _RecentItem(
                label: q,
                onTap: () => onTap(q),
                onRemove: () => ctrl.removeSearch(q),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const _SectionHeader(title: 'Populer di Parela'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags
                .map(
                  (t) => GestureDetector(
                    onTap: () => onTap(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 246, 249),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kText,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(fontSize: 12, color: kPrimary),
            ),
          ),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentItem({
    required this.label,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.history_rounded, color: kSubtext, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: kText),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close_rounded, color: kSubtext, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Live suggestions while typing ────────────────────────────────────────────

class _LiveSuggestions extends StatelessWidget {
  final String query;
  final ProductSearchController ctrl;
  final void Function(String) onTap;

  const _LiveSuggestions({
    required this.query,
    required this.ctrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = ctrl.getSuggestions(query);
    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: kBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: kSubtext,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Produk tidak ditemukan untuk',
              style: TextStyle(color: kSubtext, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '"$query"',
              style: const TextStyle(
                color: kText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coba kata kunci lain',
              style: TextStyle(color: kSubtext, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: suggestions.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: 68,
        endIndent: 16,
        color: Color(0xFFF5F5F5),
      ),
      itemBuilder: (context, index) {
        final p = suggestions[index];
        return _SuggestionTile(
          product: p,
          query: query,
          onTap: () => onTap(p.name),
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final ProductModel product;
  final String query;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.product,
    required this.query,
    required this.onTap,
  });

  TextSpan _highlighted(String text) {
    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();
    final idx = lower.indexOf(qLower);
    if (idx < 0) {
      return TextSpan(
        text: text,
        style: const TextStyle(fontSize: 13, color: kText),
      );
    }
    return TextSpan(
      style: const TextStyle(fontSize: 13, color: kText),
      children: [
        if (idx > 0) TextSpan(text: text.substring(0, idx)),
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
        ),
        if (idx + query.length < text.length)
          TextSpan(text: text.substring(idx + query.length)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final swatch = product.color;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: swatch.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search_rounded,
                color: swatch.withValues(alpha: 0.8),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: _highlighted(product.name)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(fontSize: 11, color: kSubtext),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: kSubtext,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 11,
                          color: kPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.north_west_rounded, color: kSubtext, size: 14),
          ],
        ),
      ),
    );
  }
}
