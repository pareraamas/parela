import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? fallbackColor;
  final Widget? fallbackIcon;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackColor,
    this.fallbackIcon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildImage();
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _buildImage() {
    if (url == null || url!.isEmpty) return _fallback();

    if (url!.startsWith('assets/')) {
      return Image.asset(
        url!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, _) => _fallback(),
      );
    }

    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) => _loading(),
      errorWidget: (context, url, _) => _fallback(),
    );
  }

  Widget _loading() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? kPrimaryLight,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? kPrimaryLight,
      child: Center(
        child: fallbackIcon ??
            const Icon(Icons.image_outlined, color: Colors.white54, size: 32),
      ),
    );
  }
}
