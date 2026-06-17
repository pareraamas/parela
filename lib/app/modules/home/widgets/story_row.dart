import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class StoryRow extends StatelessWidget {
  final List<Map<String, dynamic>> stories;

  const StoryRow({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kPrimary, width: 2.5),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: story['color'] as Color,
                    child: const Icon(Icons.image, color: Colors.white, size: 22),
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
          );
        },
      ),
    );
  }
}
