import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  int _feedType = 0; // 0=For You, 1=Following

  static const _videos = [
    {
      'username': '@beautybysarah_id',
      'description': 'Tutorial makeup natural untuk sehari-hari ✨ #makeuptutorial #naturalmakeup #fyp',
      'product': 'NARS Radiant Creamy Foundation',
      'likes': '124.2K',
      'comments': '1.2K',
      'shares': '892',
      'music': 'Original Sound - beautybysarah',
      'colorTop': Color(0xFFFF6B9D),
      'colorBottom': Color(0xFF7B2FF7),
      'liked': false,
    },
    {
      'username': '@glowwithrina',
      'description': 'Skincare routine pagi hari yang bikin kulit glowing 🌟 #skincare #morningroutine',
      'product': 'Laneige Water Sleeping Mask',
      'likes': '89.5K',
      'comments': '756',
      'shares': '1.1K',
      'music': 'Chill Vibes - lofi mix',
      'colorTop': Color(0xFF4ECDC4),
      'colorBottom': Color(0xFF2C3E50),
      'liked': false,
    },
    {
      'username': '@makeupbynadia',
      'description': 'Review lipstik viral yang lagi hits! Worth it gak? 💄 #lipstickreview #viral',
      'product': 'Bourjois Rouge Edition Velvet',
      'likes': '203.7K',
      'comments': '3.4K',
      'shares': '2.8K',
      'music': 'As It Was - Harry Styles',
      'colorTop': Color(0xFFEE2D7E),
      'colorBottom': Color(0xFFFF8C42),
      'liked': false,
    },
    {
      'username': '@skincarejunkie.id',
      'description': 'Kalau kulit kering wajib pakai ini!! Game changer banget 😍 #dryskin #skincaretips',
      'product': 'CeraVe Moisturizing Cream',
      'likes': '67.3K',
      'comments': '912',
      'shares': '445',
      'music': 'Stay - Justin Bieber',
      'colorTop': Color(0xFF6C63FF),
      'colorBottom': Color(0xFF3B1F8C),
      'liked': false,
    },
    {
      'username': '@beautyhaul.indonesia',
      'description': 'Haul beauty produk lokal terbaik bulan ini! Semua harganya terjangkau 🛍️',
      'product': 'Wardah Lightening Series',
      'likes': '155.0K',
      'comments': '2.1K',
      'shares': '3.2K',
      'music': 'Flowers - Miley Cyrus',
      'colorTop': Color(0xFFFF9A9E),
      'colorBottom': Color(0xFFFAD0C4),
      'liked': false,
    },
  ];

  final _likedState = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            itemBuilder: (context, index) => _VideoPage(
              data: _videos[index],
              isLiked: _likedState[index],
              onLike: () => setState(() => _likedState[index] = !_likedState[index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FeedToggle(
                    label: 'Following',
                    isActive: _feedType == 1,
                    onTap: () => setState(() => _feedType = 1),
                  ),
                  const SizedBox(width: 20),
                  _FeedToggle(
                    label: 'For You',
                    isActive: _feedType == 0,
                    onTap: () => setState(() => _feedType = 0),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white, size: 24),
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

class _VideoPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLiked;
  final VoidCallback onLike;

  const _VideoPage({required this.data, required this.isLiked, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [data['colorTop'] as Color, data['colorBottom'] as Color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 72,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ),
        Container(
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
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              _ActionButton(
                widget: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                label: '',
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                iconColor: isLiked ? Colors.red : Colors.white,
                label: data['likes'] as String,
                onTap: onLike,
              ),
              const SizedBox(height: 16),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: data['comments'] as String,
              ),
              const SizedBox(height: 16),
              _ActionButton(
                icon: Icons.share_outlined,
                label: data['shares'] as String,
              ),
              const SizedBox(height: 16),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  gradient: const LinearGradient(
                    colors: [kPrimary, Color(0xFFFF8C42)],
                  ),
                ),
                child: const Icon(Icons.music_note, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 80,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['username'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data['description'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        data['product'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                      data['music'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
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

class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String label;
  final VoidCallback? onTap;
  final Widget? widget;

  const _ActionButton({
    this.icon,
    this.iconColor,
    required this.label,
    this.onTap,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          widget ??
              Icon(
                icon!,
                color: iconColor ?? Colors.white,
                size: 30,
              ),
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
      ),
    );
  }
}

class _FeedToggle extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FeedToggle({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              fontSize: 15,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 3),
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
