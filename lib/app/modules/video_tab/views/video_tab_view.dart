import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/video_tab/controllers/video_tab_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoTab extends GetView<VideoTabController> {
  const VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Obx(() {
            if (controller.videos.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videos.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) => Obx(
                () => _VideoPage(
                  data: controller.videos[index],
                  isLiked: controller.likedStates[index],
                  isFollowed: controller.followedStates[index],
                  isActive:
                      controller.isTabActive.value &&
                      controller.currentPage.value == index,
                  onLike: () => controller.toggleLike(index),
                  onFollow: () => controller.toggleFollow(index),
                ),
              ),
            );
          }),
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FeedToggle(
                        label: 'Following',
                        isActive: controller.feedType.value == 1,
                        onTap: () => controller.setFeedType(1),
                      ),
                      const SizedBox(width: 20),
                      _FeedToggle(
                        label: 'For You',
                        isActive: controller.feedType.value == 0,
                        onTap: () => controller.setFeedType(0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // icon keranjang — top-right, sejajar dengan feed toggle
          Positioned(
            top: 0,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.toNamed(
                          main.isLoggedIn.value ? Routes.CART : Routes.LOGIN,
                        );
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(36, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        CupertinoIcons.cart,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    if (main.cartCount.value > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              main.isLoggedIn.value
                                  ? Routes.CART
                                  : Routes.LOGIN,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${main.cartCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isLiked;
  final bool isFollowed;
  final bool isActive;
  final VoidCallback onLike;
  final VoidCallback onFollow;

  const _VideoPage({
    required this.data,
    required this.isLiked,
    required this.isFollowed,
    required this.isActive,
    required this.onLike,
    required this.onFollow,
  });

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late VideoPlayerController _vc;
  bool _ready = false;
  bool _isPlaying = false;
  bool _productExpanded = false;
  ProductModel? _product;

  @override
  void initState() {
    super.initState();
    _vc = VideoPlayerController.asset(widget.data['videoUrl'] as String)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _ready = true);
          if (widget.isActive) _vc.play();
        }
      });
    _vc.addListener(_onPlaybackChanged);
  }

  void _onPlaybackChanged() {
    final playing = _vc.value.isPlaying;
    if (playing != _isPlaying && mounted) {
      setState(() => _isPlaying = playing);
    }
  }

  @override
  void didUpdateWidget(_VideoPage old) {
    super.didUpdateWidget(old);
    if (old.isActive != widget.isActive) {
      widget.isActive ? _vc.play() : _vc.pause();
    }
  }

  @override
  void dispose() {
    _vc.removeListener(_onPlaybackChanged);
    _vc.dispose();
    super.dispose();
  }

  Future<void> _toggleProductCard() async {
    if (_product == null) {
      final productId = widget.data['productId'] as String;
      _product = await Get.find<ProductRepository>().getById(productId);
      if (!mounted) return;
    }
    setState(() => _productExpanded = true);
  }

  void _closeProductCard() => setState(() => _productExpanded = false);

  Widget _buildPillContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 13),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            widget.data['product'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedCard() {
    final p = _product!;
    final img = p.imageUrls.isNotEmpty ? p.imageUrls.first : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (img != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  img,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _cardBadge('Mall', const Color(0xFFF37021), Colors.white),
                      const SizedBox(width: 4),
                      _cardBadgeOutline('ORI', const Color(0xFF4CAF50)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF5A623),
                        size: 13,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 11, color: kSubtext),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp${_fmtNum(p.price.toInt())}',
                        style: const TextStyle(
                          color: kPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _closeProductCard,
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.close, size: 16, color: kSubtext),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF37021),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              'Beli Sekarang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardBadge(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Text(
      text,
      style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );

  Widget _cardBadgeOutline(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(3),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );

  String _fmtNum(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _showCommentSheet(BuildContext context) {
    _vc.pause();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _CommentSheet(commentCount: widget.data['comments'] as String),
    ).then((_) {
      if (mounted && widget.isActive) _vc.play();
    });
  }

  void _showShareSheet(BuildContext context) {
    _vc.pause();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ShareSheet(),
    ).then((_) {
      if (mounted && widget.isActive) _vc.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBarBottom = MediaQuery.of(context).padding.bottom;
    return Stack(
      fit: StackFit.expand,
      children: [
        _ready
            ? GestureDetector(
                onTap: () {
                  if (_vc.value.isPlaying) {
                    _vc.pause();
                  } else {
                    _vc.play();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: navBarBottom),
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: _vc.value.size.width,
                        height: _vc.value.size.height,
                        child: VideoPlayer(_vc),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.data['colorTop'] as Color,
                      widget.data['colorBottom'] as Color,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: navBarBottom + 20,
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onFollow,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        backgroundImage: AssetImage(
                          widget.data['avatarUrl'] as String,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: widget.isFollowed ? Colors.white : kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                                scale: animation,
                                child: RotationTransition(
                                  turns: Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: Icon(
                            widget.isFollowed ? Icons.check : Icons.add,
                            key: ValueKey(widget.isFollowed),
                            size: 12,
                            color: widget.isFollowed ? kPrimary : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _BounceLikeButton(
                isLiked: widget.isLiked,
                label: widget.data['likes'] as String,
                onTap: widget.onLike,
              ),
              const SizedBox(height: 16),
              _ActionButton(
                icon: const Icon(
                  CupertinoIcons.chat_bubble_2_fill,
                  color: Colors.white,
                  size: 28,
                ),
                label: widget.data['comments'] as String,
                onTap: () => _showCommentSheet(context),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                icon: const Icon(
                  CupertinoIcons.arrowshape_turn_up_right_fill,
                  color: Colors.white,
                  size: 28,
                ),
                label: widget.data['shares'] as String,
                onTap: () => _showShareSheet(context),
              ),
              const SizedBox(height: 16),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  gradient: const LinearGradient(
                    colors: [kPrimary, Color(0xFFFF8C42)],
                  ),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 80,
          bottom: navBarBottom + 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data['username'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.data['description'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _productExpanded ? null : _toggleProductCard,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.bottomLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    padding: _productExpanded
                        ? const EdgeInsets.all(10)
                        : const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                    decoration: BoxDecoration(
                      color: _productExpanded
                          ? Colors.white.withValues(alpha: 0.96)
                          : kPrimary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(
                        _productExpanded ? 12 : 20,
                      ),
                    ),
                    child: _productExpanded && _product != null
                        ? _buildExpandedCard()
                        : _buildPillContent(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 13),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.data['music'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BounceLikeButton extends StatefulWidget {
  final bool isLiked;
  final String label;
  final VoidCallback onTap;

  const _BounceLikeButton({
    required this.isLiked,
    required this.label,
    required this.onTap,
  });

  @override
  State<_BounceLikeButton> createState() => _BounceLikeButtonState();
}

class _BounceLikeButtonState extends State<_BounceLikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 2.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 0.75), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.2), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _ac.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          ScaleTransition(
            scale: _scale,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(widget.isLiked),
                color: widget.isLiked ? Colors.red : Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final col = Column(
      children: [
        icon,
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: col) : col;
  }
}

class _CommentSheet extends StatefulWidget {
  final String commentCount;
  const _CommentSheet({required this.commentCount});

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  final _likedIndices = <int>{};
  String? _replyTo;
  bool _showEmojiPicker = false;

  static const _quickEmojis = [
    '😍',
    '🥰',
    '😂',
    '🔥',
    '💖',
    '👏',
    '✨',
    '💄',
    '💅',
    '🙏',
    '❤️',
    '😊',
  ];

  static const _comments = [
    {
      'user': 'siti_cantik',
      'text': 'Bagus banget warnanya! 😍',
      'time': '2j',
      'likes': '234',
    },
    {
      'user': 'beauty_lovers',
      'text': 'Udah lama cari yang kayak gini, finally ketemu!',
      'time': '5j',
      'likes': '89',
    },
    {
      'user': 'makeup_addict',
      'text': 'Berapa harganya kak? Link belinya dong 🙏',
      'time': '8j',
      'likes': '156',
    },
    {
      'user': 'glam_girl99',
      'text': 'Awet ga di bibir berminyak?',
      'time': '12j',
      'likes': '67',
    },
    {
      'user': 'kosmetik_murah',
      'text': 'Cocok banget untuk kulit sawo matang 🥰',
      'time': '1h',
      'likes': '312',
    },
    {
      'user': 'cantik_alami',
      'text': 'Aku udah beli, memang bagus! Recommended!',
      'time': '1h',
      'likes': '445',
    },
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      if (_likedIndices.contains(index)) {
        _likedIndices.remove(index);
      } else {
        _likedIndices.add(index);
      }
    });
  }

  void _startReply(String username) {
    setState(() {
      _replyTo = username;
      _showEmojiPicker = false;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyTo = null);
    _ctrl.clear();
  }

  void _insertEmoji(String emoji) {
    final sel = _ctrl.selection;
    final text = _ctrl.text;
    final newText = sel.isValid
        ? text.replaceRange(sel.start, sel.end, emoji)
        : text + emoji;
    _ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: sel.isValid ? sel.start + emoji.length : newText.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${widget.commentCount} Komentar',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _comments.length,
              itemBuilder: (context, i) {
                final c = _comments[i];
                final liked = _likedIndices.contains(i);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: kPrimary,
                        child: Text(
                          c['user']![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  c['user']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  c['time']!,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              c['text']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _startReply(c['user']!),
                              child: const Text(
                                'Balas',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _toggleLike(i),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                key: ValueKey(liked),
                                color: liked ? Colors.red : Colors.white38,
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c['likes']!,
                              style: TextStyle(
                                color: liked ? Colors.red : Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_replyTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: Colors.white10,
              child: Row(
                children: [
                  Text(
                    'Membalas @$_replyTo',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          if (_showEmojiPicker)
            Container(
              height: 48,
              color: const Color(0xFF252525),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: _quickEmojis
                    .map(
                      (e) => GestureDetector(
                        onTap: () => _insertEmoji(e),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          child: Text(e, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 22,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: kPrimary,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: _replyTo != null
                          ? 'Balas @$_replyTo...'
                          : 'Tambahkan komentar...',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white54,
                            ),
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(
                                () => _showEmojiPicker = !_showEmojiPicker,
                              );
                              if (!_showEmojiPicker) _focusNode.requestFocus();
                            },
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              // Handle sending comment
                              _ctrl.clear();
                              _cancelReply();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet();

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        icon: Icons.message_rounded,
        label: 'WhatsApp',
        color: const Color(0xFF25D366),
      ),
      (
        icon: Icons.camera_alt_rounded,
        label: 'Instagram',
        color: const Color(0xFFE1306C),
      ),
      (icon: Icons.facebook, label: 'Facebook', color: const Color(0xFF1877F2)),
      (
        icon: Icons.link_rounded,
        label: 'Salin Link',
        color: const Color(0xFF5C6BC0),
      ),
      (icon: Icons.sms_rounded, label: 'SMS', color: const Color(0xFF26A69A)),
      (
        icon: Icons.more_horiz_rounded,
        label: 'Lainnya',
        color: const Color(0xFF78909C),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bagikan ke',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options
                  .map(
                    (o) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: o.color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(o.icon, color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            o.label,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _MiniProductCard extends StatelessWidget {
  final ProductModel product;
  const _MiniProductCard({required this.product});

  String _fmtPrice(double p) {
    final s = p.toInt().toString();
    final buf = StringBuffer('Rp');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _fmtSold(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}RB+ terjual';
    return '$n terjual';
  }

  @override
  Widget build(BuildContext context) {
    final img = product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: img != null
                          ? Image.asset(
                              img,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 90,
                              height: 90,
                              color: kPrimaryLight,
                            ),
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF37021),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              'Mall',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              'ORI',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF5A623),
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: kText),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.local_shipping_outlined,
                            color: Color(0xFF4CAF50),
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'Besok 12:00',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _fmtPrice(product.price),
                        style: const TextStyle(
                          color: kPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _fmtSold(product.soldCount),
                        style: const TextStyle(color: kSubtext, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.close, color: kSubtext, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              14,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF37021),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedToggle extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FeedToggle({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            child: Text(label),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isActive ? 20 : 0,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
