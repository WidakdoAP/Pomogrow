import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';
import '../../domain/entities/banner_promo.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerPromo> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late final PageController controller;
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 1.0); // 0.92 or 0.9 For that carousel feel.
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (controller.hasClients && widget.banners.isNotEmpty) {
        currentPage = (currentPage + 1) % widget.banners.length;
        controller.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: controller,
        itemCount: widget.banners.length,
        itemBuilder: (context, index) {
          final banner = widget.banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppPalette.barColor,
                borderRadius: BorderRadius.circular(16),
               ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          style: const TextStyle(
                            color: AppPalette.bannerTitle,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner.desc,
                          style: const TextStyle(
                            color: AppPalette.textTitleColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
