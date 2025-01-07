import 'package:flutter/material.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';

class LoadingCircular extends StatelessWidget {
  const LoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColorStyle.blue),
        strokeWidth: 6.0,
      ),
    );
  }
}
