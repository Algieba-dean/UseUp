import 'dart:io';
import 'package:flutter/material.dart';
import 'package:use_up/src/utils/image_path_helper.dart';

class ItemImage extends StatelessWidget {
  final String? imagePath;
  final double height;
  final double width;
  final double borderRadius;

  const ItemImage({
    super.key, 
    required this.imagePath, 
    this.height = 200, 
    this.width = double.infinity,
    this.borderRadius = 20
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return const SizedBox.shrink();

    return FutureBuilder<String?>(
      future: ImagePathHelper.getDisplayPath(imagePath),
      builder: (context, snapshot) {
        final resolvedPath = snapshot.data;
        if (resolvedPath == null) return const SizedBox.shrink();

        return Container(
          width: width, 
          height: height, 
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius), 
            image: DecorationImage(
              image: FileImage(File(resolvedPath)), 
              fit: BoxFit.cover
            )
          ),
        );
      },
    );
  }
}
