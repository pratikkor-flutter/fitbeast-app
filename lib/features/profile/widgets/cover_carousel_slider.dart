import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CoverImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const CoverImageCarousel({super.key, required this.imageUrls});

  @override
  State<CoverImageCarousel> createState() => _CoverImageCarouselState();
}

class _CoverImageCarouselState extends State<CoverImageCarousel> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.imageUrls.length,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() => current = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final imageUrl = widget.imageUrls[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
