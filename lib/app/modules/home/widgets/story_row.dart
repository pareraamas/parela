import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class StoryRow extends StatelessWidget {
  final List<Map<String, dynamic>> stories;
  final void Function(int index)? onTap;

  const StoryRow({super.key, required this.stories, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(stories.length, (index) {
            final story = stories[index];
            final avatarUrl = story['avatarUrl'] as String?;
            final color = story['color'] as Color;

            return GestureDetector(
              onTap: () => onTap?.call(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [kPrimary, Color(0xFFFF8FA3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: color,
                          child: avatarUrl != null
                              ? ClipOval(
                                  child: Image.asset(
                                    avatarUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context2, e, s) => const Icon(
                                      Icons.store,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 22,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 64,
                      child: Text(
                        story['label'] as String,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: kText),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
