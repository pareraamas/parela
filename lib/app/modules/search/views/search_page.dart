import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
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
            // ── Search bar (Hero destination) ─────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: kText,
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: widget.heroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9FB),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: kSubtext,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
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
                                    Icons.close,
                                    color: kSubtext,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: kBackground),

            // ── Suggestions / Recent ──────────────────────────────────
            Expanded(
              child: _query.isEmpty
                  ? _RecentAndPopular(
                      ctrl: _ctrl,
                      onTap: _tapSuggestion,
                    )
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
            const SizedBox(height: 6),
            ...recents.map(
              (q) => ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 28,
                leading: const Icon(
                  Icons.history_rounded,
                  color: kSubtext,
                  size: 20,
                ),
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
            ]
                .map(
                  (tag) => GestureDetector(
                    onTap: () => onTap(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
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
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
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
          leading: const Icon(
            Icons.search_rounded,
            color: kSubtext,
            size: 20,
          ),
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
          trailing: const Icon(
            Icons.north_west_rounded,
            color: kSubtext,
            size: 16,
          ),
          onTap: () => onTap(p.name),
        );
      },
    );
  }
}
