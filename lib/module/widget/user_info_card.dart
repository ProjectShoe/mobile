import 'package:flutter/material.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/core/constants/resources.dart';
import 'package:shoes_store/core/theme/app_color_style.dart';
import 'package:shoes_store/core/theme/app_text_style.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.name,
    required this.id,
    required this.sizeImage,
  });
  final String name;
  final String id;
  final double sizeImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: sizeImage,
          height: sizeImage,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              ProductPath.defaulUser,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 7,
            ),
            Text(
              name,
              style: AppTextStyle.s18_semiBold
                  .copyWith(color: AppColorStyle.black),
            ),
            Text(
              id,
              style: AppTextStyle.s14_regular
                  .copyWith(color: AppColorStyle.subtitle),
            )
          ],
        )
      ],
    );
  }
}
