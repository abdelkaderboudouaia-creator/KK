import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCategoriesGame extends StatelessWidget {
  final List<String> categories;
  final void Function(int index)? onSelect;

  const CustomCategoriesGame({
    super.key,
    required this.categories,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.put(CategoriesController());

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Obx(() => ElevatedButton(
            onPressed: () {
              controller.selectCategory(index);
              if (onSelect != null) onSelect!(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.selectedIndex.value == index
                  ? Get.theme.primaryColor
                  : Get.isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[200],
              foregroundColor: controller.selectedIndex.value == index
                  ? Colors.white
                  : Get.isDarkMode
                  ? Colors.white70
                  : Colors.black87,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'BalooBhaijaan2'
              ),
            ),
            child: Text(categories[index].tr),
          ));
        },
      ),
    );
  }
}


class CategoriesPlaceholder extends StatelessWidget {
  const CategoriesPlaceholder ({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
          );
        },
      ),
    );
  }
}

class CategoriesController extends GetxController {
  final selectedIndex = 0.obs;

  void selectCategory(int index) {
    selectedIndex.value = index;
  }
}
