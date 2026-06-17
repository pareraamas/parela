import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: kSubtext, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'What are you looking for?',
              style: TextStyle(color: kSubtext, fontSize: 14),
            ),
          ),
          Icon(Icons.mic_outlined, color: kSubtext, size: 20),
        ],
      ),
    );
  }
}
