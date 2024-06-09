import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworImageWidget extends StatelessWidget {
  final String? imageUrl;

  const CachedNetworImageWidget({
    super.key,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    String randomImage = '';

    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? randomImage,
      placeholder: (context, url) => Container(
          padding: const EdgeInsets.all(10),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Colors.white,
            ),
          )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
