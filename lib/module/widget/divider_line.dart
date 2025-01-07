import 'package:flutter/material.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      color: AppColorStyle.grey,
    );
  }
}
