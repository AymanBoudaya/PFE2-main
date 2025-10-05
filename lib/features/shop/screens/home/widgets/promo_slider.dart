import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/home_controller.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key,
    required this.banners,
  });
  final List<String> banners;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final maxBannerWidth = 600.0;

        return Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: isLargeScreen
                    ? BoxConstraints(maxWidth: maxBannerWidth)
                    : const BoxConstraints(),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    onPageChanged: (index, _) =>
                        controller.updatePageIndicator(index),
                  ),
                  items: banners
                      .map((url) => TRoundedImage(imageUrl: url))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
            Center(
              child: Obx(
                () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(banners.length, (i) {
                      final isActive =
                          controller.carousalCurrentIndex.value == i;
                      return AnimatedContainer(
                        duration: const Duration(microseconds: 300),
                        width: isActive ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.6),
                                      blurRadius: 6,
                                    )
                                  ]
                                : []),
                      );
                    })),
              ),
            ),
          ],
        );
      },
    );
  }
}
