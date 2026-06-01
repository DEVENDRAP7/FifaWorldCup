import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Country flag with subtle tinted background so flag whites don't merge with card.
class FlagImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  const FlagImage({super.key, required this.url, this.width = 44, this.height = 30, this.radius = 4});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        width: width, height: height,
        decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(radius)),
      );
    }
    return Container(
      width: width, height: height,
      padding: const EdgeInsets.all(1.2),                  // creates frame effect
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFD7DEE8), Color(0xFFB8C2D1)],  // metallic silver frame
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1)),
          BoxShadow(color: Color(0x08000000), blurRadius: 1, spreadRadius: 0),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius - 1),
          color: const Color(0xFFEEF2F7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 1),
          child: Stack(fit: StackFit.expand, children: [
            CachedNetworkImage(
              imageUrl: url, fit: BoxFit.cover,
              errorWidget: (_, _, _) => const SizedBox.shrink(),
              placeholder: (_, _) => Container(color: const Color(0xFFEEF2F7)),
            ),
            // Inner highlight gloss (top sheen)
            Positioned(
              top: 0, left: 0, right: 0, height: height * 0.35,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.white.withValues(alpha: 0.18), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Use directly inside Container/SizedBox slots that already size the flag.
class FlagInline extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  const FlagInline({super.key, required this.url, required this.width, required this.height});
  @override
  Widget build(BuildContext context) => FlagImage(url: url, width: width, height: height, radius: 3);
}
