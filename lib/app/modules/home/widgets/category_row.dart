import 'package:flutter/material.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/theme/app_colors.dart';

class CategoryRow extends StatelessWidget {
  final List<CategoryModel> categories;
  final void Function(CategoryModel)? onTap;

  const CategoryRow({super.key, required this.categories, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(categories.length, (index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () => onTap?.call(cat),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [cat.color, Colors.white],
                          radius: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(cat.icon, color: kPrimary, size: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.label,
                      style: const TextStyle(fontSize: 11, color: kText),
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
