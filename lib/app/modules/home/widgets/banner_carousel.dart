import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/theme/app_colors.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.banners.length,
            options: CarouselOptions(
              aspectRatio: 16 / 7,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 600),
              viewportFraction: 0.97,
              enlargeCenterPage: true,
              enlargeFactor: 0.1,
              onPageChanged: (i, _) => setState(() => _current = i),
            ),
            itemBuilder: (context, index, realIndex) {
              final b = widget.banners[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: b.imageUrl != null
                    ? _ImageBanner(banner: b)
                    : _GradientBanner(banner: b),
              );
            },
          ),
          Positioned(
            bottom: 4,
            left: 10,
            child: Row(
              children: List.generate(widget.banners.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 5),
                  width: i == _current ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _current ? kPrimary : kPrimaryLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBanner extends StatelessWidget {
  final BannerModel banner;

  const _ImageBanner({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      banner.imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, _, _) => _GradientBanner(banner: banner),
    );
  }
}

class _GradientBanner extends StatelessWidget {
  final BannerModel banner;

  const _GradientBanner({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [banner.colorStart, banner.colorEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      banner.tag,
                      style: const TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: kSubtext, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 120,
            color: banner.colorStart.withValues(alpha: 0.4),
            child: const Center(
              child: Icon(Icons.spa, size: 56, color: kPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
