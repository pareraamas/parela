import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/story_controller.dart';

class StoryView extends GetView<StoryController> {
  const StoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          final story = controller.currentStory;
          final color = story['color'] as Color;
          final label = story['label'] as String;
          final avatarUrl = story['avatarUrl'] as String?;

          return GestureDetector(
            onTapDown: (details) {
              final w = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < w / 2) {
                controller.goPrev();
              } else {
                controller.goNext();
              }
            },
            onLongPressStart: (_) => controller.pause(),
            onLongPressEnd: (_) => controller.resume(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Video / fallback background ───────────────────────
                _StoryContent(controller: controller, fallbackColor: color),

                // Top gradient for readability
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // ── Progress bars ─────────────────────────────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 12,
                  right: 12,
                  child: Row(
                    children: List.generate(
                      controller.stories.length,
                      (i) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _ProgressBar(
                            filled: i < controller.currentIndex.value,
                            active: i == controller.currentIndex.value,
                            progressController: controller.progressController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Header ────────────────────────────────────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top + 22,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: avatarUrl != null
                              ? Image.asset(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, e, s) => const Icon(
                                    Icons.store,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                              : const Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black38),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: Get.back,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Pause indicator ───────────────────────────────────
                Obx(
                  () => controller.isPaused.value
                      ? const Center(
                          child: Icon(
                            Icons.pause_circle_filled,
                            size: 64,
                            color: Colors.white54,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Story content (video or fallback gradient) ─────────────────────────────────

class _StoryContent extends StatelessWidget {
  final StoryController controller;
  final Color fallbackColor;

  const _StoryContent({
    required this.controller,
    required this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isVideoLoading.value;
      final vc = controller.videoController;

      if (!isLoading && vc != null && vc.value.isInitialized) {
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width: vc.value.size.width,
              height: vc.value.size.height,
              child: VideoPlayer(vc),
            ),
          ),
        );
      }

      final darkColor = Color.lerp(fallbackColor, Colors.black, 0.4)!;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [fallbackColor, darkColor],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              )
            : null,
      );
    });
  }
}

// ── Progress bar ───────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final bool filled;
  final bool active;
  final AnimationController progressController;

  const _ProgressBar({
    required this.filled,
    required this.active,
    required this.progressController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: active
            ? AnimatedBuilder(
                animation: progressController,
                builder: (context, _) => LinearProgressIndicator(
                  value: progressController.value,
                  backgroundColor: Colors.white38,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : LinearProgressIndicator(
                value: filled ? 1.0 : 0.0,
                backgroundColor: Colors.white38,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
      ),
    );
  }
}
