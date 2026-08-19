import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MuteMateRecommendation extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String imageUrl;

  // Optional fields
  final String? authorName;
  final String? authorImage;
  final bool isOriginal;

  const MuteMateRecommendation({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.imageUrl,
    this.authorName,
    this.authorImage,
    this.isOriginal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withValues(alpha: .05),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),

                /// Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Content Section (FIXED)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 108, // ✅ controls spacing like HTML
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ KEY
                children: [
                  /// 🔸 Top Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + Bookmark
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.bookmark_border,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      /// Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  /// 🔸 Bottom Row (Author / Originals)
                  if (isOriginal)
                    Row(
                      children: const [
                        Icon(Icons.verified, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          "MuteMate Originals",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    )
                  else if (authorName != null && authorImage != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: CachedNetworkImageProvider(authorImage!),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "By $authorName",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
